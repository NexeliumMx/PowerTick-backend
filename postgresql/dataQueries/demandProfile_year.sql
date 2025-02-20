/*
 * FileName: postgresql/dataQueries/demandProfile_year.sql
 * Author(s): Rogelio Leon, Arturo Vargas
 * Brief: SQL script for querying and computing power demand measurements (W/VAr) in 1-month intervals over the past 12 months.
 * Date: 2025-02-20
 *
 * Description:
 * This script queries the demo.measurements table to compute the average and maximum real power and reactive power demand 
 * for each month in the past 12 months. It ensures that the requesting user has access to the specified powermeter ('DEMO0000001')
 * by joining with the demo.powermeters and demo.user_clients tables. All measurement timestamps are converted to the powermeter's 
 * local time zone, truncated to the month boundary, and formatted for clear output.
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
 * 3. Monthly Aggregation: The converted timestamp is truncated to the month boundary and formatted as 'YYYY-MM' to display the date in local time.
 *
 * 4. Aggregation: For each month, the query calculates the average and maximum values for both real power (total_real_power) and reactive power (reactive_power_var).
 *
 * 5. Filtering: The query limits results to measurements taken within the past 12 months, based on the powermeter's local time.
 *
 * 6. Grouping and Ordering: Data is grouped by the powermeter’s time zone and the local month, and ordered in descending order so that the most recent month appears first.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

SELECT
  p.time_zone,        
  -- Convert the timestamp to the powermeter's local time zone, truncate to the month boundary,
  -- and format it as 'YYYY-MM' to display the date in local time
  to_char(
    date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone),
    'YYYY-MM'
  ) AS time_range_utc,
  to_char(
    date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone),
    'YYYY-MM'
  ) AS time_range_local,

  -- Calculate the average and maximum active demand for each local month
  AVG(m."total_real_power") AS average_active_demand,
  MAX(m."total_real_power") AS max_active_demand,

  -- Calculate the average and maximum reactive demand for each local month
  AVG(m."reactive_power_var") AS average_reactive_demand,
  MAX(m."reactive_power_var") AS peak_reactive_demand

FROM demo.measurements m
JOIN demo.powermeters p
  ON m.serial_number = p.serial_number    -- Match each measurement to its powermeter
JOIN demo.user_clients uc
  ON p.client_id = uc.client_id           -- Ensure this powermeter belongs to a client under the given user
WHERE 
  uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'      -- Validate user access
  AND p.serial_number = 'DEMO0000001'                     -- Filter by a specific powermeter
  -- Filter measurements based on local time for the last 12 months
  AND (m."timestamp" AT TIME ZONE p.time_zone) >= (NOW() AT TIME ZONE p.time_zone) - INTERVAL '12 months'
  AND (m."timestamp" AT TIME ZONE p.time_zone) < (NOW() AT TIME ZONE p.time_zone)
GROUP BY
  -- Group by the powermeter’s time zone and the local month
  p.time_zone,
  date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone)
ORDER BY
  -- Sort by the local month boundary in descending order
  date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone) DESC;