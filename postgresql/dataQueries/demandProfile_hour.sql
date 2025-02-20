/*
 * FileName: postgresql/dataQueries/demandProfile_hour.sql
 * Author(s): Rogelio Leon, Arturo Vargas
 * Brief: SQL script for querying power demand measurements (W/VAr) in 5-minute intervals over the last 60 minutes.
 * Date: 2025-02-19
 *
 * Description:
 * This script retrieves power demand measurements from the demo.measurements table, focusing on the last 60 minutes.
 * It returns real power (total_real_power) and reactive power (reactive_power_var) values, grouped by 5-minute intervals.
 * The query ensures that the requesting user has access to the specified powermeter ('DEMO0000001') by joining with
 * the demo.powermeters and demo.user_clients tables. All timestamps are converted to the powermeter's local time zone,
 * rounded down to the nearest 5-minute boundary, and then formatted for clear output.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the measurements (m) table with the powermeters (p) and user_clients (uc) tables to 
 *    validate that the user is authorized to access data for the specified powermeter.
 *
 * 2. Time Zone Conversion and Rounding: Each measurement's timestamp is first converted from UTC to the powermeter's local
 *    time using the 'AT TIME ZONE' clause. It is then rounded down to the nearest 5-minute interval by subtracting the remainder
 *    of the minute component modulo 5.
 *
 * 3. Data Retrieval: For each 5-minute interval, the query outputs a formatted local time string (e.g., "YYYY-MM-DD HH24:MI")
 *    along with the real and reactive power measurements.
 *
 * 4. Filtering: The results are limited to measurements taken within the last 60 minutes based on the powermeter's local time.
 *
 * 5. Ordering: The data is ordered in descending order by the computed 5-minute intervals so that the most recent measurements
 *    appear first.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

 SELECT
  p.time_zone,   -- Retrieve the powermeter's time zone so we know how to interpret local time

  -- Round each measurement’s timestamp down to a 5-minute boundary in the powermeter’s local time
  -- and format it as 'YYYY-MM-DD HH24:MI' for clarity
  to_char(
    date_trunc(
      'minute',
      (m."timestamp" AT TIME ZONE p.time_zone)
        - (
            extract(minute FROM (m."timestamp" AT TIME ZONE p.time_zone))::int % 5
          ) * interval '1 minute'
    ),
    'YYYY-MM-DD HH24:MI'
  ) AS local_5_min_interval,

  -- Display the real and reactive power from each measurement
  m."total_real_power"   AS real_power,
  m."reactive_power_var" AS reactive_power

FROM demo.measurements m
JOIN demo.powermeters p
  ON m.serial_number = p.serial_number            -- Match each measurement to its powermeter
JOIN demo.user_clients uc
  ON p.client_id = uc.client_id                   -- Ensure the powermeter belongs to a client under this user
WHERE
  uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'   -- Validate the user has access to this powermeter
  AND p.serial_number = 'DEMO0000001'                   -- Filter for a specific powermeter
  -- Restrict to the last hour of measurements in local time
  AND (m."timestamp" AT TIME ZONE p.time_zone) >= (NOW() AT TIME ZONE p.time_zone) - INTERVAL '1 hour'
  AND (m."timestamp" AT TIME ZONE p.time_zone) <  (NOW() AT TIME ZONE p.time_zone)
ORDER BY
  -- Order results by the computed 5-minute intervals in descending order (most recent first)
  local_5_min_interval DESC;
