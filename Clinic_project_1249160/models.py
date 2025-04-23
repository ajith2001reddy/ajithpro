import mysql.connector

# Establishing the connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Ajithreddy@2001"
)

cursor = db.cursor()

# Creating database
cursor.execute("CREATE DATABASE IF NOT EXISTS clinic_db")

# Selecting the database
cursor.execute("USE clinic_db")

# Creating Patients table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Contact VARCHAR(255),
    DOB DATE
)
""")

# Creating Doctors table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Specialty VARCHAR(255),
    DepartmentID INT
)
""")

# Creating Departments table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255)
)
""")

# Creating Appointments table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Date DATE,
    Time TIME,
    Status VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
)
""")

# Creating Medical Records table
cursor.execute("""
CREATE TABLE IF NOT EXISTS MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    Diagnosis VARCHAR(255),
    Treatment TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
)
""")

db.commit()
cursor.close()
db.close()
