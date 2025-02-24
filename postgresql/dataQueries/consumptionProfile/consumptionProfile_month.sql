/*
 * FileName: postgresql/dataQueries/consumptionProfile/consumptionProfile_month.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying and computing energy consumption (Wh/VArh) in 1-day intervals over the past 30 days.
 * Date: 2025-02-23
 *
 * Description:
 * This SQL script calculates the energy consumption (in Wh and VArh) for a specific powermeter over the past 30 days.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then calculates the consumption for each day by comparing the last entry of each day with the last entry of the previous day.
 * The script dynamically retrieves the time zone for the specified powermeter.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `powermeter_time_zone` to retrieve the time zone for the specified powermeter.
 * 4. Define a CTE `last_entries` to get the last entry of each day for the specified powermeter.
 * 5. Define a CTE `daily_data` to select the distinct last entry for each day.
 * 6. Define a CTE `previous_day_data` to get the previous day's values for comparison.
 * 7. Calculate the consumption for each day by comparing the last entry of the current day with the last entry of the previous day.
 * 8. Select the results for the past 30 days and order them by day in descending order.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO000001'
 * ---------------------------------------------------------------------------
 * Tables and Columns Accessed:
 * 1. powermeters
 *    Columns: serial_number, time_zone
 * 2. user_installations
 *    Columns: user_id, installation_id
 * 3. measurements
 *    Columns: serial_number, timestamp_tz, total_real_energy_imported, total_var_hours_imported_q1
 * ---------------------------------------------------------------------------
 */

-- Adjust to desired schema
SET search_path TO demo;

-- Define the user_id and powermeter serial_number
WITH user_access AS (
    SELECT 
        1
    FROM 
        powermeters p
    JOIN 
        user_installations ui ON p.installation_id = ui.installation_id
    WHERE 
        ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' -- Replace with the actual user_id
        AND p.serial_number = 'DEMO000001' -- Replace with the actual serial_number
),
powermeter_time_zone AS (
    SELECT 
        time_zone
    FROM 
        powermeters
    WHERE 
        serial_number = 'DEMO000001' -- Replace with the actual serial_number
),
last_entries AS (
    SELECT 
        "timestamp_tz", 
        total_real_energy_imported, 
        total_var_hours_imported_q1,
        date_trunc('day', "timestamp_tz") AS day
    FROM 
        measurements
    WHERE 
        serial_number = 'DEMO000001'
        AND "timestamp_tz" < NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)
        AND EXISTS (SELECT 1 FROM user_access)
    ORDER BY 
        "timestamp_tz" DESC
),
daily_data AS (
    SELECT DISTINCT ON (day)
        day,
        "timestamp_tz",
        total_real_energy_imported,
        total_var_hours_imported_q1
    FROM 
        last_entries
    ORDER BY 
        day, "timestamp_tz" DESC
),
previous_day_data AS (
    SELECT 
        day,
        LAG(total_real_energy_imported) OVER (ORDER BY day) AS prev_real_energy_imported,
        LAG(total_var_hours_imported_q1) OVER (ORDER BY day) AS prev_var_hours_imported
    FROM 
        daily_data
)
SELECT 
    TO_CHAR(dd.day, 'YYYY-MM-DD') AS consumption_profile_day_range_tz,
    dd.total_real_energy_imported - pdd.prev_real_energy_imported AS real_energy_wh,
    dd.total_var_hours_imported_q1 - pdd.prev_var_hours_imported AS reactive_energy_varh
FROM 
    daily_data dd
JOIN 
    previous_day_data pdd ON dd.day = pdd.day
WHERE 
    dd.day >= date_trunc('day', NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)) - INTERVAL '30 days'
ORDER BY 
    dd.day DESC;