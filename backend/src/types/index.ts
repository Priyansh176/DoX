export type DoctorStatus = 'ACTIVE' | 'INACTIVE';
export type TokenStatus = 'WAITING' | 'SERVING' | 'COMPLETED' | 'CANCELLED';

export interface Doctor {
  id: number;
  clinic_id: number;
  name: string;
  email: string;
  password_hash: string;
  specialization: string;
  status: DoctorStatus;
  created_at?: Date;
  updated_at?: Date;
}

export interface Patient {
  id: number;
  name: string;
  phone: string;
  age: number;
  gender: string;
  created_at?: Date;
  updated_at?: Date;
}

export interface Token {
  id: number;
  doctor_id: number;
  patient_id: number;
  token_number: number;
  status: TokenStatus;
  booking_date: string;
  booked_at: Date;
  started_at?: Date | null;
  completed_at?: Date | null;
  cancelled_at?: Date | null;
  created_at?: Date;
  updated_at?: Date;
}
