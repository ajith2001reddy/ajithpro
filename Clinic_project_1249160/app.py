from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# MySQL connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Ajithreddy@2001",
    database="clinic_db"
)

# Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

# User class
class User(UserMixin):
    def __init__(self, id, username, role):
        self.id = id
        self.username = username
        self.role = role

    def __repr__(self):
        return f'<User {self.username}, Role: {self.role}>'

@login_manager.user_loader
def load_user(user_id):
    with db.cursor(dictionary=True) as cursor:
        cursor.execute("SELECT * FROM Users WHERE UserID = %s", (int(user_id),))
        user = cursor.fetchone()
    return User(user['UserID'], user['Username'], user['Role']) if user else None

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        with db.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM Users WHERE Username = %s", (username,))
            user = cursor.fetchone()

        if user and check_password_hash(user['Password'], password):
            login_user(User(user['UserID'], user['Username'], user['Role']))
            flash('Login successful!', 'success')
            return redirect(url_for('appointments'))
        flash('Invalid username or password.', 'danger')

    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        role = request.form['role'].lower()
        hashed_password = generate_password_hash(password)

        with db.cursor(dictionary=True) as cursor:
            cursor.execute("INSERT INTO Users (Username, Password, Role) VALUES (%s, %s, %s)",
                           (username, hashed_password, role))
            db.commit()

            if role == 'doctor':
                cursor.execute("INSERT INTO Doctors (Name, Contact) VALUES (%s, %s)", (username, ''))
                db.commit()

        flash('Signup successful. Please log in.', 'success')
        return redirect(url_for('login'))

    return render_template('signup.html')


@app.route('/appointments')
@login_required
def appointments():
    role = current_user.role.lower()
    username = current_user.username

    with db.cursor(dictionary=True) as cursor:
        if role == 'admin':
            cursor.execute("""
                SELECT a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName,
                       a.Date, a.Time, a.Status
                FROM Appointments a
                JOIN Patients p ON a.PatientID = p.PatientID
                JOIN Doctors d ON a.DoctorID = d.DoctorID
            """)
            appointments = cursor.fetchall()
            greeting = "All Appointments"

        elif role == 'doctor':
            cursor.execute("SELECT DoctorID FROM Doctors WHERE Name = %s", (username,))
            doctor = cursor.fetchone()

            if doctor:
                cursor.execute("""
                    SELECT a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName,
                           a.Date, a.Time, a.Status
                    FROM Appointments a
                    JOIN Patients p ON a.PatientID = p.PatientID
                    JOIN Doctors d ON a.DoctorID = d.DoctorID
                    WHERE a.DoctorID = %s
                """, (doctor['DoctorID'],))
                appointments = cursor.fetchall()
                greeting = f"Appointments for Dr. {username}"
            else:
                appointments = []
                greeting = "No appointments found."

        else:
            cursor.execute("SELECT PatientID FROM Patients WHERE Name = %s", (username,))
            patient = cursor.fetchone()

            if patient:
                cursor.execute("""
                    SELECT a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName,
                           a.Date, a.Time, a.Status
                    FROM Appointments a
                    JOIN Patients p ON a.PatientID = p.PatientID
                    JOIN Doctors d ON a.DoctorID = d.DoctorID
                    WHERE a.PatientID = %s
                """, (patient['PatientID'],))
                appointments = cursor.fetchall()
                greeting = "Your Appointments"
            else:
                appointments = []
                greeting = "No appointments found."

    return render_template('appointments.html', appointments=appointments, greeting=greeting)


@app.route('/add_appointment', methods=['GET', 'POST'])
@login_required
def add_appointment():
    with db.cursor(dictionary=True) as cursor:
        if request.method == 'POST':
            patient_name = request.form['patient_name']
            patient_dob = request.form['patient_dob']
            patient_contact = request.form['patient_contact']
            doctor_id = request.form['doctor_id']
            date = request.form['date']
            time = request.form['time']

            # Check for existing patient
            cursor.execute("""
                SELECT PatientID FROM Patients 
                WHERE Name = %s AND DOB = %s AND Contact = %s
            """, (patient_name, patient_dob, patient_contact))
            patient = cursor.fetchone()

            if not patient:
                cursor.execute("""
                    INSERT INTO Patients (Name, DOB, Contact) 
                    VALUES (%s, %s, %s)
                """, (patient_name, patient_dob, patient_contact))
                db.commit()
                cursor.execute("SELECT LAST_INSERT_ID() AS PatientID")
                patient = cursor.fetchone()

            # Create appointment
            cursor.execute("""
                INSERT INTO Appointments (PatientID, DoctorID, Date, Time, Status)
                VALUES (%s, %s, %s, %s, 'Scheduled')
            """, (patient['PatientID'], doctor_id, date, time))
            db.commit()

            return redirect(url_for('appointments'))

        cursor.execute("SELECT DoctorID, Name FROM Doctors")
        doctors = cursor.fetchall()

    return render_template('add_appointment.html', doctors=doctors)


@app.route('/patients')
@login_required
def patients():
    if current_user.role.lower() not in ['admin', 'doctor']:
        flash("Unauthorized access!", "danger")
        return redirect(url_for('index'))

    with db.cursor(dictionary=True) as cursor:
        cursor.execute("SELECT * FROM Patients")
        patients = cursor.fetchall()

    return render_template('patients.html', patients=patients)


@app.route('/doctors')
@login_required
def doctors():
    username = current_user.username
    role = current_user.role.lower()

    with db.cursor(dictionary=True) as cursor:
        if role == 'admin':
            cursor.execute("SELECT Name, Contact FROM Doctors")
            doctors = cursor.fetchall()
            greeting = "All Registered Doctors"

        elif role == 'doctor':
            cursor.execute("SELECT Name, Contact FROM Doctors WHERE Name = %s", (username,))
            doctors = cursor.fetchall()
            greeting = f"Welcome back, Dr. {username}"

        else:
            cursor.execute("SELECT PatientID FROM Patients WHERE Name = %s", (username,))
            patient = cursor.fetchone()

            if patient:
                cursor.execute("""
                    SELECT DISTINCT d.Name, d.Contact
                    FROM Appointments a
                    JOIN Doctors d ON a.DoctorID = d.DoctorID
                    WHERE a.PatientID = %s
                """, (patient['PatientID'],))
                doctors = cursor.fetchall()
                greeting = "Your Doctors"
            else:
                doctors = []
                greeting = "No doctors associated with your profile."

    return render_template('doctors.html', doctors=doctors, greeting=greeting)


@app.route('/medical_records')
@login_required
def medical_records():
    with db.cursor(dictionary=True) as cursor:
        cursor.execute("""
            SELECT mr.RecordID, p.Name AS PatientName, mr.Diagnosis, mr.Treatment
            FROM MedicalRecords mr
            JOIN Patients p ON mr.PatientID = p.PatientID
        """)
        records = cursor.fetchall()

    return render_template('medical_records.html', medical_records=records)


if __name__ == '__main__':
    app.run(debug=True)
