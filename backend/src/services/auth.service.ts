import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { queryOne } from './database.service';

interface DoctorRow {
  id: number;
  clinic_id: number;
  name: string;
  email: string;
  password_hash: string;
  specialization: string;
  status: 'ACTIVE' | 'INACTIVE';
}

export async function loginDoctor(email: string, password: string) {
  const doctor = await queryOne<DoctorRow>(
    'SELECT * FROM doctors WHERE email = ?',
    [email],
  );

  if (!doctor) {
    throw new Error('Invalid email or password');
  }

  const isPasswordValid = bcrypt.compareSync(password, doctor.password_hash);

  if (!isPasswordValid) {
    throw new Error('Invalid email or password');
  }

  const token = jwt.sign(
    { id: doctor.id, email: doctor.email },
    env.jwtSecret,
    { expiresIn: '8h' },
  );

  return {
    token,
    doctor: {
      id: doctor.id,
      name: doctor.name,
      email: doctor.email,
      specialization: doctor.specialization,
      status: doctor.status,
    },
  };
}
