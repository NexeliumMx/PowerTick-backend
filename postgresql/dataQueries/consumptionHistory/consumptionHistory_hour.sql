/*
 * FileName: postgresql/dataQueries/consumptionHistory/consumptionHistory_hour.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying the energy consumption measurements (Wh/VArh) in the last hour.
 * Date: 2025-02-24
 *
 * Description:
 * This SQL script retrieves the energy consumption measurements (Wh/VArh) for a specific powermeter over the last hour.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then retrieves the measurements within the last hour.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `powermeter_time_zone` to retrieve the time zone for the specified powermeter.
 * 4. Select the energy consumption measurements for the last hour and order them by timestamp in descending order.
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
)
SELECT 
    "timestamp_utc",
    "timestamp_tz",
    total_real_energy_imported AS real_energy_wh,
    total_var_hours_imported_q1 AS reactive_energy_varh
FROM 
    measurements
WHERE 
    serial_number = 'DEMO000001'
    AND "timestamp_tz" < NOW() AT TIME ZONE (SELECT time_zone FROM powermeter_time_zone)
    AND "timestamp_utc" > NOW() - INTERVAL '1 hour'
    AND EXISTS (SELECT 1 FROM user_access)
ORDER BY 
    "timestamp_utc" DESC;