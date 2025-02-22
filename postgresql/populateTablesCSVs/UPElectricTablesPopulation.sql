/**
 * FileName: postgresql/populateTablesCSVs/UPElectricTablesPopulation.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for populating the demo database with initial data for UP Electric.
 * Date: 2025-02-22
 *
 * Description:
 * This script populates the `demo` schema with initial data for the UP Electric client. It includes 
 * the insertion of client information, installations, users, and their relationships. Additionally, 
 * it inserts powermeters associated with specific installations and sets the appropriate time zones.
 * The script ensures that all relationships are properly established and data integrity is maintained.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

SET search_path TO demo;

INSERT INTO clients (client_alias) 
VALUES ('UP Electric');


-- Insert installations
INSERT INTO installations (client_id, installation_alias, installation_date) 
VALUES 
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'San Ángel', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'Club América', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'Estadio Azteca', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'Radiopolis', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'Corp. Santa Fe', NOW());

-- Insert users
INSERT INTO users (user_id) 
VALUES 
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95'), -- Arturo Vargas
('71413efa-d6a9-4114-b252-6afcb923e6c4'), -- Memo
('c5ea49ed-b6d6-4ef4-aaff-6fd9876723a6'), -- Rogelio
('f1e393e4-65ba-4d28-899f-9217e9284d41');  -- Luis

-- Relate users to the client
INSERT INTO user_clients (user_id, client_id) 
VALUES 
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', '6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4'), -- Arturo Vargas
('71413efa-d6a9-4114-b252-6afcb923e6c4', '6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4'), -- Memo
('c5ea49ed-b6d6-4ef4-aaff-6fd9876723a6', '6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4'), -- Rogelio
('f1e393e4-65ba-4d28-899f-9217e9284d41', '6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4');  -- Luis

-- Relate Arturo Vargas to all 5 installations
INSERT INTO user_installations (user_id, installation_id, assigned_at) 
VALUES 
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', '419ba3ee-bd7d-4a28-ac48-9bb6e7e26b73', NOW()), -- San Ángel
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', 'c4bf186c-8e6f-4dbf-9ed3-d1643bae02af', NOW()), -- Club América
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', 'd8e03cdb-1c4b-477b-99d1-4037c6b41d6d', NOW()), -- Estadio Azteca
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', '43237447-636f-40e3-b292-b2e434bd02ae', NOW()), -- Radiopolis
('4c7c56fe-99fc-4611-b57a-0d5683f9bc95', '760de5d1-0abc-454a-927f-825004dd7220', NOW()); -- Corp. Santa Fe

-- Relate Memo to San Ángel installation
INSERT INTO user_installations (user_id, installation_id, assigned_at) 
VALUES 
('71413efa-d6a9-4114-b252-6afcb923e6c4', '419ba3ee-bd7d-4a28-ac48-9bb6e7e26b73', NOW()); -- San Ángel

-- Relate Luis to Estadio Azteca installation
INSERT INTO user_installations (user_id, installation_id, assigned_at) 
VALUES 
('f1e393e4-65ba-4d28-899f-9217e9284d41', 'd8e03cdb-1c4b-477b-99d1-4037c6b41d6d', NOW()); -- Estadio Azteca

-- Relate Rogelio to Club América, Estadio Azteca, and Radiopolis installations
INSERT INTO user_installations (user_id, installation_id, assigned_at) 
VALUES 
('c5ea49ed-b6d6-4ef4-aaff-6fd9876723a6', 'c4bf186c-8e6f-4dbf-9ed3-d1643bae02af', NOW()), -- Club América
('c5ea49ed-b6d6-4ef4-aaff-6fd9876723a6', 'd8e03cdb-1c4b-477b-99d1-4037c6b41d6d', NOW()), -- Estadio Azteca
('c5ea49ed-b6d6-4ef4-aaff-6fd9876723a6', '43237447-636f-40e3-b292-b2e434bd02ae', NOW()); -- Radiopolis



-- Insert powermeters
INSERT INTO powermeters (client_id, installation_id, powermeter_alias, time_zone, serial_number, register_date) 
VALUES 
-- Powermeter for San Ángel
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '419ba3ee-bd7d-4a28-ac48-9bb6e7e26b73', NULL, 'America/Mexico_City', 'DEMO000001', NOW()),

-- Powermeters for Club América
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'c4bf186c-8e6f-4dbf-9ed3-d1643bae02af', NULL, 'America/Mexico_City', 'DEMO000002', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'c4bf186c-8e6f-4dbf-9ed3-d1643bae02af', NULL, 'America/Mexico_City', 'DEMO000003', NOW()),

-- Powermeter for Estadio Azteca
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', 'd8e03cdb-1c4b-477b-99d1-4037c6b41d6d', NULL, 'America/Mexico_City', 'DEMO000004', NOW()),

-- Powermeter for Radiopolis
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '43237447-636f-40e3-b292-b2e434bd02ae', NULL, 'America/Mexico_City', 'DEMO000005', NOW()),

-- Powermeters for Corp. Santa Fe
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '760de5d1-0abc-454a-927f-825004dd7220', NULL, 'America/Mexico_City', 'DEMO000006', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '760de5d1-0abc-454a-927f-825004dd7220', NULL, 'America/Mexico_City', 'DEMO000007', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '760de5d1-0abc-454a-927f-825004dd7220', NULL, 'America/Mexico_City', 'DEMO000008', NOW()),
('6ef04fec-fdfc-45c5-9c2a-4e13f22c1de4', '760de5d1-0abc-454a-927f-825004dd7220', NULL, 'America/Mexico_City', 'DEMO000009', NOW());