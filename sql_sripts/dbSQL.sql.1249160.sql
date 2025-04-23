SELECT 
    p.Name AS PatientName, 
    a.Date AS AppointmentDate, 
    a.Time AS AppointmentTime, 
    d.Name AS DoctorName
FROM 
    Patients p
JOIN 
    Appointments a ON p.PatientID = a.PatientID
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
ORDER BY 
    a.Date, a.Time;
SELECT 
    d.Name AS DoctorName, 
    COUNT(a.AppointmentID) AS TotalAppointments
FROM 
    Doctors d
JOIN 
    Appointments a ON d.DoctorID = a.DoctorID
GROUP BY 
    d.Name
HAVING 
    COUNT(a.AppointmentID) > 1
ORDER BY 
    TotalAppointments DESC;
SELECT 
    p.Name AS PatientName, 
    d.Name AS DoctorName
FROM 
    Patients p
JOIN 
    Appointments a ON p.PatientID = a.PatientID
JOIN 
    Doctors d ON a.DoctorID = d.DoctorID
WHERE 
    p.PatientID IN (SELECT 
                        a2.PatientID 
                    FROM 
                        Appointments a2
                    GROUP BY 
                        a2.PatientID, a2.DoctorID
                    HAVING 
                        COUNT(a2.AppointmentID) > 1);
                        
                        SELECT 
    p.Name AS PatientName, 
    d.Name AS DoctorName, 
    m.Diagnosis, 
    m.Treatment, 
    m.Date AS RecordDate
FROM 
    MedicalRecords m
JOIN 
    Patients p ON m.PatientID = p.PatientID
JOIN 
    Doctors d ON m.DoctorID = d.DoctorID
WHERE 
    m.Diagnosis = 'Hypertension'
ORDER BY 
    m.Date;

SELECT 
    p.Name AS PatientName, 
    SUM(b.Amount) AS TotalBilled
FROM 
    Patients p
JOIN 
    Appointments a ON p.PatientID = a.PatientID
JOIN 
    Billing b ON a.AppointmentID = b.AppointmentID
GROUP BY 
    p.Name
ORDER BY 
    TotalBilled DESC;
