/*
 * FileName: postgresql/dataQueries/demandHistory/demandHistory_day.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying the power demand measurements (W/VAr) in the last 24 hours.
 * Date: 2025-02-24
 *
 * Description:
 * This SQL script retrieves the power demand measurements (in W and VAr) for a specific powermeter over the last 24 hours.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then retrieves the measurements within the last 24 hours.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `powermeter_time_zone` to retrieve the time zone for the specified powermeter.
 * 4. Select the power demand measurements for the last 24 hours and order them by timestamp in descending order.
 *
 * Example:
 * WHERE ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND p.serial_number = 'DEMO000001'
 * ---------------------------------------------------------------------------
 * Tables and Columns Accessed:
 * 1. powermeters
 *    Columns: serial_number, time_zone
 * 2. user_installations
 *    Columns: user_id, installation_id
 * 3. measurements
 *    Columns: serial_number, timestamp_tz, timestamp_utc, total_real_power, reactive_power_var
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
)
SELECT 
    "timestamp_utc",
    "timestamp_tz",
    total_real_power AS real_power_w,
    reactive_power_var AS reactive_power_var
FROM 
    measurements
WHERE 
    serial_number = 'DEMO000001'
    AND "timestamp_tz" < NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)
    AND "timestamp_utc" > NOW() - INTERVAL '24 hours'
    AND EXISTS (SELECT 1 FROM user_access)
ORDER BY 
    "timestamp_utc" DESC;