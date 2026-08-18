import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { queryOne } from '../services/database.service';

export interface AuthenticatedRequest extends Request {
  doctor?: {
    id: number;
    email: string;
    name: string;
  };
}

export async function requireDoctorAuth(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Unauthorized',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, env.jwtSecret) as { id: number; email: string };
    const doctor = await queryOne<{ id: number; email: string; name: string }>(
      'SELECT id, email, name FROM doctors WHERE id = ?',
      [decoded.id],
    );

    if (!doctor) {
      return res.status(401).json({
        success: false,
        message: 'Invalid doctor session',
      });
    }

    req.doctor = {
      id: doctor.id,
      email: doctor.email,
      name: doctor.name,
    };

    return next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: 'Invalid or expired token',
    });
  }
}
