import { Request, Response } from 'express';
import { z } from 'zod';
import { errorResponse, successResponse } from '../utils/response';
import { loginDoctor } from '../services/auth.service';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

export async function loginDoctorController(req: Request, res: Response) {
  try {
    const payload = loginSchema.parse(req.body);
    const result = await loginDoctor(payload.email, payload.password);

    return res.json(successResponse({
      token: result.token,
      doctor: result.doctor,
    }));
  } catch (error: any) {
    if (error instanceof z.ZodError) {
      return res.status(400).json(errorResponse('Validation failed', error.flatten().fieldErrors));
    }

    return res.status(401).json(errorResponse(error.message || 'Invalid credentials'));
  }
}
