import { Router } from 'express';
import { Response } from 'express';
import { z } from 'zod';
import { AuthenticatedRequest, requireDoctorAuth } from '../middleware/auth.middleware';
import { db, queryOne } from '../services/database.service';
import { emitDoctorQueueUpdate } from '../sockets/queue.socket';
import { errorResponse, successResponse } from '../utils/response';

const router = Router();

const bookingSchema = z.object({
  doctorId: z.number().int().positive(),
  patient: z.object({
    name: z.string().min(1),
    phone: z.string().min(5),
    age: z.number().int().positive(),
    gender: z.string().min(1),
  }),
});

function calculatePatientsAhead(queue: Array<{ token_number: number; status: string }>, tokenNumber: number) {
  const waitingBefore = queue.filter(
    (row) => row.status === 'WAITING' && row.token_number < tokenNumber,
  ).length;

  const servingBefore = queue.some(
    (row) => row.status === 'SERVING' && row.token_number < tokenNumber,
  )
    ? 1
    : 0;

  return waitingBefore + servingBefore;
}

router.get('/:tokenId', async (req, res) => {
  const tokenId = Number(req.params.tokenId);

  const token = await queryOne<{ id: number; doctor_id: number; token_number: number; status: string; booking_date: string }>(
    'SELECT id, doctor_id, token_number, status, booking_date FROM tokens WHERE id = ?',
    [tokenId],
  );

  if (!token) {
    return res.status(404).json(errorResponse('Token not found'));
  }

  const [queueRows] = await db.execute<any[]>(
    'SELECT token_number, status FROM tokens WHERE doctor_id = ? AND booking_date = ? ORDER BY token_number ASC',
    [token.doctor_id, token.booking_date],
  );

  const queue = queueRows as Array<{ token_number: number; status: string }>;
  const patientsAhead = calculatePatientsAhead(queue, token.token_number);
  const currentToken = queue.find((row) => row.status === 'SERVING')?.token_number || null;

  return res.json(successResponse({
    tokenNumber: token.token_number,
    status: token.status,
    currentToken,
    patientsAhead,
    estimatedWaitMinutes: patientsAhead * 5,
  }));
});

router.post('/', async (req, res) => {
  try {
    const payload = bookingSchema.parse(req.body);

    const doctor = await queryOne<{ id: number; status: 'ACTIVE' | 'INACTIVE' }>(
      'SELECT id, status FROM doctors WHERE id = ?',
      [payload.doctorId],
    );

    if (!doctor) {
      return res.status(404).json(errorResponse('Doctor not found'));
    }

    if (doctor.status !== 'ACTIVE') {
      return res.status(409).json(errorResponse('Doctor is currently unavailable for new bookings.'));
    }

    const duplicatePatientToken = await queryOne<{ id: number }>(
      `SELECT t.id
       FROM tokens t
       JOIN patients p ON p.id = t.patient_id
       WHERE t.doctor_id = ?
         AND t.booking_date = CURDATE()
         AND p.phone = ?
         AND t.status IN ('WAITING', 'SERVING')`,
      [payload.doctorId, payload.patient.phone],
    );

    if (duplicatePatientToken) {
      return res.status(409).json(errorResponse('You already have an active token for this doctor today.'));
    }

    const patientResult = await db.execute(
      'INSERT INTO patients (name, phone, age, gender) VALUES (?, ?, ?, ?)',
      [payload.patient.name, payload.patient.phone, payload.patient.age, payload.patient.gender],
    );

    const patientId = (patientResult[0] as any).insertId;

    const nextTokenInsert = await db.execute(
      `INSERT INTO tokens (doctor_id, patient_id, token_number, status, booking_date)
       SELECT ?, ?, COALESCE(MAX(token_number), 0) + 1, 'WAITING', CURDATE()
       FROM tokens
       WHERE doctor_id = ? AND booking_date = CURDATE()`,
      [payload.doctorId, patientId, payload.doctorId],
    );

    const tokenId = (nextTokenInsert[0] as any).insertId;
    const token = await queryOne<{ id: number; token_number: number; status: string; doctor_id: number; booking_date: string }>(
      'SELECT id, doctor_id, token_number, status, booking_date FROM tokens WHERE id = ?',
      [tokenId],
    );

    const [queueRows] = await db.execute<any[]>(
      'SELECT token_number, status FROM tokens WHERE doctor_id = ? AND booking_date = ? ORDER BY token_number ASC',
      [payload.doctorId, token!.booking_date],
    );

    const queue = queueRows as Array<{ token_number: number; status: string }>;
    const currentToken = queue.find((row) => row.status === 'SERVING')?.token_number || null;
    const patientsAhead = calculatePatientsAhead(queue, token!.token_number);

    emitDoctorQueueUpdate(payload.doctorId, {
      type: 'queue-updated',
      action: 'token-created',
      tokenNumber: token!.token_number,
      currentToken,
      patientsAhead,
      estimatedWaitMinutes: patientsAhead * 5,
    });

    return res.status(201).json(successResponse({
      token: {
        id: token!.id,
        tokenNumber: token!.token_number,
        status: token!.status,
      },
      queue: {
        currentToken,
        patientsAhead,
        estimatedWaitMinutes: patientsAhead * 5,
      },
    }));
  } catch (error: any) {
    if (error instanceof z.ZodError) {
      return res.status(400).json(errorResponse('Validation failed', error.flatten().fieldErrors));
    }

    return res.status(500).json(errorResponse(error.message || 'Unable to create token'));
  }
});

router.patch('/:tokenId/cancel', requireDoctorAuth, async (req: AuthenticatedRequest, res: Response) => {
  const tokenId = Number(req.params.tokenId);
  const token = await queryOne<{ id: number; doctor_id: number; status: string }>(
    'SELECT id, doctor_id, status FROM tokens WHERE id = ?',
    [tokenId],
  );

  if (!token) {
    return res.status(404).json(errorResponse('Token not found'));
  }

  if (token.doctor_id !== req.doctor!.id) {
    return res.status(403).json(errorResponse('You cannot cancel another doctor\'s token'));
  }

  if (token.status !== 'WAITING') {
    return res.status(409).json(errorResponse('Only waiting tokens can be cancelled'));
  }

  await db.execute(
    'UPDATE tokens SET status = ?, cancelled_at = ? WHERE id = ?',
    ['CANCELLED', new Date(), tokenId],
  );

  emitDoctorQueueUpdate(token.doctor_id, {
    type: 'queue-updated',
    action: 'token-cancelled',
    tokenId,
    status: 'CANCELLED',
  });

  return res.json(successResponse({
    tokenId,
    status: 'CANCELLED',
  }));
});

export default router;
