/*
 * FileName: postgresql/dataQueries/fetchPowermetersByUserAccess.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for retrieving the list of powermeters accessible by a specific user.
 * Date: 2025-02-19
 *
 * Description:
 * This script queries the demo.powermeters table to retrieve all powermeter serial numbers 
 * that a specific user has access to. It ensures that only powermeters linked to the user 
 * via the user_clients table are returned. The query establishes the relationship between 
 * the powermeter and the user by checking the client ID.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the powermeters (p) table with the user_clients (uc) table 
 *    to ensure that only powermeters belonging to clients associated with the given user 
 *    are returned.
 *
 * 2. Filtering: It filters the results based on the provided user_id to retrieve only 
 *    the powermeters accessible by that specific user.
 *
 * 3. Output: The query returns a list of powermeter serial numbers that the user is allowed to access.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95';
 * ---------------------------------------------------------------------------
 */

SELECT p.serial_number
FROM demo.powermeters p
JOIN demo.user_clients uc
  ON p.client_id = uc.client_id
WHERE uc.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95';