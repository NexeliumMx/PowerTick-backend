/**
FileName: postgresql/testQueries/testCascadeDeletion.sql
Author(s): Arturo Vargas
Brief: SQL script for testing cascade deletion in the PowerTick database.
Date: 2025-02-22
Description:
This script tests the cascade deletion functionality in the PowerTick database.
It creates a client, an installation for that client, a powermeter for the installation,
and a measurement for the powermeter. The script then deletes the client and verifies
that all related installations, powermeters, and measurements are also deleted due to
the cascade deletion relationships.

Cascade Deletion Relationships:
- Deleting a client will delete all related installations.
- Deleting an installation will delete all related powermeters.
- Deleting a powermeter will delete all related measurements.

When a 'client_id' is deleted, the following entities are deleted in cascade:
1. All installations associated with the client.
2. All powermeters associated with the installations.
3. All measurements associated with the powermeters.

Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
All rights reserved.
*/

--Step 1: Create a client, installation, powermeter, and measurement
-- Ensure constraints are deferred
SET CONSTRAINTS ALL DEFERRED;

-- Create a client
INSERT INTO demo.clients (client_alias) VALUES ('Demo Client');

-- Create an installation for the client
INSERT INTO demo.installations (client_id, installation_alias) 
VALUES ((SELECT client_id FROM demo.clients WHERE client_alias = 'Demo Client'), 'Demo Installation');

-- Create a powermeter for the installation
INSERT INTO demo.powermeters (serial_number, client_id, installation_id, powermeter_alias) 
VALUES ('DEMO000001', 
        (SELECT client_id FROM demo.clients WHERE client_alias = 'Demo Client'), 
        (SELECT installation_id FROM demo.installations WHERE installation_alias = 'Demo Installation'), 
        'Demo Powermeter');

-- Create a measurement for the powermeter
INSERT INTO demo.measurements ("timestamp_utc", serial_number, amps_total) 
VALUES (NOW(), 'DEMO000001', 100);

-- Verify the data
SELECT * FROM demo.clients;
SELECT * FROM demo.installations;
SELECT * FROM demo.powermeters;
SELECT * FROM demo.measurements;



-- Step 2: Delete the client and verify cascade deletion
-- Delete the client and test cascade delete
DELETE FROM demo.clients WHERE client_alias = 'Demo Client';

-- Verify deletion
SELECT * FROM demo.installations;
SELECT * FROM demo.powermeters;
SELECT * FROM demo.measurements;

-- Re-enable constraints
SET CONSTRAINTS ALL IMMEDIATE;