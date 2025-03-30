# SQLAlchemy models for all tables 
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import ENUM,VARCHAR

db = SQLAlchemy()

class Employee(db.Model):
    __tablename__ = 'Employee'
    employee_ID = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(20), nullable=False)
    last_name = db.Column(db.String(20), nullable=False)
    job = db.Column(db.Enum('Provider', 'Reception Clerk', 'Lab Tech'), nullable=False)
    salary = db.Column(db.Numeric(10, 2), nullable=False)
    start_date = db.Column(db.Date, nullable=False)

class Provider(db.Model):
    __tablename__ = 'Provider'
    provider_ID = db.Column(db.Integer, db.ForeignKey('Employee.employee_ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    specialty = db.Column(db.String(50), nullable=False)

class Patient(db.Model):
    __tablename__ = 'Patient'
    patient_ID = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(20), nullable=False)
    last_name = db.Column(db.String(20), nullable=False)
    date_of_birth = db.Column(db.Date, nullable=False)
    phone_number = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(100), nullable=False, unique=True)

class Appointment(db.Model):
    __tablename__ = 'Appointment'
    appointment_ID = db.Column(db.Integer, primary_key=True)
    appointment_date = db.Column(db.Date, nullable=False)
    appointment_time = db.Column(db.Time, nullable=False)
    provider_ID = db.Column(db.Integer, db.ForeignKey('Provider.provider_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    patient_ID = db.Column(db.Integer, db.ForeignKey('Patient.patient_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    appointment_status = db.Column(db.Enum('Scheduled', 'Completed', 'Canceled'), nullable=False)
    cancellation_reason = db.Column(db.Text)

class Waitlist(db.Model):
    __tablename__ = 'Waitlist'
    patient_ID = db.Column(db.Integer, db.ForeignKey('Patient.patient_ID'), primary_key=True)
    appointment_ID = db.Column(db.Integer, db.ForeignKey('Appointment.appointment_ID'), primary_key=True)
    waitlist_status = db.Column(db.Enum('Active', 'Deactivated'), nullable=False)

class ClinicSchedule(db.Model):
    __tablename__ = 'Clinic_Schedule'
    provider_ID = db.Column(db.Integer, db.ForeignKey('Provider.provider_ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    workday = db.Column(ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), primary_key=True)
    room_number = db.Column(db.Integer, nullable=False)


class Lab(db.Model):
    __tablename__ = 'Lab'
    lab_ID = db.Column(db.Integer, primary_key=True)
    lab_tech_ID = db.Column(db.Integer, db.ForeignKey('Employee.employee_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    appointment_ID = db.Column(db.Integer, db.ForeignKey('Appointment.appointment_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=True)
    lab_type = db.Column(ENUM('Skin Biopsy', 'Immunofluorescence', 'Blood', 'Urine'))


class Reception(db.Model):
    __tablename__ = 'Reception'
    reception_clerk_ID = db.Column(db.Integer, db.ForeignKey('Employee.employee_ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    appointment_ID = db.Column(db.Integer, db.ForeignKey('Appointment.appointment_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    payment_info = db.Column(ENUM('credit card', 'debit card', 'cash', 'check'), nullable=False)
    insurance_number = db.Column(db.String(20), nullable=True)


class Diagnosis(db.Model):
    __tablename__ = 'Diagnosis'
    diagnosis_ID = db.Column(db.Integer, primary_key=True)
    disease_name = db.Column(db.String(100), nullable=False)
    lab_ID = db.Column(db.Integer, db.ForeignKey('Lab.lab_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=True)


class MedicalHistory(db.Model):
    __tablename__ = 'Medical_History'
    medical_history_ID = db.Column(db.Integer, primary_key=True)
    patient_ID = db.Column(db.Integer, db.ForeignKey('Patient.patient_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    diagnosis_ID = db.Column(db.Integer, db.ForeignKey('Diagnosis.diagnosis_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=True)
    first_appointment_ID = db.Column(db.Integer, db.ForeignKey('Appointment.appointment_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    followup_appointment_ID = db.Column(db.Integer, db.ForeignKey('Appointment.appointment_ID', ondelete='CASCADE', onupdate='CASCADE'), nullable=True)