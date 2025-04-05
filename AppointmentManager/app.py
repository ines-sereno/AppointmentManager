# Main flask application
from flask import Flask, render_template, request, url_for, redirect, flash
from config import SQLALCHEMY_DATABASE_URI, SQLALCHEMY_TRACK_MODIFICATIONS
from models import db, Employee, Provider, Patient, Appointment, Waitlist, ClinicSchedule, Lab, Reception, Diagnosis, MedicalHistory
from forms import SearchForm, AppointmentForm
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = SQLALCHEMY_TRACK_MODIFICATIONS
app.config['SECRET_KEY'] = 'your_secret_key'

db.init_app(app)

@app.route('/', methods=['GET', 'POST'])
def home():
    return render_template('home.html')

@app.route('/reception', methods=['GET', 'POST'])
def reception_view():
    form = SearchForm()
    search_results = []

    # can search by provider name, patient name, appointment date, and appointment status
    if request.method == 'POST':
        query = db.session.query(Appointment, Provider, Patient, Employee)\
            .join(Provider, Appointment.provider_ID == Provider.provider_ID)\
            .join(Employee, Provider.provider_ID == Employee.employee_ID)\
            .join(Patient, Appointment.patient_ID == Patient.patient_ID)

        if form.provider_name.data:
            name = form.provider_name.data.strip()
            query = query.filter((Employee.first_name + ' ' + Employee.last_name).ilike(f"%{name}%"))
        if form.patient_name.data:
            name = form.patient_name.data.strip()
            query = query.filter((Patient.first_name + ' ' + Patient.last_name).ilike(f"%{name}%"))
        if form.appointment_date.data:
            query = query.filter(Appointment.appointment_date == form.appointment_date.data)
        if form.appointment_status.data:
            query = query.filter(Appointment.appointment_status == form.appointment_status.data)

        search_results = query.all()
    
    from sqlalchemy import extract, func
    from collections import defaultdict
    import calendar

    # bar chart data for appointment status:
    monthly_stats_raw = db.session.query(
        extract('month', Appointment.appointment_date).label('month'),
        Appointment.appointment_status,
        func.count(Appointment.appointment_ID)
    ).group_by('month', Appointment.appointment_status).all()

    # Organize data for chart.js
    monthly_stats = defaultdict(lambda: {'Scheduled': 0, 'Completed': 0, 'Canceled': 0})

    for month, status, count in monthly_stats_raw:
        month_name = calendar.month_name[int(month)]
        monthly_stats[month_name][status] = count

    # Ensure all months are present
    ordered_months = list(calendar.month_name)[1:]  # Jan to Dec
    appointment_chart = {
        'labels': ordered_months,
        'datasets': [
            {
                'label': status,
                'data': [monthly_stats[m][status] for m in ordered_months]
            }
            for status in ['Scheduled', 'Completed', 'Canceled']
        ]
    }


    # waitlist information
    waitlist = db.session.query(Waitlist, Appointment, Patient)\
        .join(Appointment, Waitlist.appointment_ID == Appointment.appointment_ID)\
        .join(Patient, Waitlist.patient_ID == Patient.patient_ID)\
        .all()

    # clinic schedule information
    schedule = db.session.query(ClinicSchedule, Provider, Employee)\
        .join(Provider, ClinicSchedule.provider_ID == Provider.provider_ID)\
        .join(Employee, Provider.provider_ID == Employee.employee_ID)\
        .order_by(Employee.last_name, ClinicSchedule.workday)\
        .all()

    from collections import defaultdict

    # data for histogram need to count providers by specialty and day
    stacked_data = defaultdict(lambda: defaultdict(int))
    specialties_set = set()

    for sched, provider, _ in schedule:
        day = sched.workday
        specialty = provider.specialty
        stacked_data[day][specialty] += 1
        specialties_set.add(specialty)

    # sort the specialties and weekdays for consistent ordering
    weekdays_ordered = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    specialties_ordered = sorted(specialties_set)

    # Convert to Chart.js format
    chart_datasets = []
    for specialty in specialties_ordered:
        data = [stacked_data[day].get(specialty, 0) for day in weekdays_ordered]
        chart_datasets.append({
            "label": specialty,
            "data": data,
        })

    return render_template('reception.html', form=form, search_results=search_results, waitlist=waitlist, schedule=schedule, weekdays=weekdays_ordered, chart_datasets=chart_datasets, appointment_chart=appointment_chart)

