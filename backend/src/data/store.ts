import bcrypt from 'bcryptjs';
import { Doctor, Patient, Token } from '../types';

export interface Clinic {
  id: number;
  name: string;
  address: string;
  phone: string;
  is_active: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export const clinics: Clinic[] = [
  {
    id: 1,
    name: 'City Clinic',
    address: 'Main Road, Downtown',
    phone: '9876543210',
    is_active: true,
  },
];

export const doctors: Doctor[] = [
  {
    id: 1,
    clinic_id: 1,
    name: 'Dr. Sharma',
    email: 'doctor@clinic.com',
    password_hash: bcrypt.hashSync('password123', 10),
    specialization: 'General Physician',
    status: 'ACTIVE',
  },
  {
    id: 2,
    clinic_id: 1,
    name: 'Dr. Mehta',
    email: 'doctor2@clinic.com',
    password_hash: bcrypt.hashSync('password123', 10),
    specialization: 'Dermatologist',
    status: 'ACTIVE',
  },
];

export const patients: Patient[] = [];
export const tokens: Token[] = [
  {
    id: 1,
    doctor_id: 1,
    patient_id: 1,
    token_number: 1,
    status: 'COMPLETED',
    booking_date: new Date().toISOString().split('T')[0],
    booked_at: new Date(),
    started_at: new Date(),
    completed_at: new Date(),
    cancelled_at: null,
  },
  {
    id: 2,
    doctor_id: 1,
    patient_id: 2,
    token_number: 2,
    status: 'SERVING',
    booking_date: new Date().toISOString().split('T')[0],
    booked_at: new Date(),
    started_at: new Date(),
    completed_at: null,
    cancelled_at: null,
  },
];

export function getTodayDateString() {
  return new Date().toISOString().split('T')[0];
}

export function findDoctorByEmail(email: string) {
  return doctors.find((doctor) => doctor.email.toLowerCase() === email.toLowerCase());
}

export function findDoctorById(id: number) {
  return doctors.find((doctor) => doctor.id === id);
}
