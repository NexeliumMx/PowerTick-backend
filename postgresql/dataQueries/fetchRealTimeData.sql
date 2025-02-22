/*
 * FileName: postgresql/dataQueries/demoSchema/fetchRealTimeData.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for retrieving the latest measurement entry for a specific powermeter.
 * Date: 2025-02-19
 *
 * Description:
 * This script queries the demo.measurements table to fetch the most recent measurement record 
 * for a given powermeter ('DEMO0000001') that the specified user has access to. It ensures user access 
 * by joining the demo.powermeters and demo.user_clients tables, and filters out any measurements with 
 * a timestamp equal to or after the current time.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the measurements (m) table with the powermeters (p) and user_clients (uc) tables
 *    to verify that the requesting user is authorized to access data for the specified powermeter.
 *
 * 2. Filtering: It filters records based on:
 *    - The specified user_id to ensure the user has access.
 *    - The specified powermeter serial_number.
 *    - A condition to include only measurements with a timestamp less than NOW(), ensuring only past entries are considered.
 *
 * 3. Ordering: The results are ordered in descending order by timestamp so that the most recent measurement appears first.
 *
 * 4. Limiting: The query uses LIMIT 1 to return only the latest measurement record.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

SELECT m.*
FROM demo.measurements m
JOIN demo.powermeters p ON m.serial_number = p.serial_number
JOIN demo.user_clients uc ON p.client_id = uc.client_id
WHERE uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'
  AND p.serial_number = 'DEMO0000001'
  AND m."timestamp" < NOW()
ORDER BY m."timestamp" DESC
LIMIT 1;