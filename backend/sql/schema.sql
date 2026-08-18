CREATE DATABASE IF NOT EXISTS hospital_clinic;
USE hospital_clinic;

CREATE TABLE clinics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE doctors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  clinic_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  specialization VARCHAR(150) NOT NULL,
  status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'INACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_doctors_clinic FOREIGN KEY (clinic_id) REFERENCES clinics(id)
);

CREATE TABLE patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  age INT NOT NULL,
  gender VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  doctor_id INT NOT NULL,
  patient_id INT NOT NULL,
  token_number INT NOT NULL,
  status ENUM('WAITING', 'SERVING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'WAITING',
  booking_date DATE NOT NULL,
  booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  started_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,
  cancelled_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tokens_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id),
  CONSTRAINT fk_tokens_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
  UNIQUE KEY uq_doctor_day_token (doctor_id, booking_date, token_number)
);

CREATE INDEX idx_doctors_clinic ON doctors(clinic_id);
CREATE INDEX idx_tokens_doctor_date ON tokens(doctor_id, booking_date, status, token_number);
CREATE INDEX idx_tokens_patient ON tokens(patient_id);
