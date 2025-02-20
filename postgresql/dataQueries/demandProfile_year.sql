/*
 * FileName: postgresql/dataQueries/demandProfile_year.sql
 * Author(s): Rogelio Leon, Arturo Vargas
 * Brief: SQL script for querying and computing total power demand (W/VAr) in monthly intervals over the last 12 months.
 * Date: 2025-02-19
 *
 * Description:
 * This script retrieves power demand measurements from the demo.measurements table, focusing on the last 12 months.
 * It calculates the total (sum) of real power (total_real_power) and reactive power (reactive_power_var) for each month
 * in the powermeter’s local time zone. The query ensures the requesting user has access to the specified powermeter
 * by joining with the demo.powermeters and demo.user_clients tables. The timestamps are converted to the powermeter's local time,
 * truncated to the beginning of each month, and formatted as 'YYYY-MM'.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the measurements (m) with powermeters (p) and user_clients (uc) to validate that
 *    the user has permission to access data for the specified powermeter.
 *
 * 2. Time Zone Conversion: Each measurement’s timestamp is converted to the powermeter’s local time zone using
 *    the AT TIME ZONE clause.
 *
 * 3. Monthly Truncation: The query truncates timestamps to the start of each month (date_trunc('month', ...))
 *    and formats them as 'YYYY-MM' for display.
 *
 * 4. Aggregation: For each month, it sums the real power (total_real_power) and reactive power (reactive_power_var).
 *
 * 5. Filtering: It filters out measurements older than 12 months based on the powermeter’s local time.
 *
 * 6. Grouping and Ordering: The data is grouped by the powermeter’s time zone and the monthly boundary, then
 *    ordered in descending order by that monthly boundary so the most recent month appears first.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

SELECT
  p.time_zone,         -- Retrieve the powermeter's time zone

  -- Convert the timestamp to the local time zone and truncate to the start of each month.
  -- Format as 'YYYY-MM' to display only the year and month in the powermeter's time zone.
  to_char(
    date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone),
    'YYYY-MM'
  ) AS local_month,

  -- Sum the real and reactive power for all measurements in that month
  SUM(m."total_real_power")   AS total_active_power,
  SUM(m."reactive_power_var") AS total_reactive_power

FROM demo.measurements m
JOIN demo.powermeters p
  ON m.serial_number = p.serial_number        -- Match each measurement to its powermeter
JOIN demo.user_clients uc
  ON p.client_id = uc.client_id               -- Ensure the powermeter belongs to a client under this user
WHERE
  uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'    -- Validate the user's access
  AND p.serial_number = 'DEMO0000001'                   -- Filter by a specific powermeter
  -- Limit to the last 12 months (in the powermeter's local time)
  AND (m."timestamp" AT TIME ZONE p.time_zone) >= (NOW() AT TIME ZONE p.time_zone) - INTERVAL '12 months'
  AND (m."timestamp" AT TIME ZONE p.time_zone) < (NOW() AT TIME ZONE p.time_zone)
GROUP BY
  -- Group by the powermeter’s time zone and the local monthly boundary
  p.time_zone,
  date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone)
ORDER BY
  -- Sort in descending order to see the most recent months first
  date_trunc('month', m."timestamp" AT TIME ZONE p.time_zone) DESC;