/*
 * FileName: postgresql/dataQueries/consumptionProfile_analisis/consumptionProfile_day.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying and computing energy consumption (Wh/VArh) in 1-hour intervals over the last 24 hours.
 * Date: 2025-02-23
 *
 * Description:
 * This SQL script calculates the energy consumption (in Wh and VArh) for a specific powermeter over the last 24 hours.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then calculates the consumption for each hour by comparing the last entry of each hour with the last entry of the previous hour.
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
 * 4. Define a CTE `last_entries` to get the last entry of each hour for the specified powermeter.
 * 5. Define a CTE `hourly_data` to select the distinct last entry for each hour.
 * 6. Define a CTE `previous_hour_data` to get the previous hour's values for comparison.
 * 7. Calculate the consumption for each hour by comparing the last entry of the current hour with the last entry of the previous hour.
 * 8. Select the results for the last 24 hours and order them by hour in descending order.
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
 *    Columns: serial_number, timestamp_tz, timestamp_utc, total_real_energy_imported, total_var_hours_imported_q1
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
        "timestamp_utc",
        total_real_energy_imported, 
        total_var_hours_imported_q1,
        date_trunc('hour', "timestamp_tz") AS hour,
        date_trunc('hour', "timestamp_utc") AS hour_utc
    FROM 
        measurements
    WHERE 
        serial_number = 'DEMO000001'
        AND "timestamp_tz" < NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)
        AND EXISTS (SELECT 1 FROM user_access)
    ORDER BY 
        "timestamp_tz" DESC
),
hourly_data AS (
    SELECT DISTINCT ON (hour)
        hour,
        hour_utc,
        "timestamp_tz",
        total_real_energy_imported,
        total_var_hours_imported_q1
    FROM 
        last_entries
    ORDER BY 
        hour, "timestamp_tz" DESC
),
previous_hour_data AS (
    SELECT 
        hour,
        LAG(total_real_energy_imported) OVER (ORDER BY hour) AS prev_real_energy_imported,
        LAG(total_var_hours_imported_q1) OVER (ORDER BY hour) AS prev_var_hours_imported
    FROM 
        hourly_data
)
SELECT 
    TO_CHAR(hd.hour_utc, 'YYYY-MM-DD HH24') || '-' || TO_CHAR(hd.hour_utc + INTERVAL '1 hour', 'HH24') AS consumption_profile_hour_range_utc,
    TO_CHAR(hd.hour, 'YYYY-MM-DD HH24') || '-' || TO_CHAR(hd.hour + INTERVAL '1 hour', 'HH24') AS consumption_profile_hour_range_tz,
    hd.total_real_energy_imported - phd.prev_real_energy_imported AS real_energy_wh,
    hd.total_var_hours_imported_q1 - phd.prev_var_hours_imported AS reactive_energy_varh
FROM 
    hourly_data hd
JOIN 
    previous_hour_data phd ON hd.hour = phd.hour
WHERE 
    hd.hour >= date_trunc('hour', NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)) - INTERVAL '24 hours'
ORDER BY 
    hd.hour DESC;