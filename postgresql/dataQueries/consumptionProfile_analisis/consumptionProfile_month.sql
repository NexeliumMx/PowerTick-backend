/*
 * FileName: postgresql/dataQueries/demoSchema/consumptionProfile_month.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for querying and computing energy consumption (Wh/VArh) in 1-day intervals over the past 30 days.
 * Date: 2025-02-20
 *
 * Description:
 * This script queries the demo.measurements table to compute the consumption of real energy and reactive energy 
 * for each day in the past 30 days. It ensures that the requesting user has access to the specified powermeter ('DEMO0000001')
 * by joining with the demo.powermeters and demo.user_clients tables. All measurement timestamps are converted to the powermeter's 
 * local time zone, truncated to the day boundary, and formatted for clear output.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the measurements (m) table with the powermeters (p) and user_clients (uc) tables to verify that
 *    the requesting user is authorized to access data for the specified powermeter.
 *
 * 2. Time Zone Conversion: Each measurement's timestamp is converted from UTC to the powermeter's local time using the 'AT TIME ZONE' clause.
 *
 * 3. Daily Aggregation: The converted timestamp is truncated to the day boundary and formatted as 'YYYY-MM-DD' to display the date in local time.
 *
 * 4. Consumption Calculation: For each day, the query calculates the difference between the oldest and newest measurements 
 *    for both real energy (total_real_energy_imported) and reactive energy (total_var_hours_imported_q1).
 *
 * 5. Filtering: The query limits results to measurements taken within the past 30 days, based on the powermeter's local time.
 *
 * 6. Grouping and Ordering: Data is grouped by the powermeter’s time zone and the local day, and ordered in descending order so that the most recent day appears first.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

WITH daily_data AS (
  SELECT
    p.time_zone,
    to_char(
      date_trunc('day', m."timestamp" AT TIME ZONE p.time_zone),
      'YYYY-MM-DD'
    ) AS time_range_local,
    m."total_real_energy_imported",
    m."total_var_hours_imported_q1",
    row_number() OVER (PARTITION BY p.time_zone, date_trunc('day', m."timestamp" AT TIME ZONE p.time_zone) ORDER BY m."timestamp" AT TIME ZONE p.time_zone ASC) AS row_asc,
    row_number() OVER (PARTITION BY p.time_zone, date_trunc('day', m."timestamp" AT TIME ZONE p.time_zone) ORDER BY m."timestamp" AT TIME ZONE p.time_zone DESC) AS row_desc
  FROM demo.measurements m
  JOIN demo.powermeters p
    ON m.serial_number = p.serial_number
  JOIN demo.user_clients uc
    ON p.client_id = uc.client_id
  WHERE 
    uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'
    AND p.serial_number = 'DEMO0000001'
    AND (m."timestamp" AT TIME ZONE p.time_zone) >= (NOW() AT TIME ZONE p.time_zone) - INTERVAL '1 month'
    AND (m."timestamp" AT TIME ZONE p.time_zone) < (NOW() AT TIME ZONE p.time_zone)
)

SELECT
  time_zone,
  time_range_local,
  MAX(CASE WHEN row_desc = 1 THEN total_real_energy_imported END) - MIN(CASE WHEN row_asc = 1 THEN total_real_energy_imported END) AS real_energy_consumption_profile_Wh,
  MAX(CASE WHEN row_desc = 1 THEN total_var_hours_imported_q1 END) - MIN(CASE WHEN row_asc = 1 THEN total_var_hours_imported_q1 END) AS reactive_energy_consumption_profile_VARh
FROM daily_data
GROUP BY
  time_zone,
  time_range_local
ORDER BY
  time_range_local DESC;