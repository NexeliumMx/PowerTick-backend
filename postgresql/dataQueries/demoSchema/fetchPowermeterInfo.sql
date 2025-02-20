/*
 * FileName: postgresql/dataQueries/demoSchema/fetchPowermeterInfo.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for retrieving all data for a specific powermeter after verifying user access.
 * Date: 2025-02-20
 *
 * Description:
 * This script verifies that the specified user has access to the given powermeter by joining the demo.user_clients 
 * and demo.powermeters tables. If the user is authorized, it retrieves all data for the specified powermeter.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the powermeters (p) table with the user_clients (uc) table to verify that the requesting user 
 *    is authorized to access data for the specified powermeter.
 *
 * 2. Filtering: It filters records based on:
 *    - The specified user_id to ensure the user has access.
 *    - The specified powermeter serial_number.
 *
 * 3. Data Retrieval: If the user is authorized, it retrieves all data for the specified powermeter.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND serial_number = 'DEMO0000001'
 * ---------------------------------------------------------------------------
 */

SELECT p.*
FROM demo.powermeters p
JOIN demo.user_clients uc ON p.client_id = uc.client_id
WHERE uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'
  AND p.serial_number = 'DEMO0000001';