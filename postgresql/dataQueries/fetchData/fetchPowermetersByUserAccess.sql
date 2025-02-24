/*
 * FileName: postgresql/dataQueries/fetchData/fetchPowermetersByUserAccess.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for retrieving the list of powermeters accessible by a specific user.
 * Date: 2025-02-22
 *
 * Description:
 * This script queries the powermeters table to retrieve all powermeter serial numbers 
 * that a specific user has access to. It ensures that only powermeters linked to the user 
 * via the user_installations table are returned. The query establishes the relationship between 
 * the powermeter and the user by checking the installation ID.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the powermeters (p) table with the user_installations (ui) table 
 *    to ensure that only powermeters belonging to installations associated with the given user 
 *    are returned.
 *
 * 2. Filtering: It filters the results based on the provided user_id to retrieve only 
 *    the powermeters accessible by that specific user.
 *
 * 3. Output: The query returns a list of powermeter serial numbers, client IDs, and installation IDs 
 *    that the user is allowed to access.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95';
 * ---------------------------------------------------------------------------
 * Tables and Columns Accessed:
 * 1. powermeters
 *    Columns: serial_number, installation_id
 * 2. user_installations
 *    Columns: user_id, installation_id
 * ---------------------------------------------------------------------------
 */

-- Adjust to desired schema
SET search_path TO demo;

SELECT 
    p.serial_number, 
    p.client_id, 
    p.installation_id
FROM 
    powermeters p
JOIN 
    user_installations ui ON p.installation_id = ui.installation_id
WHERE 
    ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'; -- Replace with the actual user_id