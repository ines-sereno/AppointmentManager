DROP DATABASE AppointmentManager;
CREATE DATABASE AppointmentManager;
USE AppointmentManager;

CREATE TABLE Employee (
	employee_ID INT NOT NULL PRIMARY KEY, 
	first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL
);

CREATE TABLE Provider (
    provider_ID INT NOT NULL PRIMARY KEY,
    specialty VARCHAR(50) NOT NULL,
    FOREIGN KEY (provider_ID) REFERENCES Employee(employee_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Patient (
    patient_ID INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Appointment (
    appointment_ID INT NOT NULL PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    provider_ID INT NOT NULL,
    patient_ID INT NOT NULL,
    appointment_status ENUM('Scheduled', 'Completed', 'Canceled') NOT NULL,
    cancellation_reason TEXT NULL,
    FOREIGN KEY (provider_ID) REFERENCES Provider(provider_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (patient_ID) REFERENCES Patient(patient_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Waitlist (
    patient_ID INT NOT NULL,
    appointment_ID INT NOT NULL,
    waitlist_status ENUM('Active', 'Deactivated') NOT NULL,
    PRIMARY KEY (patient_ID, appointment_ID),
    FOREIGN KEY (patient_ID) REFERENCES Patient(patient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (appointment_ID) REFERENCES Appointment(appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Clinic_Schedule (
    provider_ID INT NOT NULL,
    workday ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    room_number INT NOT NULL,
    PRIMARY KEY (provider_ID, workday),
    FOREIGN KEY (provider_ID) REFERENCES Provider(provider_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lab (
	lab_ID INT NOT NULL PRIMARY KEY, 
    lab_tech_ID INT NOT NULL, 
    appointment_ID INT NULL, 
    lab_type ENUM('Skin Biopsy', 'Immunofluorescence', 'Blood', 'Urine'),
    FOREIGN KEY (appointment_ID) REFERENCES Appointment(appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (lab_tech_ID) REFERENCES Employee(employee_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reception (
	reception_clerk_ID INT NOT NULL PRIMARY KEY,
    appointment_ID INT NOT NULL, 
    payment_info ENUM('credit card', 'debit card', 'cash', 'check'),
    insurance_number varchar(20) NULL,
    FOREIGN KEY (appointment_ID) REFERENCES Appointment(appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reception_clerk_ID) REFERENCES Employee(employee_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Diagnosis (
	diagnosis_ID INT NOT NULL PRIMARY KEY,
    disease_name varchar(100) NOT NULL,
    lab_id INT NULL, 
    FOREIGN KEY (lab_ID) REFERENCES Lab(lab_ID) ON DELETE CASCADE ON UPDATE CASCADE
);
   
CREATE TABLE Medical_History (
    medical_history_ID INT NOT NULL PRIMARY KEY,
    patient_ID INT NOT NULL,
    diagnosis_ID INT NULL, 
    first_appointment_ID INT NOT NULL,
    followup_appointment_ID INT NULL,
    FOREIGN KEY (patient_ID) REFERENCES Patient(patient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (diagnosis_ID) REFERENCES Diagnosis(diagnosis_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (first_appointment_ID) REFERENCES Appointment(appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (followup_appointment_ID) REFERENCES Appointment(appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Employee (employee_ID, first_name, last_name, salary, start_date) VALUES
(1, 'Alice', 'Smith', 67523.45, '2012-05-14'),
(2, 'Bob', 'Johnson', 85432.78, '2015-07-21'),
(3, 'Charlie', 'Williams', 92300.12, '2010-03-30'),
(4, 'David', 'Brown', 50450.50, '2018-06-11'),
(5, 'Emma', 'Jones', 75999.99, '2013-09-25'),
(6, 'Fiona', 'Garcia', 62345.67, '2009-11-17'),
(7, 'George', 'Miller', 102345.55, '2005-08-08'),
(8, 'Hannah', 'Davis', 48234.30, '2020-01-15'),
(9, 'Ian', 'Rodriguez', 79670.80, '2016-04-28'),
(10, 'Jack', 'Martinez', 88345.90, '2014-02-19'),
(11, 'Karen', 'Hernandez', 67321.60, '2011-12-10'),
(12, 'Liam', 'Lopez', 75555.75, '2006-05-05'),
(13, 'Mia', 'Gonzalez', 96543.25, '2017-08-14'),
(14, 'Nathan', 'Wilson', 53789.45, '2022-03-23'),
(15, 'Olivia', 'Anderson', 88999.10, '2008-07-30'),
(16, 'Paul', 'Thomas', 73422.60, '2015-06-27'),
(17, 'Quinn', 'Taylor', 58213.70, '2019-02-18'),
(18, 'Rachel', 'Moore', 67854.20, '2012-10-04'),
(19, 'Steve', 'Jackson', 92345.35, '2013-11-22'),
(20, 'Tina', 'Martin', 50321.40, '2018-09-29'),
(21, 'Uma', 'Lee', 81234.85, '2010-12-05'),
(22, 'Victor', 'Perez', 67890.65, '2021-04-13'),
(23, 'Wendy', 'Thompson', 98654.45, '2009-01-31'),
(24, 'Xander', 'White', 45555.20, '2016-05-08'),
(25, 'Yvonne', 'Harris', 72321.30, '2014-07-14'),
(26, 'Zack', 'Sanchez', 91000.90, '2013-10-09'),
(27, 'Laura', 'Clark', 63543.75, '2020-06-19'),
(28, 'Benjamin', 'Ramirez', 75432.60, '2011-03-25'),
(29, 'Sophia', 'Lewis', 84567.80, '2015-02-27'),
(30, 'Daniel', 'Robinson', 98234.50, '2007-08-15'),
(31, 'Ethan', 'Walker', 57678.35, '2019-12-10'),
(32, 'Madison', 'Young', 67234.10, '2022-01-07'),
(33, 'Noah', 'Allen', 82500.00, '2018-09-30'),
(34, 'Grace', 'King', 91345.55, '2016-03-12'),
(35, 'Henry', 'Wright', 50567.40, '2005-07-08'),
(36, 'Ava', 'Scott', 74567.25, '2013-10-22'),
(37, 'Samuel', 'Torres', 83210.50, '2017-06-29'),
(38, 'Chloe', 'Nguyen', 67000.45, '2021-05-20'),
(39, 'Joseph', 'Hill', 99999.99, '2008-02-14'),
(40, 'Emily', 'Flores', 48567.80, '2019-04-01'),
(41, 'Andrew', 'Green', 76899.20, '2011-09-23'),
(42, 'Samantha', 'Adams', 68432.70, '2014-11-09'),
(43, 'Logan', 'Nelson', 93210.60, '2020-08-18'),
(44, 'Charlotte', 'Baker', 80455.75, '2015-07-04'),
(45, 'Ryan', 'Hall', 55000.25, '2007-12-30');

