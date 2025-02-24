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
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Joins: The query joins the powermeters (p) table with the user_installations (ui) table 
 *    to ensure that only powermeters belonging to installations associated with the given user 
 *    are returned.
 *
 * 2. Filtering: It filters the results based on the provided user_id to retrieve only 
 *    the powermeters accessible by that specific user.
 *
 * 3. Output: The query returns a list of powermeter serial numbers, client IDs, client aliases, 
 *    installation IDs, and installation aliases that the user is allowed to access.
 *
 * Example:
 * WHERE user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95';
 * ---------------------------------------------------------------------------
 * Tables and Columns Accessed:
 * 1. powermeters
 *    Columns: serial_number, client_id, installation_id
 * 2. user_installations
 *    Columns: user_id, installation_id
 * 3. installations
 *    Columns: installation_id, installation_alias
 * 4. clients
 *    Columns: client_id, client_alias
 * ---------------------------------------------------------------------------
 * Version History:
 * 2025-02-24 | Arturo Vargas | Added client_alias and installation_alias to the output.
 */

-- Adjust to desired schema
SET search_path TO demo;

SELECT 
    p.serial_number, 
    p.client_id, 
    c.client_alias, 
    p.installation_id, 
    i.installation_alias
FROM 
    powermeters p
JOIN 
    user_installations ui ON p.installation_id = ui.installation_id
JOIN 
    installations i ON p.installation_id = i.installation_id
JOIN 
    clients c ON p.client_id = c.client_id
WHERE 
    ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95'; -- Replace with the actual user_id