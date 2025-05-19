/**
 * FileName: postgresql/schemaScripts/c_demo_tables.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating the demo schema and related tables for the PowerTick database.
 * Date: 2025-02-22
 *
 * Description:
 * This script creates the `demo` schema and several tables within it, including `clients`, 
 * `installations`, `users`, `user_clients`, `user_installations`, `powermeters`, and `measurements`. 
 * It sets up the necessary relationships and constraints between these tables, ensuring referential 
 * integrity with cascading deletes where appropriate. The script also includes the creation of 
 * extensions and setting the schema context.
 *
 * Tables and Relationships:
 * - `clients`: Stores client information with a primary key `client_id`.
 * - `installations`: Stores installation information, linked to `clients` via `client_id`.
 * - `users`: Stores user information with a primary key `user_id`.
 * - `user_clients`: Junction table for many-to-many relationship between `users` and `clients`.
 * - `user_installations`: Junction table for many-to-many relationship between `users` and `installations`.
 * - `powermeters`: Stores powermeter information, linked to `clients` and `installations`.
 * - `measurements`: Stores measurement data, linked to `powermeters` via `serial_number`.
 *
 * The script ensures that constraints are deferred until the end of the transaction and re-enabled 
 * immediately after the table creation.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

-- Ensure constraints are deferred
SET CONSTRAINTS ALL DEFERRED;

CREATE SCHEMA IF NOT EXISTS demo AUTHORIZATION azure_pg_admin;

-- Set schema context
SET search_path TO demo;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create clients table first
CREATE TABLE IF NOT EXISTS clients (
    client_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- Auto-generated UUID
    client_alias TEXT,
    register_date TIMESTAMPTZ DEFAULT NOW() -- Timestamp of client registration
);

-- Create installations table
CREATE TABLE IF NOT EXISTS installations (
    installation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- Auto-generated UUID
    client_id UUID,
    installation_alias TEXT,
    installation_date TIMESTAMPTZ,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create users table (Referencing Azure AD B2C)
CREATE TABLE users (
    user_id TEXT PRIMARY KEY,  -- Unique ID from Azure AD B2C
    register_date TIMESTAMPTZ DEFAULT NOW() -- Timestamp of user registration
);

-- Create user_clients table (Many-to-Many relationship between users and clients)
CREATE TABLE IF NOT EXISTS user_clients (
    user_id TEXT,
    client_id UUID,
    assigned_at TIMESTAMPTZ DEFAULT NOW(), -- Timestamp of assignment
    PRIMARY KEY (user_id, client_id), -- Ensure unique assignments
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create user_installations table (Many-to-Many relationship between users and installations)
CREATE TABLE IF NOT EXISTS user_installations (
    user_id TEXT,
    installation_id UUID,
    assigned_at TIMESTAMPTZ DEFAULT NOW(), -- Timestamp of assignment
    PRIMARY KEY (user_id, installation_id), -- Ensure unique assignments
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (installation_id) REFERENCES installations(installation_id) ON DELETE CASCADE
);

-- Create powermeters table
CREATE TABLE IF NOT EXISTS powermeters (
  client_id UUID NULL,
  installation_id UUID NULL,
  powermeter_alias TEXT,
  time_zone TEXT, -- Powermeter's installation tz Ex:"America/Mexico_City"
  -- hardware details
  serial_number TEXT PRIMARY KEY,
  manufacturer TEXT,
  series TEXT,
  model TEXT,
  firmware_v TEXT, 
  -- dates
  register_date TIMESTAMPTZ,
  facturation_interval_months SMALLINT, -- 1 or 2
  facturation_day SMALLINT, --27
  device_address SMALLINT,
  ct_ratio INT, -- Current Transformer
  vt_ratio INT, -- Voltage Transformer
  thd_enable BOOLEAN,
  -- added columns
  ct2_value TEXT,
  ct1_value TEXT,
  ctn_value TEXT,
  pt2_value TEXT,
  pt1_value TEXT,
  sunspec_id INT,
  lenth INT,
  id TEXT,
  current_scale_factor TEXT,
  voltage_scale_factor TEXT,
  frequency_scale_factor TEXT,
  real_power_scale_factor TEXT,
  apparent_power_scale_factor TEXT,
  reactive_power_scale_factor TEXT,
  power_factor_scale_factor TEXT,
  totwh_sf TEXT,
  totvah_sf_sunspec TEXT,
  totvarh_sf TEXT,
  meter_event_flags TEXT,
  sunspec_end_id_sunspec INT,
  sunspec_end_lenth_sunspec INT,
  digital_input_status INT,
  current_tariff INT,
  revision_code INT,
  front_selector_status INT,
  carlo_gavazzi_controls_identification_code INT,
  password INT,
  type_application INT,
  measirung_system INT,
  dmd_interval_time INT,
  filter_span_parameter INT,
  filter_coefficient INT,
  baud_rate INT,
  digital_input_1_type INT,
  digital_input_2_type INT,
  digital_input_3_type INT,
  digital_input_1_prescaler INT,
  digital_input_2_prescaler INT,
  digital_input_3_prescaler INT,
  tariff_managed_via_serial_communication INT,
  reset_total_meters INT,
  reset_partial_meters INT,
  reset_hour_counter INT,
  reset_counters INT,
  reset_dmd_max INT,
  UNIQUE (serial_number),
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
  FOREIGN KEY (installation_id) REFERENCES installations(installation_id) ON DELETE CASCADE
);

-- Create measurements table
CREATE TABLE IF NOT EXISTS measurements (
  "timestamp_utc" TIMESTAMPTZ,
  "timestamp_tz" TIMESTAMP,
  serial_number TEXT,
  current_total INT,
  current_l1 INT,
  current_l2 INT,
  current_l3 INT,
  voltage_ln INT,
  voltage_l1 INT,
  voltage_l2 INT,
  voltage_l3 INT,
  voltage_ll INT,
  "voltage_l1-l2" INT,
  "voltage_l2-l3" INT,
  "voltage_l3-l1" INT,
  frequency INT,
  watts INT,
  watts_l1 INT,
  watts_l2 INT,
  watts_l3 INT,
  va INT,
  va_l1 INT,
  va_l2 INT,
  va_l3 INT,
  var INT,
  var_l1 INT,
  var_l2 INT,
  var_l3 INT,
  power_factor INT,
  pf_l1 INT,
  pf_l2 INT,
  pf_l3 INT,
  kwh_exported_total INT,
  kwh_exported_l1 INT,
  kwh_exported_l2 INT,
  kwh_exported_l3 INT,
  kwh_imported_total INT,
  kwh_imported_l1 INT,
  kwh_imported_l2 INT,
  kwh_imported_l3 INT,
  vah_exported_total INT,
  vah_exported_l1 INT,
  vah_exported_l2 INT,
  vah_exported_l3 INT,
  vah_imported_total INT,
  vah_imported_l1 INT,
  vah_imported_l2 INT,
  vah_imported_l3 INT,
  varh_imported_q1 INT,
  varh_imported_q1_l1 INT,
  varh_imported_q1_l2 INT,
  varh_imported_q1_l3 INT,
  varh_imported_q2 INT,
  varh_imported_q2_l1 INT,
  varh_imported_q2_l2 INT,
  varh_imported_q2_l3 INT,
  vah_exported_q3 INT,
  vah_exported_q3_l1 INT,
  vah_exported_q3_l2 INT,
  vah_exported_q3_l3 INT,
  varh_exported_q4 INT,
  varh_exported_q4_l1 INT,
  varh_exported_q4_l2 INT,
  varh_exported_q4_l3 INT,
  phase_sequence INT,
  current_n INT,
  thd_current_l1 INT,
  thd_current_l2 INT,
  thd_current_l3 INT,
  thd_voltage_ln INT,
  thd_voltage_l1 INT,
  thd_voltage_l2 INT,
  thd_voltage_l3 INT,
  thd_voltage_ll INT,
  "thd_voltage_l1-l2" INT,
  "thd_voltage_l2-l3" INT,
  "thd_voltage_l3-l1" INT,
  kw_dmd_max DOUBLE PRECISION,
  kw_dmd INTEGER,
  va_dmd_max INTEGER,
  va_dmd_total INTEGER,
  current_dmd_max INTEGER,
  varh_imported_total INTEGER,
  varh_exported_total INTEGER,
  hour_m INT,
  hour_m_exported_kwh INT,
  PRIMARY KEY ("timestamp_utc", serial_number),
  FOREIGN KEY (serial_number)
    REFERENCES powermeters (serial_number)
    -- The ON DELETE CASCADE clause in the measurements table's foreign key constraint means that when a row in the powermeters table is deleted, 
    -- all related rows in the measurements table will be automatically deleted as well. 
    -- However, deleting a single measurement row in the measurements table will not affect the powermeters table or any other rows in the measurements table.
    ON DELETE CASCADE 
    ON UPDATE NO ACTION
);

-- Re-enable constraints
SET CONSTRAINTS ALL IMMEDIATE;