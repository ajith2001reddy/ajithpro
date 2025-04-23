import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Ajithreddy@2001",
    database="clinic_db"
)

cursor = db.cursor()

# Insert sample data into Patients
cursor.execute("INSERT INTO Patients (Name, Contact, DOB) VALUES ('John Doe', '1234567890', '1985-05-10')")
cursor.execute("INSERT INTO Patients (Name, Contact, DOB) VALUES ('Jane Doe', '0987654321', '1990-08-20')")

# Insert sample data into Doctors
cursor.execute("INSERT INTO Doctors (Name, Specialty, DepartmentID) VALUES ('Dr. Smith', 'Cardiology', 1)")
cursor.execute("INSERT INTO Doctors (Name, Specialty, DepartmentID) VALUES ('Dr. Johnson', 'Orthopedics', 2)")

# Insert sample data into Departments
cursor.execute("INSERT INTO Departments (Name, Location) VALUES ('Cardiology', 'Building A')")
cursor.execute("INSERT INTO Departments (Name, Location) VALUES ('Orthopedics', 'Building B')")

# Insert sample data into Appointments
cursor.execute("INSERT INTO Appointments (PatientID, DoctorID, Date, Time, Status) VALUES (1, 1, '2023-12-01', '09:00:00', 'Scheduled')")
cursor.execute("INSERT INTO Appointments (PatientID, DoctorID, Date, Time, Status) VALUES (2, 2, '2023-12-02', '10:00:00', 'Scheduled')")

# Insert sample data into MedicalRecords
cursor.execute("INSERT INTO MedicalRecords (PatientID, Diagnosis, Treatment) VALUES (1, 'Hypertension', 'Medication A')")
cursor.execute("INSERT INTO MedicalRecords (PatientID, Diagnosis, Treatment) VALUES (2, 'Diabetes', 'Medication B')")

db.commit()
cursor.close()
db.close()
