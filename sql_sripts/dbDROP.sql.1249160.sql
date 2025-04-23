
-- DROP Script (dbDROP.sql)
-- Dropping the Trigger
DROP TRIGGER IF EXISTS UpdateAppointmentStatus;

-- Dropping the View
DROP VIEW IF EXISTS ActiveAppointments;

-- Dropping the Indexes
DROP INDEX IF EXISTS idx_doctor ON Appointments;
DROP INDEX IF EXISTS idx_patient ON Appointments;

-- Dropping the Foreign Key Constraints and Tables
ALTER TABLE MedicalRecords DROP CONSTRAINT IF EXISTS fk_MedicalRecords_PatientID;
ALTER TABLE MedicalRecords DROP CONSTRAINT IF EXISTS fk_MedicalRecords_DoctorID;
ALTER TABLE Appointments DROP CONSTRAINT IF EXISTS fk_Appointments_PatientID;
ALTER TABLE Appointments DROP CONSTRAINT IF EXISTS fk_Appointments_DoctorID;
ALTER TABLE Patients DROP CONSTRAINT IF EXISTS fk_Patients_UserID;
ALTER TABLE Doctors DROP CONSTRAINT IF EXISTS fk_Doctors_UserID;
ALTER TABLE Admins DROP CONSTRAINT IF EXISTS fk_Admins_UserID;
ALTER TABLE Billing DROP CONSTRAINT IF EXISTS fk_Billing_AppointmentID;

-- Dropping the Tables
DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS MedicalRecords;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Admins;
DROP TABLE IF EXISTS Specializations;
DROP TABLE IF EXISTS Users;
