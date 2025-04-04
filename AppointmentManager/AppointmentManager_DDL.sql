CREATE DATABASE AppointmentManager;
USE AppointmentManager;

CREATE TABLE Employee (
	employee_ID INT NOT NULL PRIMARY KEY, 
	first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job ENUM('Provider', 'Reception Clerk', 'Lab Tech') NOT NULL,
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

/* assuming clinic hours are 8am-6pm and no providers can work outside those hours */
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

/* inserting records into the tables */

INSERT INTO Employee (employee_ID, first_name, last_name, job, salary, start_date) VALUES
(1, 'Alice', 'Smith', 'Provider', 87523.45, '2012-05-14'),
(2, 'Bob', 'Johnson', 'Lab Tech', 65432.78, '2015-07-21'),
(3, 'Charlie', 'Williams', 'Reception Clerk', 72300.12, '2010-03-30'),
(4, 'David', 'Brown', 'Provider', 90450.50, '2018-06-11'),
(5, 'Emma', 'Jones', 'Lab Tech', 65999.99, '2013-09-25'),
(6, 'Fiona', 'Garcia', 'Reception Clerk', 72345.67, '2009-11-17'),
(7, 'George', 'Miller', 'Provider', 102345.55, '2005-08-08'),
(8, 'Hannah', 'Davis', 'Lab Tech', 48234.30, '2020-01-15'),
(9, 'Ian', 'Rodriguez', 'Reception Clerk', 79670.80, '2016-04-28'),
(10, 'Jack', 'Martinez', 'Provider', 88345.90, '2014-02-19'),
(11, 'Karen', 'Hernandez', 'Lab Tech', 67321.60, '2011-12-10'),
(12, 'Liam', 'Lopez', 'Reception Clerk', 75555.75, '2006-05-05'),
(13, 'Mia', 'Gonzalez', 'Provider', 96543.25, '2017-08-14'),
(14, 'Nathan', 'Wilson', 'Lab Tech', 53789.45, '2022-03-23'),
(15, 'Olivia', 'Anderson', 'Reception Clerk', 88999.10, '2008-07-30'),
(16, 'Paul', 'Thomas', 'Provider', 73422.60, '2015-06-27'),
(17, 'Quinn', 'Taylor', 'Lab Tech', 58213.70, '2019-02-18'),
(18, 'Rachel', 'Moore', 'Reception Clerk', 67854.20, '2012-10-04'),
(19, 'Steve', 'Jackson', 'Provider', 92345.35, '2013-11-22'),
(20, 'Tina', 'Martin', 'Lab Tech', 50321.40, '2018-09-29'),
(21, 'Uma', 'Lee', 'Reception Clerk', 81234.85, '2010-12-05'),
(22, 'Victor', 'Perez', 'Provider', 67890.65, '2021-04-13'),
(23, 'Wendy', 'Thompson', 'Lab Tech', 98654.45, '2009-01-31'),
(24, 'Xander', 'White', 'Reception Clerk', 45555.20, '2016-05-08'),
(25, 'Yvonne', 'Harris', 'Provider', 72321.30, '2014-07-14'),
(26, 'Zack', 'Sanchez', 'Lab Tech', 91000.90, '2013-10-09'),
(27, 'Laura', 'Clark', 'Reception Clerk', 63543.75, '2020-06-19'),
(28, 'Benjamin', 'Ramirez', 'Provider', 75432.60, '2011-03-25'),
(29, 'Sophia', 'Lewis', 'Lab Tech', 84567.80, '2015-02-27'),
(30, 'Daniel', 'Robinson', 'Reception Clerk', 98234.50, '2007-08-15'),
(31, 'Ethan', 'Walker', 'Provider', 57678.35, '2019-12-10'),
(32, 'Madison', 'Young', 'Lab Tech', 67234.10, '2022-01-07'),
(33, 'Noah', 'Allen', 'Reception Clerk', 82500.00, '2018-09-30'),
(34, 'Grace', 'King', 'Provider', 91345.55, '2016-03-12'),
(35, 'Henry', 'Wright', 'Lab Tech', 50567.40, '2005-07-08'),
(36, 'Ava', 'Scott', 'Reception Clerk', 74567.25, '2013-10-22'),
(37, 'Samuel', 'Torres', 'Provider', 83210.50, '2017-06-29'),
(38, 'Chloe', 'Nguyen', 'Lab Tech', 67000.45, '2021-05-20'),
(39, 'Joseph', 'Hill', 'Reception Clerk', 99999.99, '2008-02-14'),
(40, 'Emily', 'Flores', 'Provider', 48567.80, '2019-04-01'),
(41, 'Andrew', 'Green', 'Lab Tech', 76899.20, '2011-09-23'),
(42, 'Samantha', 'Adams', 'Reception Clerk', 68432.70, '2014-11-09'),
(43, 'Logan', 'Nelson', 'Provider', 93210.60, '2020-08-18'),
(44, 'Charlotte', 'Baker', 'Lab Tech', 80455.75, '2015-07-04'),
(45, 'Ryan', 'Hall', 'Reception Clerk', 55000.25, '2007-12-30');

INSERT INTO Provider (provider_ID, specialty) VALUES
(1, 'General Dermatology'),
(4, 'General Dermatology'),
(7, 'General Dermatology'),
(10, 'Immunodermatology'),
(13, 'Skin Cancer Surgery'),
(16, 'Laser Dermatology'),
(19, 'General Dermatology'),
(22, 'General Dermatology'),
(25, 'General Dermatology'),
(28, 'Laser Dermatology'),
(31, 'Laser Dermatology'),
(34, 'General Dermatology'),
(37, 'Dermatopathology'),
(40, 'Dermatopathology'),
(43, 'Cosmetic Dermatology');

INSERT INTO Patient (patient_id, first_name, last_name, date_of_birth, phone_number, email) VALUES
(1, 'Almeria', 'Winnister', '2007-01-06', '758-893-1659', 'awinnister0@gravatar.com'),
(2, 'Homere', 'Rehn', '1999-12-21', '286-387-8063', 'hrehn1@aol.com'),
(3, 'Karim', 'Ferson', '2001-07-09', '998-790-2848', 'kferson2@cargocollective.com'),
(4, 'Vale', 'Baumadier', '1977-12-27', '125-203-3914', 'vbaumadier3@mayoclinic.com'),
(5, 'Bibbie', 'Matyja', '1970-12-21', '375-325-2734', 'bmatyja4@constantcontact.com'),
(6, 'Chris', 'Raxworthy', '1993-04-08', '457-201-1467', 'craxworthy5@noaa.gov'),
(7, 'Alistair', 'Bloxham', '2017-06-18', '920-718-1292', 'abloxham6@state.gov'),
(8, 'Fredek', 'Boissieux', '1988-03-24', '590-539-3353', 'fboissieux7@github.com'),
(9, 'Zsa zsa', 'Ogus', '1976-04-22', '193-878-6689', 'zogus8@behance.net'),
(10, 'Rhona', 'Brawson', '1963-07-27', '684-387-3671', 'rbrawson9@chron.com'),
(11, 'Analiese', 'Shoorbrooke', '2014-04-12', '962-621-8907', 'ashoorbrookea@smugmug.com'),
(12, 'Mahala', 'Yushmanov', '2016-08-12', '316-319-8992', 'myushmanovb@desdev.cn'),
(13, 'Rona', 'Husset', '1992-04-29', '303-387-4604', 'rhussetc@people.com.cn'),
(14, 'Keene', 'Cowdry', '1952-03-02', '368-448-7147', 'kcowdryd@youtu.be'),
(15, 'Anya', 'Caras', '1960-07-16', '275-900-1131', 'acarase@last.fm'),
(16, 'Alec', 'Moro', '1980-10-28', '912-815-0427', 'amorof@spiegel.de'),
(17, 'Julianna', 'Pykerman', '1990-12-23', '565-374-3966', 'jpykermang@tamu.edu'),
(18, 'Niko', 'O''Dennehy', '2007-08-17', '167-539-9703', 'nodennehyh@umich.edu'),
(19, 'Artemas', 'Bacher', '2023-08-28', '318-387-3696', 'abacheri@skyrock.com'),
(20, 'Arlana', 'Joost', '1984-06-13', '437-989-7641', 'ajoostj@google.co.uk'),
(21, 'Rolland', 'Pioch', '2022-06-02', '737-835-3140', 'rpiochk@tinypic.com'),
(22, 'Ashbey', 'Lavrick', '1973-12-09', '752-495-0146', 'alavrickl@last.fm'),
(23, 'Nananne', 'Di Filippo', '1991-10-14', '498-853-9067', 'ndifilippom@java.com'),
(24, 'Raynor', 'Yakunin', '1982-07-10', '714-827-3237', 'ryakuninn@businessinsider.com'),
(25, 'Bobbee', 'Claybourn', '1953-06-09', '248-816-0584', 'bclaybourno@cyberchimps.com'),
(26, 'Coretta', 'Coultas', '1956-01-11', '832-298-2896', 'ccoultasp@over-blog.com'),
(27, 'Deb', 'Gert', '2024-07-09', '661-712-8814', 'dgertq@chronoengine.com'),
(28, 'Korney', 'Shoulder', '2003-06-09', '173-650-1406', 'kshoulderr@buzzfeed.com'),
(29, 'Allard', 'O''Griffin', '2007-06-30', '364-440-0995', 'aogriffins@cdbaby.com'),
(30, 'Boyd', 'MacGiolla Pheadair', '2007-01-30', '576-711-6629', 'bmacgiollapheadairt@usatoday.com'),
(31, 'Bernardo', 'Dickerson', '2016-05-03', '746-859-9576', 'bdickersonu@unesco.org'),
(32, 'Mathias', 'Simmers', '1989-12-15', '394-840-5928', 'msimmersv@alexa.com'),
(33, 'Mariam', 'Capell', '1954-08-05', '175-737-0650', 'mcapellw@time.com'),
(34, 'Dell', 'Miere', '1964-01-02', '578-909-5501', 'dmierex@alibaba.com'),
(35, 'Bette-ann', 'Cubbino', '2008-06-15', '224-774-0021', 'bcubbinoy@weibo.com'),
(36, 'Sadella', 'Stiger', '1974-12-27', '983-855-4813', 'sstigerz@etsy.com'),
(37, 'Katinka', 'Tzarkov', '1967-05-09', '488-438-0014', 'ktzarkov10@home.pl'),
(38, 'Parker', 'Feehan', '1955-07-26', '461-782-3577', 'pfeehan11@facebook.com'),
(39, 'Christa', 'McGeechan', '1998-09-14', '245-891-5806', 'cmcgeechan12@nationalgeographic.com'),
(40, 'Codie', 'Toop', '2024-05-23', '409-797-2824', 'ctoop13@a8.net'),
(41, 'Jule', 'Borrington', '2001-04-15', '803-119-2532', 'jborrington14@cnn.com'),
(42, 'Emmalynn', 'Rubinek', '2016-10-23', '771-880-3902', 'erubinek15@spotify.com'),
(43, 'Casi', 'Corp', '1954-02-28', '859-198-8829', 'ccorp16@ezinearticles.com'),
(44, 'Ashbey', 'Farryn', '1975-09-14', '482-231-7957', 'afarryn17@sun.com'),
(45, 'Lukas', 'Wade', '1951-09-21', '504-578-7388', 'lwade18@army.mil'),
(46, 'Ronnie', 'Schulkins', '2009-10-08', '744-953-0827', 'rschulkins19@usatoday.com'),
(47, 'Samuel', 'Jedrzejkiewicz', '1966-01-26', '126-293-7528', 'sjedrzejkiewicz1a@yellowpages.com'),
(48, 'Sophey', 'Leftbridge', '2010-04-25', '656-400-4500', 'sleftbridge1b@wix.com'),
(49, 'Dawna', 'Breacher', '2025-02-01', '510-449-0250', 'dbreacher1c@barnesandnoble.com'),
(50, 'Faina', 'Abbot', '1970-11-18', '314-563-2103', 'fabbot1d@creativecommons.org'),
(51, 'Gina', 'Mountjoy', '1995-11-12', '916-819-6317', 'gmountjoy1e@themeforest.net'),
(52, 'Jae', 'Kither', '1972-11-26', '818-552-5971', 'jkither1f@cdbaby.com'),
(53, 'Carter', 'Sneezum', '1984-12-15', '764-441-5258', 'csneezum1g@disqus.com'),
(54, 'Giorgi', 'Pawlaczyk', '1993-11-27', '883-781-1820', 'gpawlaczyk1h@tripadvisor.com'),
(55, 'Spense', 'Fortune', '2008-06-28', '761-580-3976', 'sfortune1i@hc360.com'),
(56, 'Zeb', 'Weekland', '1989-05-29', '816-952-1940', 'zweekland1j@netvibes.com'),
(57, 'Ginni', 'Sore', '2016-04-22', '403-277-2948', 'gsore1k@businessinsider.com'),
(58, 'Nikolos', 'Bewly', '2017-09-28', '279-792-1268', 'nbewly1l@independent.co.uk'),
(59, 'Una', 'Adenet', '1975-02-11', '195-425-6845', 'uadenet1m@hugedomains.com'),
(60, 'Anni', 'Lafranconi', '1963-01-17', '580-274-0589', 'alafranconi1n@vinaora.com'),
(61, 'Nanette', 'Ramey', '1982-05-24', '999-765-2387', 'nramey1o@1und1.de'),
(62, 'Noak', 'Middell', '1974-07-03', '949-632-1524', 'nmiddell1p@google.ru'),
(63, 'Etta', 'Rampage', '1958-04-10', '295-929-0424', 'erampage1q@google.co.uk'),
(64, 'Gail', 'Fencott', '1961-11-30', '208-978-5480', 'gfencott1r@google.pl'),
(65, 'Karim', 'Tupp', '1977-05-28', '759-234-8732', 'ktupp1s@dagondesign.com'),
(66, 'Else', 'Shenfish', '1984-12-30', '221-577-0968', 'eshenfish1t@wufoo.com'),
(67, 'Yoko', 'Pankettman', '2006-07-27', '238-908-3920', 'ypankettman1u@wufoo.com'),
(68, 'Phineas', 'Argent', '2003-05-08', '519-828-2041', 'pargent1v@admin.ch'),
(69, 'Olia', 'Riglar', '2015-05-25', '724-234-5492', 'origlar1w@51.la'),
(70, 'Hammad', 'Fontelles', '2018-12-01', '865-735-8728', 'hfontelles1x@cnbc.com'),
(71, 'Kenna', 'Toolan', '1974-09-06', '155-494-1131', 'ktoolan1y@china.com.cn'),
(72, 'Zebulen', 'Barrett', '1972-05-14', '971-986-0070', 'zbarrett1z@senate.gov'),
(73, 'Blake', 'Straw', '1954-08-07', '488-746-0582', 'bstraw20@cisco.com'),
(74, 'Clive', 'Hallowell', '2017-03-13', '493-710-3760', 'challowell21@fema.gov'),
(75, 'Charlena', 'Lennox', '1998-01-06', '899-430-3078', 'clennox22@baidu.com'),
(76, 'My', 'Jamary', '1985-12-29', '465-962-4318', 'mjamary23@spiegel.de'),
(77, 'Darnall', 'Heggie', '2020-09-26', '511-859-8281', 'dheggie24@berkeley.edu'),
(78, 'Wat', 'Moorhead', '1975-05-31', '119-124-6819', 'wmoorhead25@slideshare.net'),
(79, 'Karla', 'Wellstead', '1973-11-29', '270-623-0210', 'kwellstead26@tamu.edu'),
(80, 'Maressa', 'McDonand', '2006-11-29', '101-143-4104', 'mmcdonand27@hud.gov'),
(81, 'Beniamino', 'Primo', '1967-01-03', '527-717-3259', 'bprimo28@theatlantic.com'),
(82, 'Aili', 'Cristou', '2004-01-17', '954-141-2874', 'acristou29@google.fr'),
(83, 'Dannie', 'Gavey', '1982-11-27', '281-473-9287', 'dgavey2a@ask.com'),
(84, 'Doyle', 'Rash', '2010-09-06', '538-222-8585', 'drash2b@squidoo.com'),
(85, 'Christos', 'Bachelar', '1996-02-25', '659-789-6139', 'cbachelar2c@who.int'),
(86, 'Sallee', 'Spreull', '1991-08-20', '364-648-3589', 'sspreull2d@technorati.com'),
(87, 'Ariel', 'Vesque', '1988-04-05', '318-419-5529', 'avesque2e@edublogs.org'),
(88, 'Obediah', 'Bloxland', '2022-07-10', '723-319-8205', 'obloxland2f@domainmarket.com'),
(89, 'Loree', 'Ibarra', '1995-09-22', '196-191-4632', 'libarra2g@bbb.org'),
(90, 'Spense', 'Rubenchik', '2000-02-27', '820-537-7897', 'srubenchik2h@1und1.de'),
(91, 'Terese', 'Yglesias', '2020-03-04', '819-532-6719', 'tyglesias2i@theatlantic.com'),
(92, 'Shay', 'Bulluck', '1951-10-13', '763-506-0516', 'sbulluck2j@cargocollective.com'),
(93, 'Elsinore', 'Gerrietz', '2008-02-27', '928-523-6888', 'egerrietz2k@sakura.ne.jp'),
(94, 'Donnamarie', 'Kerridge', '2005-07-30', '879-789-4162', 'dkerridge2l@npr.org'),
(95, 'Nettie', 'Cordero', '1996-04-18', '637-238-2698', 'ncordero2m@virginia.edu'),
(96, 'Hendrick', 'Wykey', '1993-06-09', '651-961-1507', 'hwykey2n@mashable.com'),
(97, 'Stearn', 'Vaissiere', '1992-01-11', '844-731-1934', 'svaissiere2o@networksolutions.com'),
(98, 'Deny', 'Hercock', '1962-06-08', '103-973-2708', 'dhercock2p@myspace.com'),
(99, 'Almira', 'Dowda', '1999-03-08', '338-807-0440', 'adowda2q@goo.ne.jp'),
(100, 'Smith', 'Doonican', '1973-08-25', '557-240-6547', 'sdoonican2r@hp.com');


INSERT INTO Appointment (appointment_ID, appointment_date, appointment_time, provider_ID, patient_ID, appointment_status, cancellation_reason) VALUES
(1, '2025-07-19', '14:30:00', 28, 56, 'Canceled', 'Weather-related cancellation'),
(2, '2023-11-26', '10:30:00', 19, 40, 'Completed', NULL),
(3, '2025-05-13', '16:30:00', 19, 15, 'Scheduled', NULL),
(4, '2023-04-25', '13:30:00', 10, 93, 'Completed', NULL),
(5, '2023-03-29', '13:00:00', 31, 77, 'Completed', NULL),
(6, '2023-10-17', '14:00:00', 7, 80, 'Completed', NULL),
(7, '2024-11-16', '11:00:00', 22, 38, 'Completed', NULL),
(8, '2023-08-28', '09:00:00', 31, 97, 'Canceled', 'Provider unavailable'),
(9, '2025-02-17', '13:30:00', 25, 62, 'Scheduled', NULL),
(10, '2025-02-17', '13:30:00', 25, 98, 'Canceled', 'Double booking error'),
(11, '2024-04-07', '12:00:00', 34, 63, 'Completed', NULL),
(12, '2025-05-23', '14:30:00', 7, 30, 'Scheduled', NULL),
(13, '2025-05-23', '14:30:00', 7, 2, 'Canceled', 'Double booking error'),
(14, '2024-06-04', '16:00:00', 4, 98, 'Completed', NULL),
(15, '2026-01-17', '11:00:00', 1, 95, 'Scheduled', NULL),
(16, '2025-02-05', '13:00:00', 4, 89, 'Completed', NULL),
(17, '2023-08-02', '14:00:00', 43, 61, 'Completed', NULL),
(18, '2024-02-08', '16:30:00', 40, 46, 'Completed', NULL),
(19, '2025-06-20', '16:30:00', 10, 72, 'Scheduled', NULL),
(20, '2025-07-14', '11:00:00', 19, 30, 'Scheduled', NULL),
(21, '2025-10-30', '16:00:00', 4, 73, 'Scheduled', NULL),
(22, '2026-05-14', '14:30:00', 10, 84, 'Scheduled', NULL),
(23, '2023-05-14', '14:30:00', 10, 58, 'Canceled', 'Double booking error'),
(24, '2025-07-15', '14:00:00', 31, 8, 'Scheduled', NULL),
(25, '2024-03-12', '11:30:00', 25, 40, 'Canceled', 'Provider unavailable'),
(26, '2024-01-26', '16:00:00', 28, 8, 'Completed', NULL),
(27, '2025-10-29', '09:00:52', 7, 92, 'Scheduled', NULL),
(28, '2025-08-22', '11:00:00', 13, 31, 'Scheduled', NULL),
(29, '2024-09-03', '09:30:00', 16, 17, 'Completed', NULL),
(30, '2023-03-09', '12:00:00', 16, 77, 'Canceled', 'Emergency reschedule'),
(31, '2024-08-29', '12:00:00', 1, 9, 'Completed', NULL),
(32, '2024-12-26', '09:30:00', 19, 27, 'Completed', NULL),
(33, '2024-01-07', '13:00:00', 16, 37, 'Canceled', 'Patient no-show'),
(34, '2025-07-21', '10:30:00', 19, 7, 'Scheduled', NULL),
(35, '2025-07-21', '10:30:00', 19, 34, 'Canceled', 'Double booking error'),
(36, '2024-09-20', '11:00:00', 37, 100, 'Completed', NULL),
(37, '2025-07-26', '16:00:00', 4, 7, 'Scheduled', NULL),
(38, '2025-12-21', '09:00:00', 37, 43, 'Scheduled', NULL),
(39, '2023-04-07', '13:30:00', 37, 43, 'Completed', NULL),
(40, '2023-07-16', '09:00:00', 43, 44, 'Canceled', 'Patient no-show'),
(41, '2025-04-15', '11:30:00', 4, 14, 'Canceled', 'Provider unavailable'),
(42, '2025-04-08', '13:30:00', 43, 43, 'Scheduled', NULL),
(43, '2024-08-28', '09:30:00', 1, 34, 'Canceled', 'Weather-related cancellation'),
(44, '2024-01-06', '15:00:00', 31, 20, 'Canceled', 'Patient requested cancellation'),
(45, '2025-05-08', '13:00:00', 4, 4, 'Scheduled', NULL),
(46, '2024-01-22', '14:30:00', 25, 13, 'Completed', NULL),
(47, '2024-02-14', '11:30:00', 43, 5, 'Canceled', 'Weather-related cancellation'),
(48, '2024-03-12', '13:00:00', 19, 68, 'Completed', NULL),
(49, '2024-10-27', '11:30:00', 28, 32, 'Canceled', 'Emergency reschedule'),
(50, '2023-02-03', '13:00:00', 28, 19, 'Completed', NULL);

/* Appointments in the waitlist are either past appointments that are now deactivated or if in the future, an appointment has to be in the appointment table */
INSERT INTO Waitlist (patient_ID, appointment_ID, waitlist_status) VALUES
(66, 42, 'Active'),
(81, 38, 'Active'),
(32, 26, 'Deactivated'),
(61, 42, 'Active'),
(93, 22, 'Active'),
(95, 31, 'Deactivated'),
(9, 36, 'Deactivated'),
(18, 29, 'Deactivated'),
(6, 29, 'Deactivated'),
(30, 2, 'Deactivated'),
(16, 24, 'Active'),
(22, 28, 'Active'),
(93, 14, 'Deactivated'),
(76, 48, 'Active'),
(20, 39, 'Active');

INSERT INTO Clinic_Schedule (provider_ID, workday, room_number)
VALUES
(1, 'Monday',    101),
(1, 'Tuesday',   101),
(1, 'Wednesday', 101),
(1, 'Thursday',  101),
(1, 'Friday',    101),
(1, 'Saturday',  101),
(4, 'Monday',    102),
(4, 'Tuesday',   102),
(4, 'Wednesday', 102),
(4, 'Thursday',  102),
(4, 'Friday',    102),
(4, 'Saturday',  102),
(7, 'Monday',    103),
(7, 'Tuesday',   103),
(7, 'Wednesday', 103),
(7, 'Thursday',  103),
(7, 'Friday',    103),
(7, 'Saturday',  103),
(10, 'Monday',   104),
(10, 'Tuesday',  104),
(10, 'Wednesday',104),
(10, 'Thursday', 104),
(10, 'Friday',   104),
(10, 'Saturday', 104),
(13, 'Monday',   105),
(13, 'Tuesday',  105),
(13, 'Wednesday',105),
(13, 'Thursday', 105),
(13, 'Friday',   105),
(13, 'Saturday', 105),
(16, 'Monday',   106),
(16, 'Tuesday',  106),
(16, 'Wednesday',106),
(16, 'Thursday', 106),
(16, 'Friday',   106),
(16, 'Saturday', 106),
(19, 'Monday',   107),
(19, 'Tuesday',  107),
(19, 'Wednesday',107),
(19, 'Thursday', 107),
(19, 'Friday',   107),
(19, 'Saturday', 107),
(22, 'Monday',   108),
(22, 'Tuesday',  108),
(22, 'Wednesday',108),
(22, 'Thursday', 108),
(22, 'Friday',   108),
(22, 'Saturday', 108),
(25, 'Monday',   109),
(25, 'Tuesday',  109),
(25, 'Wednesday',109),
(25, 'Thursday', 109),
(25, 'Friday',   109),
(28, 'Monday',   110),
(28, 'Tuesday',  110),
(28, 'Wednesday',110),
(28, 'Thursday', 110),
(28, 'Friday',   110),
(31, 'Monday',   111),
(31, 'Tuesday',  111),
(31, 'Wednesday',111),
(31, 'Thursday', 111),
(31, 'Friday',   111),
(34, 'Monday',   112),
(34, 'Tuesday',  112),
(34, 'Wednesday',112),
(34, 'Thursday', 112),
(34, 'Friday',   112),
(37, 'Monday',   113),
(37, 'Tuesday',  113),
(37, 'Wednesday',113),
(37, 'Thursday', 113),
(37, 'Friday',   113),
(40, 'Monday',   114),
(40, 'Tuesday',  114),
(40, 'Wednesday',114),
(40, 'Thursday', 114),
(40, 'Friday',   114),
(43, 'Monday',   115),
(43, 'Tuesday',  115),
(43, 'Wednesday',115),
(43, 'Thursday', 115),
(43, 'Friday',   115);

INSERT INTO Lab (lab_ID, lab_tech_ID, appointment_ID, lab_type)
VALUES
    (1,  2,  2,  'Blood'),
    (2,  2,  4,  'Skin Biopsy'),
    (3,  8,  5,  'Blood'),
    (4, 17,  6,  'Urine'),
    (5, 14,  7,  'Immunofluorescence'),
    (6, 17, 11,  'Blood'),
    (7, 5, 14,  'Skin Biopsy'),
    (8, 23, 16,  'Blood'),
    (9, 20, 17,  'Skin Biopsy'),
    (10,29, 18,  'Urine');

INSERT INTO Reception (reception_clerk_ID, appointment_ID, payment_info, insurance_number)
VALUES
    (3, 2, 'credit card', 'hsu38v'),
    (6, 4, 'debit card', 'ks93mg'),
    (9, 5, 'cash', '98jal1'),
    (12, 6, 'check', '4nc01l'),
    (15, 7, 'credit card', '28x9gm'),
    (18, 11, 'debit card', '28g03m'),
    (21, 14, 'cash', '1h5xm8'),
    (24, 16, 'check', '20zlwm'),
    (27, 17, 'credit card', 'ght6vn'),
    (30, 18, 'debit card', '2057gh'),
    (33, 26, 'cash', '10amxng'),
    (36, 29, 'check', '4nch86'),
    (39, 31, 'credit card', '1wqsac'),
    (42, 32, 'debit card', '08oik9'),
    (45, 36, 'cash', '47d0ap');
    
INSERT INTO Diagnosis (diagnosis_ID, disease_name, lab_ID)
VALUES
    (1,  'Acne Vulgaris',          1), 
    (2,  'Eczema',                 2), 
    (3,  'Psoriasis',              3),
    (4,  'Rosacea',                4),
    (5,  'Melanoma',               5),
    (6,  'Hives (Urticaria)',      6), 
    (7,  'unknown',                7),
    (8,  'Ringworm (Tinea)',       8),
    (9,  'Basal Cell Carcinoma',   9),
    (10, 'Basal Cell Carcinoma',10);
    
INSERT INTO Medical_History (medical_history_ID, patient_ID, diagnosis_ID, first_appointment_ID, followup_appointment_ID)
VALUES
(1,   2,   NULL,   13,  NULL),
(2,   4,   NULL,   45,  NULL),
(3,   5,   NULL,   47,  NULL),
(4,   7,   NULL,34,  37),
(5,   8,   NULL,   24,  26),
(6,   9,   NULL,   31,  NULL),
(7,   13,  NULL,   46,  NULL),
(8,   14,  NULL,   41,  NULL),
(9,   15,  NULL,3,   NULL),
(10,  17,  NULL,   29,  NULL),
(11,  19,  NULL,50,  NULL),
(12,  20,  NULL,   44,  NULL),
(13,  27,  NULL,32,  NULL),
(14,  30,  NULL,   12,  20),
(15,  31,  NULL,28,  NULL),
(16,  32,  NULL,   49,  NULL),
(17,  34,  NULL,   35,  43),
(18,  37,  NULL,   33,  NULL),
(19,  38,  5,   7,   NULL), 
(20,  40,  1,   2,   25), 
(21,  43,  NULL,38,  42),
(22,  44,  NULL,   40,  NULL),
(23,  46,  10,   18,  NULL), 
(24,  56,  NULL,   1,   NULL),
(25,  58,  NULL,   23,  NULL),
(26,  61,  9,   17,  NULL),  
(27,  62,  NULL,   9,   NULL),
(28,  63,  6, 11,  NULL), 
(29,  68,  NULL,   48,  NULL),
(30,  72,  NULL,   19,  NULL),
(31,  73,  NULL,   21,  NULL),
(32,  77,  3,   5,   30), 
(33,  80,  4,   6,   NULL), 
(34,  84,  NULL,   22,  NULL),
(35,  89,  8,   16,  NULL), 
(36,  92,  NULL,   27,  NULL),
(37,  93,  2,   4,   NULL), 
(38,  95,  NULL,15,  NULL),
(39,  97,  NULL,   8,   NULL),
(40,  98,  7,   10,  14), 
(41,  100, NULL,   36,  NULL);


/*
Adding appointments to appointment table
    TRIGGER 1
    patient has to be in patient table
    TRIGGER 2
    provider has to be in provider table
    TRIGGER 3
    appointment date has to be in the future
    TRIGGER 4
    provider, appointment_date, appointment_time combination can't already exist

    -- if appointment cant be made, ask if it should be added to waitlist

Changing appointment status to completed (nothing happens) , insert row in reception table
    TRIGGER 1
    reception clerk ID is in the reception table
    TRIGGER 2
    to update appointment status in appointment table to completed, appointment id has to be in the reception table
    
    -- payment info is dropdown 'credit card', 'debit card', 'cash', 'check'

Provider changing rooms - updating ClinicSchedule table
    TRIGGER 1
    room cant be in use on that day

Provider cancels shift - updating ClinicSchedule table

Provider orders lab - inserting into lab table
    pick lab tech (dropdown)
    lab type (dropwdown)

    TRIGGER 1
    appointment_ID has to be in the appointment table, status completed
