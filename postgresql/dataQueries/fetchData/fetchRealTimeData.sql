/*
 * FileName: postgresql/dataQueries/fetchData/fetchRealTimeData.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for retrieving the latest measurement entry for a specific powermeter.
 * Date: 2025-02-19
 *
 * Description:
 * This script first verifies if a specific user has access to read the properties of a powermeter 
 * by checking the user_installations table. If the user has access, it retrieves the latest entry 
 * from the measurements table for the specified powermeter.
 *
 * ---------------------------------------------------------------------------
 * Code Description:
 * 1. Common Table Expression (CTE): The query uses a CTE named user_access to check if the user 
 *    has access to the specified powermeter by joining the powermeters (p) table with the 
 *    user_installations (ui) table.
 *
 * 2. Filtering: The CTE filters the results based on the provided user_id and powermeter serial_number 
 *    to verify access.
 *
 * 3. Retrieval: If the user has access, the main query retrieves the latest entry from the measurements 
 *    table for the specified powermeter, where the timestamp is less than the current time.
 *
 * 4. Output: The query returns the latest measurement entry for the specified powermeter if the user 
 *    has access.
 *
 * Example:
 * WHERE ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' AND p.serial_number = 'DEMO000001';
 * ---------------------------------------------------------------------------
 */

-- Adjust to desired schema
SET search_path TO demo;

-- Define the user_id and powermeter serial_number
WITH user_access AS (
    SELECT 
        1
    FROM 
        powermeters p
    JOIN 
        user_installations ui ON p.installation_id = ui.installation_id
    WHERE 
        ui.user_id = '4c7c56fe-99fc-4611-b57a-0d5683f9bc95' -- Replace with the actual user_id
        AND p.serial_number = 'DEMO000001' -- Replace with the actual serial_number
)
SELECT 
    *
FROM 
    measurements
WHERE 
    serial_number = 'DEMO000001'
    AND "timestamp_utc" < NOW()
    AND EXISTS (SELECT 1 FROM user_access)
ORDER BY 
    "timestamp_utc" DESC
LIMIT 1;