@app.route('/provider', methods=['GET', 'POST'])
def provider_view():
    patient_results = []
    selected_provider_id = request.args.get('provider_id')
    scheduled_appointments = []

    # get provider's schedule and appointments for the selected provider
    provider_schedule = []
    if selected_provider_id:
        provider_schedule = db.session.query(ClinicSchedule)\
            .filter_by(provider_ID = selected_provider_id).all()
        scheduled_appointments = db.session.query(Appointment, Patient)\
        .join(Patient, Appointment.patient_ID == Patient.patient_ID)\
        .filter(
            Appointment.provider_ID == selected_provider_id,
            Appointment.appointment_status == 'Scheduled'
        ).order_by(Appointment.appointment_date, Appointment.appointment_time)\
        .all()
    
    # importing this because I want a date in the first appointment and follow-up appointment
    from sqlalchemy.orm import aliased

    # make the two aliases
    FirstAppt = aliased(Appointment)
    FollowUpAppt = aliased(Appointment)

    from sqlalchemy import extract, func
    from collections import defaultdict
    import calendar

    # Get monthly diagnosis counts (for all providers)
    diagnosis_counts_raw = db.session.query(
        extract('month', Appointment.appointment_date).label('month'),
        Diagnosis.disease_name,
        func.count(Diagnosis.diagnosis_ID)
    ).join(Lab, Diagnosis.lab_ID == Lab.lab_ID)\
    .join(Appointment, Lab.appointment_ID == Appointment.appointment_ID)\
    .filter(Appointment.appointment_date.isnot(None))\
    .group_by('month', Diagnosis.disease_name)\
    .all()

    months = list(calendar.month_name)[1:]  # January to December
    disease_map = defaultdict(lambda: [0] * 12)

    for month, disease, count in diagnosis_counts_raw:
        if month:  # make sure month isn't None
            disease_map[disease][int(month) - 1] += count

    diagnosis_chart = {
        "labels": months,
        "datasets": [
            {
                "label": disease,
                "data": counts
            } for disease, counts in disease_map.items()
        ]
    }
    

    # search patient by name and get their medical history
    if request.method == 'POST':
        search_name = request.form.get('patient_name')
        if search_name:
            patient_results = db.session.query(Patient, MedicalHistory, Diagnosis, FirstAppt, FollowUpAppt)\
                .join(MedicalHistory, Patient.patient_ID == MedicalHistory.patient_ID)\
                .outerjoin(Diagnosis, MedicalHistory.diagnosis_ID == Diagnosis.diagnosis_ID)\
                .outerjoin(FirstAppt, FirstAppt.appointment_ID == MedicalHistory.first_appointment_ID)\
                .outerjoin(FollowUpAppt, FollowUpAppt.appointment_ID == MedicalHistory.followup_appointment_ID)\
                .filter((Patient.first_name + ' ' + Patient.last_name).ilike(f"%{search_name}%"))\
                .all()
    
    # output labs for the selected provider
    labs = []
    if selected_provider_id:
        labs = db.session.query(Lab, Appointment, Patient, Diagnosis)\
            .join(Appointment, Lab.appointment_ID == Appointment.appointment_ID)\
            .join(Patient, Appointment.patient_ID == Patient.patient_ID)\
            .outerjoin(Diagnosis, Lab.lab_ID == Diagnosis.lab_ID)\
            .filter(Appointment.provider_ID == selected_provider_id)\
            .all()

    providers = db.session.query(Provider, Employee).join(Employee).all()

    weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

    # create a set of working days for this provider
    workdays = {sched.workday: sched.room_number for sched in provider_schedule}

    return render_template('provider.html', providers=providers, selected_provider_id=selected_provider_id, provider_schedule=provider_schedule, patient_results=patient_results, labs=labs, 
    weekdays=weekdays, workdays=workdays, scheduled_appointments=scheduled_appointments, diagnosis_chart=diagnosis_chart)

@app.route('/lab')
def lab_view():
    selected_tech_id = request.args.get('lab_tech_id')
    lab_results = []

    # get lab results for the selected lab tech
    if selected_tech_id:
        lab_results = db.session.query(
            Lab, Appointment, Patient, Diagnosis
        ).join(
            Appointment, Lab.appointment_ID == Appointment.appointment_ID
        ).join(
            Patient, Appointment.patient_ID == Patient.patient_ID
        ).outerjoin(
            Diagnosis, Lab.lab_ID == Diagnosis.lab_ID
        ).filter(
            Lab.lab_tech_ID == selected_tech_id
        ).order_by(Appointment.appointment_date, Appointment.appointment_time).all()

    # search the lab tech by name
    lab_techs = db.session.query(Employee).filter(Employee.job == 'Lab Tech').all()

    return render_template(
        'lab.html',
        lab_techs=lab_techs,
        selected_tech_id=selected_tech_id,
        lab_results=lab_results
    )

if __name__ == '__main__':
    app.run(debug=True)