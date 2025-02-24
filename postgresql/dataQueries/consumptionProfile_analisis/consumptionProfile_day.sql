/*
 * FileName: postgresql/dataQueries/demoSchema/consumptionProfile_day.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying and computing energy consumption (Wh/VArh) in 1-hour intervals over the last 24 hours.
 * Date: 2025-02-23
 *
 * Description:
 * This SQL script calculates the energy consumption (in Wh and VArh) for a specific powermeter over the last 24 hours.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then calculates the consumption for each hour by comparing the last entry of each hour with the last entry of the previous hour.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `last_entries` to get the last entry of each hour for the specified powermeter.
 * 4. Define a CTE `hourly_data` to select the distinct last entry for each hour.
 * 5. Define a CTE `previous_hour_data` to get the previous hour's values for comparison.
 * 6. Calculate the consumption for each hour by comparing the last entry of the current hour with the last entry of the previous hour.
 * 7. Select the results for the last 24 hours and order them by hour in descending order.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO000001'
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
last_entries AS (
    SELECT 
        "timestamp_tz", 
        total_real_energy_imported, 
        total_var_hours_imported_q1,
        date_trunc('hour', "timestamp_tz") AS hour
    FROM 
        measurements
    WHERE 
        serial_number = 'DEMO000001'
        AND "timestamp_tz" < NOW()
        AND EXISTS (SELECT 1 FROM user_access)
    ORDER BY 
        "timestamp_tz" DESC
),
hourly_data AS (
    SELECT DISTINCT ON (hour)
        hour,
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
    hd.hour,
    hd.total_real_energy_imported - phd.prev_real_energy_imported AS real_energy_consumed_wh,
    hd.total_var_hours_imported_q1 - phd.prev_var_hours_imported AS var_hours_consumed_varh
FROM 
    hourly_data hd
JOIN 
    previous_hour_data phd ON hd.hour = phd.hour
WHERE 
    hd.hour >= date_trunc('hour', NOW()) - INTERVAL '24 hours'
ORDER BY 
    hd.hour DESC;