/*
 * FileName: postgresql/dataQueries/demoSchema/consumptionProfile_year.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying and computing energy consumption (Wh/VArh) in 1-month intervals over the past 12 months.
 * Date: 2025-02-23
 *
 * Description:
 * This SQL script calculates the energy consumption (in Wh and VArh) for a specific powermeter over the past 12 months.
 * The script first verifies that the user has access to the powermeter parameters by checking the user_id and serial_number.
 * It then calculates the consumption for each month by comparing the last entry of each month with the last entry of the previous month.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Set the search path to the desired schema.
 * 2. Define a CTE (Common Table Expression) `user_access` to verify that the user has access to the powermeter parameters.
 * 3. Define a CTE `last_entries` to get the last entry of each month for the specified powermeter.
 * 4. Define a CTE `monthly_data` to select the distinct last entry for each month.
 * 5. Define a CTE `previous_month_data` to get the previous month's values for comparison.
 * 6. Calculate the consumption for each month by comparing the last entry of the current month with the last entry of the previous month.
 * 7. Select the results for the past 12 months and order them by month in descending order.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
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
        date_trunc('month', "timestamp_tz") AS month
    FROM 
        measurements
    WHERE 
        serial_number = 'DEMO000001'
        AND "timestamp_tz" < NOW()
        AND EXISTS (SELECT 1 FROM user_access)
    ORDER BY 
        "timestamp_tz" DESC
),
monthly_data AS (
    SELECT DISTINCT ON (month)
        month,
        "timestamp_tz",
        total_real_energy_imported,
        total_var_hours_imported_q1
    FROM 
        last_entries
    ORDER BY 
        month, "timestamp_tz" DESC
),
previous_month_data AS (
    SELECT 
        month,
        LAG(total_real_energy_imported) OVER (ORDER BY month) AS prev_real_energy_imported,
        LAG(total_var_hours_imported_q1) OVER (ORDER BY month) AS prev_var_hours_imported
    FROM 
        monthly_data
)
SELECT 
    md.month,
    md.total_real_energy_imported - pmd.prev_real_energy_imported AS real_energy_consumed_wh,
    md.total_var_hours_imported_q1 - pmd.prev_var_hours_imported AS var_hours_consumed_varh
FROM 
    monthly_data md
JOIN 
    previous_month_data pmd ON md.month = pmd.month
WHERE 
    md.month >= date_trunc('month', NOW()) - INTERVAL '12 months'
ORDER BY 
    md.month DESC;