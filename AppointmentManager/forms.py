# WTForms for search functinality
from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, DateField, TimeField, SelectField, SubmitField
from wtforms.validators import DataRequired, Optional

class SearchForm(FlaskForm):
    provider_name = StringField('Provider Name', validators=[Optional()])
    patient_name = StringField('Patient Name', validators=[Optional()])
    appointment_date = DateField('Appointment Date', format='%Y-%m-%d', validators=[Optional()])
    appointment_status = SelectField('Status', choices=[('', 'Any'), ('Scheduled', 'Scheduled'), ('Completed', 'Completed'), ('Canceled', 'Canceled')], validators=[Optional()])
    submit = SubmitField('Search')

class AppointmentForm(FlaskForm):
    patient_ID = SelectField('Patient', coerce=int, validators=[DataRequired()])
    provider_ID = SelectField('Provider', coerce=int, validators=[DataRequired()])
    appointment_date = DateField('Date', validators=[DataRequired()])
    appointment_time = TimeField('Time', validators=[DataRequired()])
    submit = SubmitField('Schedule Appointment')
