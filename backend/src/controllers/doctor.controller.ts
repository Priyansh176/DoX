import { Response } from 'express';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { db, queryOne } from '../services/database.service';
import { emitDoctorQueueUpdate, emitDoctorStatusUpdate } from '../sockets/queue.socket';
import { errorResponse, successResponse } from '../utils/response';

const statusSchema = z.object({
  status: z.enum(['ACTIVE', 'INACTIVE']),
});

export async function getDoctorProfile(req: AuthenticatedRequest, res: Response) {
  const doctor = await queryOne<{
    id: number;
    name: string;
    email: string;
    specialization: string;
    status: 'ACTIVE' | 'INACTIVE';
  }>(
    'SELECT id, name, email, specialization, status FROM doctors WHERE id = ?',
    [req.doctor!.id],
  );

  if (!doctor) {
    return res.status(404).json(errorResponse('Doctor not found'));
  }

  return res.json(successResponse({
    id: doctor.id,
    name: doctor.name,
    email: doctor.email,
    specialization: doctor.specialization,
    status: doctor.status,
  }));
}

export async function getDoctorQueue(req: AuthenticatedRequest, res: Response) {
  const [rows] = await db.execute<
    {
      id: number;
      token_number: number;
      status: 'WAITING' | 'SERVING' | 'COMPLETED' | 'CANCELLED';
      patient_name: string;
      booked_at: Date;
    }[] & any[]
  >(
    `SELECT t.id, t.token_number, t.status, p.name AS patient_name, t.booked_at
     FROM tokens t
     LEFT JOIN patients p ON p.id = t.patient_id
     WHERE t.doctor_id = ? AND t.booking_date = CURDATE()
     ORDER BY t.token_number ASC`,
    [req.doctor!.id],
  );

  const queueRows = rows as Array<{
    id: number;
    token_number: number;
    status: 'WAITING' | 'SERVING' | 'COMPLETED' | 'CANCELLED';
    patient_name: string;
    booked_at: Date;
  }>;

  const currentToken = queueRows.find((row) => row.status === 'SERVING');
  const waitingCount = queueRows.filter((row) => row.status === 'WAITING').length;

  return res.json(successResponse({
    doctorId: req.doctor!.id,
    currentToken: currentToken ? currentToken.token_number : null,
    waitingCount,
    queue: queueRows.map((row) => ({
      tokenId: row.id,
      tokenNumber: row.token_number,
      patientName: row.patient_name,
      status: row.status,
      bookedAt: row.booked_at,
    })),
  }));
}

export async function advanceDoctorQueue(req: AuthenticatedRequest, res: Response) {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const [rows] = await connection.execute<any[]>(`SELECT id, token_number, status
      FROM tokens
      WHERE doctor_id = ? AND booking_date = CURDATE()
      ORDER BY token_number ASC`, [req.doctor!.id]);

    const queueRows = rows as Array<{
      id: number;
      token_number: number;
      status: 'WAITING' | 'SERVING' | 'COMPLETED' | 'CANCELLED';
    }>;

    const servingToken = queueRows.find((row) => row.status === 'SERVING');
    let completedToken: number | null = null;

    if (servingToken) {
      await connection.execute(
        'UPDATE tokens SET status = ?, completed_at = ? WHERE id = ?',
        ['COMPLETED', new Date(), servingToken.id],
      );
      completedToken = servingToken.token_number;
    }

    const waitingToken = servingToken
      ? null
      : queueRows.find((row) => row.status === 'WAITING');
    let currentToken: number | null = null;

    if (waitingToken) {
      await connection.execute(
        'UPDATE tokens SET status = ?, started_at = ? WHERE id = ?',
        ['SERVING', new Date(), waitingToken.id],
      );
      currentToken = waitingToken.token_number;
    }

    await connection.commit();

    const message = servingToken
      ? 'Current token completed'
      : currentToken
        ? 'Next token started'
        : 'No waiting patients';

    emitDoctorQueueUpdate(req.doctor!.id, {
      type: 'queue-updated',
      completedToken,
      currentToken,
      message,
    });

    return res.json(successResponse({
      completedToken,
      currentToken,
      message,
    }));
  } catch (error: any) {
    await connection.rollback();
    return res.status(500).json(errorResponse(error.message || 'Unable to advance queue'));
  } finally {
    connection.release();
  }
}

export async function getDoctorStatus(req: AuthenticatedRequest, res: Response) {
  const doctor = await queryOne<{ status: 'ACTIVE' | 'INACTIVE' }>(
    'SELECT status FROM doctors WHERE id = ?',
    [req.doctor!.id],
  );

  return res.json(successResponse({
    status: doctor?.status || 'INACTIVE',
  }));
}

export async function updateDoctorStatus(req: AuthenticatedRequest, res: Response) {
  try {
    const payload = statusSchema.parse(req.body);
    const doctor = await queryOne<{ id: number }>('SELECT id FROM doctors WHERE id = ?', [req.doctor!.id]);

    if (!doctor) {
      return res.status(404).json(errorResponse('Doctor not found'));
    }

    await db.execute('UPDATE doctors SET status = ? WHERE id = ?', [payload.status, req.doctor!.id]);

    emitDoctorStatusUpdate(req.doctor!.id, {
      type: 'doctor-status-changed',
      status: payload.status,
    });

    return res.json(successResponse({
      status: payload.status,
    }));
  } catch (error: any) {
    if (error instanceof z.ZodError) {
      return res.status(400).json(errorResponse('Validation failed', error.flatten().fieldErrors));
    }

    return res.status(500).json(errorResponse('Unable to update status'));
  }
}
