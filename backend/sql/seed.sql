USE hospital_clinic;

INSERT INTO clinics (name, address, phone, is_active)
VALUES ('City Clinic', 'Main Road, Downtown', '9876543210', TRUE)
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO doctors (clinic_id, name, email, password_hash, specialization, status)
VALUES (
  1,
  'Dr. Sharma',
  'doctor@clinic.com',
  '$2a$10$A.361xwBhNeSlvna0xUFzO71MgpjjWmjAP4EoZnzYJijIaLpI.yz2',
  'General Physician',
  'ACTIVE'
)
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO doctors (clinic_id, name, email, password_hash, specialization, status)
VALUES (
  1,
  'Dr. Mehta',
  'doctor2@clinic.com',
  '$2a$10$A.361xwBhNeSlvna0xUFzO71MgpjjWmjAP4EoZnzYJijIaLpI.yz2',
  'Dermatologist',
  'INACTIVE'
)
ON DUPLICATE KEY UPDATE name = VALUES(name);
