/*
 * FileName: postgresql/dataQueries/demoSchema/demandProfile_day.sql
 * Author(s): Rogelio Leon, Arturo Vargas
 * Brief: SQL script for querying and computing power demand measurements (W/VAr) in 1-hour intervals over the last 24 hours.
 * Date: 2025-02-23
 *
 * Description:
 * This SQL script calculates the power demand (in W and VAr) for a specific powermeter over the last 24 hours.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then calculates the average and maximum power demand for each hour.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `powermeter_time_zone` to retrieve the time zone for the specified powermeter.
 * 4. Define a CTE `hourly_data` to compute the average and maximum power demand for each hour.
 * 5. Select the results for the last 24 hours and order them by hour in descending order.
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
 *    Columns: serial_number, timestamp_tz, total_real_power, reactive_power_var
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
hourly_data AS (
    SELECT 
        date_trunc('hour', "timestamp_tz") AS hour,
        AVG(total_real_power) AS avg_total_real_power,
        MAX(total_real_power) AS max_total_real_power,
        AVG(reactive_power_var) AS avg_reactive_power_var,
        MAX(reactive_power_var) AS max_reactive_power_var
    FROM 
        measurements
    WHERE 
        serial_number = 'DEMO000001'
        AND "timestamp_tz" < NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)
        AND EXISTS (SELECT 1 FROM user_access)
    GROUP BY 
        date_trunc('hour', "timestamp_tz")
)
SELECT 
    hour,
    avg_total_real_power,
    max_total_real_power,
    avg_reactive_power_var,
    max_reactive_power_var
FROM 
    hourly_data
WHERE 
    hour >= date_trunc('hour', NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)) - INTERVAL '24 hours'
ORDER BY 
    hour DESC;