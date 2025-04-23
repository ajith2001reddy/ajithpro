-- Inserting sample data into Users Table
INSERT INTO Users (UserID, Username, Password, Role) VALUES 
(1, 'admin1', 'adminpass', 'Admin'),
(2, 'doctor1', 'docpass1', 'Doctor'),
(3, 'doctor2', 'docpass2', 'Doctor'),
(4, 'patient1', 'patpass1', 'Patient'),
(5, 'patient2', 'patpass2', 'Patient'),
(6, 'patient3', 'patpass3', 'Patient'),
(7, 'admin2', 'adminpass2', 'Admin'),
(8, 'patient4', 'patpass4', 'Patient');

-- Inserting sample data into Patients Table
INSERT INTO Patients (PatientID, Name, DOB, Contact, Address, MedicalHistory, UserID) VALUES 
(1, 'John Doe', '1990-05-20', '555-1234', '123 Elm St', 'Diabetes', 4),
(2, 'Jane Smith', '1985-07-15', '555-5678', '456 Maple Ave', 'Asthma', 5),
(3, 'Michael Brown', '1975-03-30', '555-4321', '789 Pine Blvd', 'Hypertension', 6),
(4, 'Lisa Ray', '1992-11-22', '555-9876', '135 Oak Dr', 'None', 8),
(5, 'Tom Hanks', '1988-12-05', '555-6543', '246 Birch Ct', 'Anxiety', 8);

-- Inserting sample data into Doctors Table
INSERT INTO Doctors (DoctorID, Name, Specialty, Contact, Address, UserID) VALUES 
(1, 'Dr. Alice Johnson', 'Cardiology', '555-1111', '101 Heart St', 2),
(2, 'Dr. Bob Anderson', 'Neurology', '555-2222', '202 Brain Ln', 3),
(3, 'Dr. Emily Green', 'Dermatology', '555-3333', '303 Skin Ave', 2);

-- Inserting sample data into Appointments Table
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, Date, Time, Status) VALUES 
(1, 1, 1, '2025-03-30', '09:00:00', 'Scheduled'),
(2, 2, 1, '2025-03-31', '10:00:00', 'Scheduled'),
(3, 3, 2, '2025-03-30', '11:00:00', 'Scheduled'),
(4, 1, 2, '2025-03-28', '14:00:00', 'Completed'),
(5, 4, 3, '2025-04-01', '09:30:00', 'Scheduled'),
(6, 2, 3, '2025-04-02', '10:30:00', 'Scheduled'),
(7, 5, 1, '2025-03-29', '15:00:00', 'Completed');

-- Inserting sample data into MedicalRecords Table
INSERT INTO MedicalRecords (RecordID, PatientID, DoctorID, Diagnosis, Treatment, Date) VALUES 
(1, 1, 1, 'Hypertension', 'Medication prescribed', '2025-03-01'),
(2, 2, 1, 'Asthma', 'Inhaler prescribed', '2025-03-10'),
(3, 3, 2, 'Chronic Headaches', 'MRI recommended', '2025-02-28'),
(4, 4, 3, 'Skin Rash', 'Ointment prescribed', '2025-03-15'),
(5, 1, 2, 'Mild Anxiety', 'Counseling recommended', '2025-03-20'),
(6, 2, 3, 'Eczema', 'Cream prescribed', '2025-03-25'),
(7, 5, 1, 'Diabetes', 'Diet and exercise plan', '2025-03-05');

-- Inserting sample data into Admins Table
INSERT INTO Admins (AdminID, Name, Contact, UserID) VALUES 
(1, 'Sarah Lee', '555-8765', 1),
(2, 'David Wong', '555-9987', 7);

-- Inserting sample data into Billing Table
INSERT INTO Billing (BillID, AppointmentID, Amount, PaymentStatus) VALUES 
(1, 1, 150.00, 'Paid'),
(2, 2, 200.00, 'Pending'),
(3, 3, 250.00, 'Paid'),
(4, 4, 300.00, 'Paid'),
(5, 5, 180.00, 'Pending'),
(6, 6, 160.00, 'Pending'),
(7, 7, 120.00, 'Paid');

-- Inserting sample data into Specializations Table
INSERT INTO Specializations (SpecialtyID, SpecialtyName) VALUES 
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Dermatology'),
(4, 'Pediatrics'),
(5, 'Orthopedics');

-- Updating the status of an appointment
UPDATE Appointments 
SET Status = 'Completed'
WHERE AppointmentID = 5;

-- Deleting a patient record
DELETE FROM Patients
WHERE PatientID = 5;
