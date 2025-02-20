/*
 * FileName: postgresql/dataQueries/demandProfile_day.sql
 * Author(s): Rogelio Leon, Arturo Vargas
 * Brief: SQL script for querying and computing power demand measurements (W/VAr) in 1-hour intervals over the last 24 hours.
 * Date: 2025-02-19
 *
 * Description:
 * This script queries the demo.measurements table to compute the average and maximum real power and 
 * reactive power demand for each hour in the last 24 hours. It ensures that the user has access to 
 * the specified powermeter ('DEMO0000001') by joining with the demo.powermeters and demo.user_clients tables.
 * The query converts all measurement timestamps to both UTC and the powermeter's local time zone, and builds
 * a formatted 24H date-time range string for each hour.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the measurements (m) with the powermeters (p) and user_clients (uc) tables to
 *    validate that the requesting user is authorized to access data for the specific powermeter.
 *
 * 2. Time Zone Conversion: It converts the timestamp for each measurement from UTC to both UTC (explicitly) and 
 *    the powermeter's local time zone using the 'AT TIME ZONE' clause.
 *
 * 3. Hourly Formatting: The query truncates the timestamp to the hour boundary in both UTC and local time,
 *    then formats it into a 24H range string (e.g., "2025-02-19 00-01 Hrs").
 *
 * 4. Aggregation: For each hour, it calculates the average and maximum values for both real power (total_real_power)
 *    and reactive power (reactive_power_var).
 *
 * 5. Filtering: The query restricts the results to measurements taken in the last 24 hours based on the powermeter's
 *    local time.
 *
 * 6. Grouping and Ordering: Data is grouped by the hour (in both UTC and local time) and ordered by the most recent
 *    local hour first.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

SELECT
  p.time_zone,       -- Display the powermeter's time zone

  -- Build a 24H date-time range string (e.g., "2025-02-19 00-01 Hrs") for the timestamp in UTC
  to_char(
    date_trunc('hour', m."timestamp" AT TIME ZONE 'UTC'),
    'YYYY-MM-DD'
  )
    || ' '
    || to_char(
         date_trunc('hour', m."timestamp" AT TIME ZONE 'UTC'),
         'HH24'
       )
    || '-'
    || to_char(
         date_trunc('hour', m."timestamp" AT TIME ZONE 'UTC') + interval '1 hour',
         'HH24'
       )
    || ' Hrs'
  AS time_range_utc,

  -- Build a 24H date-time range string (e.g., "2025-02-19 00-01 Hrs") for the timestamp in the powermeter's local time
  to_char(
    date_trunc('hour', m."timestamp" AT TIME ZONE p.time_zone),
    'YYYY-MM-DD'
  )
    || ' '
    || to_char(
         date_trunc('hour', m."timestamp" AT TIME ZONE p.time_zone),
         'HH24'
       )
    || '-'
    || to_char(
         date_trunc('hour', m."timestamp" AT TIME ZONE p.time_zone) + interval '1 hour',
         'HH24'
       )
    || ' Hrs'
  AS time_range_local,

  -- Calculate the average and maximum active demand for each hour
  AVG(m."total_real_power") AS average_active_demand,
  MAX(m."total_real_power") AS max_active_demand,

  -- Calculate the average and maximum reactive demand for each hour
  AVG(m."reactive_power_var") AS average_reactive_demand,
  MAX(m."reactive_power_var") AS peak_reactive_demand

FROM demo.measurements m
JOIN demo.powermeters p
  ON m.serial_number = p.serial_number         -- Match each measurement to a powermeter
JOIN demo.user_clients uc
  ON p.client_id = uc.client_id                -- Ensure the powermeter belongs to a client under this user
WHERE
  uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'   -- Validate the user has access
  AND p.serial_number = 'DEMO0000001'                  -- Filter by a specific powermeter
  -- Filter records within the last 24 hours in local time
  AND (m."timestamp" AT TIME ZONE p.time_zone) >= (NOW() AT TIME ZONE p.time_zone) - INTERVAL '24 hours'
  AND (m."timestamp" AT TIME ZONE p.time_zone) < (NOW() AT TIME ZONE p.time_zone)
GROUP BY
  p.time_zone,
  date_trunc('hour', m."timestamp" AT TIME ZONE 'UTC'),         -- Group by hour in UTC
  date_trunc('hour', m."timestamp" AT TIME ZONE p.time_zone)    -- Group by hour in local time
ORDER BY
  date_trunc('hour', m."timestamp" AT TIME ZONE p.time_zone) DESC;  -- Sort by the most recent local hour first