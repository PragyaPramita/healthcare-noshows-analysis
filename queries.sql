-- ============================================================
-- Project 1: Healthcare Appointment No-Show Analysis
-- Dataset: Kaggle Medical Appointment No Shows
-- ============================================================


-- ============================================================
-- STEP 1: EXPLORE THE DATA (Run these first)
-- ============================================================

-- See the first 10 rows
SELECT * FROM appointments LIMIT 10;

-- Count total rows
SELECT COUNT(*) AS total_appointments FROM appointments;

-- Check all column names and sample values
SELECT
    PatientId,
    AppointmentID,
    Gender,
    ScheduledDay,
    AppointmentDay,
    Age,
    Neighbourhood,
    Scholarship,
    Hipertension,
    Diabetes,
    Alcoholism,
    Handcap,
    SMS_received,
    "No-show"
FROM appointments
LIMIT 5;

-- Check for nulls in key columns
SELECT
    COUNT(*) - COUNT(Age)          AS null_age,
    COUNT(*) - COUNT(Gender)       AS null_gender,
    COUNT(*) - COUNT("No-show")    AS null_noshow,
    COUNT(*) - COUNT(SMS_received) AS null_sms
FROM appointments;

-- Check age range (spot any bad data)
SELECT MIN(Age) AS min_age, MAX(Age) AS max_age FROM appointments;


-- ============================================================
-- STEP 2: OVERALL NO-SHOW RATE
-- ============================================================

SELECT
    COUNT(*)                                                        AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS total_noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments;


-- ============================================================
-- STEP 3: NO-SHOW RATE BY GENDER
-- ============================================================

SELECT
    Gender,
    COUNT(*)                                                        AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
GROUP BY Gender
ORDER BY noshow_rate_pct DESC;


-- ============================================================
-- STEP 4: NO-SHOW RATE BY AGE GROUP
-- ============================================================

SELECT
    CASE
        WHEN Age BETWEEN 0  AND 17  THEN '0-17 (Child)'
        WHEN Age BETWEEN 18 AND 34  THEN '18-34 (Young Adult)'
        WHEN Age BETWEEN 35 AND 54  THEN '35-54 (Middle Age)'
        WHEN Age BETWEEN 55 AND 74  THEN '55-74 (Senior)'
        ELSE '75+ (Elderly)'
    END                                                             AS age_group,
    COUNT(*)                                                        AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
WHERE Age >= 0
GROUP BY age_group
ORDER BY noshow_rate_pct DESC;


-- ============================================================
-- STEP 5: DOES SMS REMINDER REDUCE NO-SHOWS?
-- ============================================================

SELECT
    CASE WHEN SMS_received = 1 THEN 'SMS Sent' ELSE 'No SMS' END   AS sms_status,
    COUNT(*)                                                        AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
GROUP BY SMS_received;


-- ============================================================
-- STEP 6: NO-SHOW RATE BY DAY OF WEEK
-- ============================================================

SELECT
    CASE strftime('%w', AppointmentDay)
        WHEN '0' THEN '1_Sunday'
        WHEN '1' THEN '2_Monday'
        WHEN '2' THEN '3_Tuesday'
        WHEN '3' THEN '4_Wednesday'
        WHEN '4' THEN '5_Thursday'
        WHEN '5' THEN '6_Friday'
        WHEN '6' THEN '7_Saturday'
    END                                                             AS day_of_week,
    COUNT(*)                                                        AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
GROUP BY day_of_week
ORDER BY day_of_week;


-- ============================================================
-- STEP 7: NO-SHOW RATE BY HEALTH CONDITION
-- ============================================================

SELECT
    'Hypertension'                                                  AS condition,
    SUM(CASE WHEN Hipertension = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END)  AS condition_noshows,
    SUM(CASE WHEN Hipertension = 1 THEN 1 ELSE 0 END)              AS condition_total,
    ROUND(
        SUM(CASE WHEN Hipertension = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN Hipertension = 1 THEN 1 ELSE 0 END), 0), 2
    )                                                               AS noshow_rate_pct
FROM appointments
UNION ALL
SELECT
    'Diabetes',
    SUM(CASE WHEN Diabetes = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Diabetes = 1 THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN Diabetes = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN Diabetes = 1 THEN 1 ELSE 0 END), 0), 2
    )
FROM appointments
UNION ALL
SELECT
    'Alcoholism',
    SUM(CASE WHEN Alcoholism = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Alcoholism = 1 THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN Alcoholism = 1 AND "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN Alcoholism = 1 THEN 1 ELSE 0 END), 0), 2
    )
FROM appointments;


-- ============================================================
-- STEP 8: TOP 10 NEIGHBOURHOODS BY NO-SHOW COUNT
-- ============================================================

SELECT
    Neighbourhood,
    COUNT(*)                                                        AS total_appointments,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
GROUP BY Neighbourhood
ORDER BY noshows DESC
LIMIT 10;


-- ============================================================
-- STEP 9: WAIT TIME ANALYSIS
-- (Days between scheduling and appointment — longer wait = more no-shows?)
-- ============================================================

SELECT
    CASE
        WHEN julianday(AppointmentDay) - julianday(ScheduledDay) = 0  THEN '0 days (Same day)'
        WHEN julianday(AppointmentDay) - julianday(ScheduledDay) <= 7  THEN '1-7 days'
        WHEN julianday(AppointmentDay) - julianday(ScheduledDay) <= 30 THEN '8-30 days'
        ELSE '30+ days'
    END                                                             AS wait_time_bucket,
    COUNT(*)                                                        AS total,
    SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END)             AS noshows,
    ROUND(
        SUM(CASE WHEN "No-show" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    )                                                               AS noshow_rate_pct
FROM appointments
WHERE julianday(AppointmentDay) >= julianday(ScheduledDay)
GROUP BY wait_time_bucket
ORDER BY noshow_rate_pct DESC;
