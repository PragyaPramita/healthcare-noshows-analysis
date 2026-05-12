# Healthcare Appointment No-Show Analysis

## Business Problem
A regional hospital network is losing revenue to appointment no-shows. 
The operations manager needs to know: who no-shows most, when, and 
does the SMS reminder system actually work?

## Tools Used
- SQL (DB Browser for SQLite)
- Google Sheets (Dashboard)

## Dataset
- Source: Kaggle — Medical Appointment No Shows
- 110,527 rows | 14 columns

## Key Findings
- Overall no-show rate: 20.19%
- Young adults (18–34) have the highest no-show rate at 23.98%
- Counterintuitively, SMS reminders correlate with higher no-shows 
  (27.57% vs 16.7%) — SMS was targeted at high-risk patients
- Appointments scheduled 30+ days out have the highest no-show rate at 33%
- Saturday appointments have the highest no-show rate by day (23.08%)

## Dashboard
![Dashboard](dashboard/dashboard_screenshot.png)

## Files
- `sql/queries.sql` — all 9 analysis queries
- `dashboard/dashboard_screenshot.png` — Google Sheets dashboard
