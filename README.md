# Appointment Manager - Dermatology Clinic

A web-based appointment management system for a dermatology clinic, built using **Flask**, **SQLAlchemy**, and **MySQL**.

This app supports three user views:
- **Reception**: Manage appointments, view the waitlist, and see the clinic schedule.
- **Provider**: Search patient medical history, view personal schedule, and access lab & diagnosis info.
- **Lab Technician**: View labs assigned by appointment, alongside diagnostic information.

---

## Features

- Search functionality across patients, appointments, and schedules
- Weekly provider schedule visualized in a grid
- Bar chart showing provider availability by weekday and specialty
- Fully integrated with a MySQL backend defined via `AppointmentManager_DDL.sql`

---

## Tech Stack

- **Backend**: Python, Flask, SQLAlchemy
- **Frontend**: HTML, Jinja2, Bootstrap, Chart.js
- **Database**: MySQL (DDL provided)
- **Hosting**: Render.com (optional)

---

## Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/ines-sereno/AppointmentManager.git
cd AppointmentManager
```

### 2. Set up the environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Set up the database

mysql+pymysql://username:password@hostname/dbname

### 4. Run the app

flask --app app run

Home Page:
<img width="1782" alt="Screenshot 2025-03-30 at 16 01 47" src="https://github.com/user-attachments/assets/998626fa-f8b6-42fb-ad4d-da3cd4963822" />

Reception Page:
<img width="1784" alt="Screenshot 2025-03-30 at 16 02 26" src="https://github.com/user-attachments/assets/99b4c954-dbf0-4e17-bc46-0f4595cf2c3e" />
