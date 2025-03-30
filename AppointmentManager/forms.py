# WTForms for search functinality
from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SelectField, SubmitField
from wtforms.validators import Optional

class SearchForm(FlaskForm):
    provider_name = StringField('Provider Name', validators=[Optional()])
    patient_name = StringField('Patient Name', validators=[Optional()])
    appointment_date = DateField('Appointment Date', format='%Y-%m-%d', validators=[Optional()])
    appointment_status = SelectField('Status', choices=[('', 'Any'), ('Scheduled', 'Scheduled'), ('Completed', 'Completed'), ('Canceled', 'Canceled')], validators=[Optional()])
    submit = SubmitField('Search')
