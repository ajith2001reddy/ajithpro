-- Creating Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) CHECK (Role IN ('Admin', 'Doctor', 'Patient'))
);

-- Creating Patients Table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE,
    Contact VARCHAR(15),
    Address VARCHAR(255),
    MedicalHistory TEXT,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Creating Doctors Table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100),
    Contact VARCHAR(15),
    Address VARCHAR(255),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Creating Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE
);

-- Creating Medical Records Table
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Diagnosis TEXT NOT NULL,
    Treatment TEXT NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE
);

-- Creating Admins Table (Additional Table)
CREATE TABLE Admins (
    AdminID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(15),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Creating Billing Table (Additional Table)
CREATE TABLE Billing (
    BillID INT PRIMARY KEY,
    AppointmentID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE CASCADE
);

-- Creating Specializations Table (Additional Table)
CREATE TABLE Specializations (
    SpecialtyID INT PRIMARY KEY,
    SpecialtyName VARCHAR(100) NOT NULL
);

-- Creating an Index on Appointments for faster searching by DoctorID
CREATE INDEX idx_doctor ON Appointments(DoctorID);

-- Creating an Index on Appointments for faster searching by PatientID
CREATE INDEX idx_patient ON Appointments(PatientID);

-- Creating a View: All Active Appointments
CREATE VIEW ActiveAppointments AS
SELECT 
    a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName, a.Date, a.Time, a.Status
FROM 
    Appointments a
JOIN 
    Patients p ON a.PatientID = p.PatientID
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    a.Status = 'Scheduled';

DELIMITER $$

CREATE TRIGGER UpdateAppointmentStatus
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.Date < CURRENT_DATE AND NEW.Status = 'Scheduled' THEN
        UPDATE Appointments
        SET Status = 'Completed'
        WHERE AppointmentID = NEW.AppointmentID;
    END IF;
END$$

DELIMITER ;

