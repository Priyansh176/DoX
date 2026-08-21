import { Router } from 'express';
import { db } from '../services/database.service';
import { errorResponse, successResponse } from '../utils/response';

const router = Router();

router.get('/', async (_req, res) => {
  try {
    const [rows] = await db.execute<any[]>(
      `SELECT c.id AS clinic_id,
              c.name AS clinic_name,
              c.address AS clinic_address,
              c.phone AS clinic_phone,
              d.id AS doctor_id,
              d.name AS doctor_name,
              d.specialization AS doctor_specialization,
              d.status AS doctor_status
       FROM clinics c
       LEFT JOIN doctors d ON d.clinic_id = c.id
       WHERE c.is_active = TRUE
       ORDER BY c.id ASC, d.id ASC`,
    );

    const clinicMap = new Map<number, {
      id: number;
      name: string;
      address: string;
      phone: string;
      doctors: Array<{
        id: number;
        name: string;
        specialization: string;
        status: 'ACTIVE' | 'INACTIVE';
      }>;
    }>();

    for (const row of rows) {
      const clinicId = Number(row.clinic_id);

      if (!clinicMap.has(clinicId)) {
        clinicMap.set(clinicId, {
          id: clinicId,
          name: row.clinic_name,
          address: row.clinic_address,
          phone: row.clinic_phone,
          doctors: [],
        });
      }

      if (row.doctor_id) {
        clinicMap.get(clinicId)!.doctors.push({
          id: Number(row.doctor_id),
          name: row.doctor_name,
          specialization: row.doctor_specialization,
          status: row.doctor_status,
        });
      }
    }

    return res.json(successResponse({ clinics: Array.from(clinicMap.values()) }));
  } catch (error: any) {
    return res.status(500).json(errorResponse(error.message || 'Unable to load clinics'));
  }
});

export default router;
