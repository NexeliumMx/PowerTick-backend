/**
 * FileName: postgresql/schemaScripts/d_dev_tables.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating the dev schema and related tables for the PowerTick database.
 * Date: 2025-05-31
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

CREATE SCHEMA IF NOT EXISTS dev AUTHORIZATION azure_pg_admin;

-- Set schema context
SET search_path TO dev;

-- Create powermeters table
CREATE TABLE IF NOT EXISTS powermeters (
  powermeter_id SERIAL,
  client_id UUID NULL,
  installation_id UUID NULL,
  powermeter_alias TEXT,
  time_zone TEXT, -- Powermeter's installation tz Ex:"America/Mexico_City"
  -- hardware details
  serial_number TEXT UNIQUE NOT NULL,
  manufacturer TEXT,
  series TEXT,
  model TEXT,
  firmware_v TEXT, 
  -- dates
  register_date TIMESTAMPTZ DEFAULT now(),
  facturation_interval_months SMALLINT, -- 1 or 2
  facturation_day SMALLINT, --27
  device_address SMALLINT,
  ct_ratio INT, -- Current Transformer
  vt_ratio INT, -- Voltage Transformer
  thd_enable BOOLEAN DEFAULT FALSE,
  -- added columns
  ct2_value TEXT,
  ct1_value TEXT,
  ctn_value TEXT,
  pt2_value TEXT,
  pt1_value TEXT,
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
  reset_total_meters INT,
  reset_partial_meters INT,
  reset_hour_counter INT,
  reset_counters INT,
  reset_dmd_max INT,
  CONSTRAINT pk_dev_powermeters PRIMARY KEY (powermeter_id),
  CONSTRAINT uq_dev_powermeters_serial_number UNIQUE (serial_number),
  CONSTRAINT fk_dev_powermeters_client_id_clients FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON DELETE CASCADE,
  CONSTRAINT fk_dev_powermeters_installation_id_installations FOREIGN KEY (installation_id) REFERENCES public.installations(installation_id) ON DELETE CASCADE
);

-- Create measurements table
CREATE TABLE IF NOT EXISTS measurements (
  powermeter_id INTEGER NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL,
  current_total INT,
  current_l1 INT,
  current_l2 INT,
  current_l3 INT,
  voltage_ln INT,
  voltage_l1 INT,
  voltage_l2 INT,
  voltage_l3 INT,
  voltage_ll INT,
  voltage_l1_l2 INT,
  voltage_l2_l3 INT,
  voltage_l3_l1 INT,
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
  thd_voltage_l1_l2 INT,
  thd_voltage_l2_l3 INT,
  thd_voltage_l3_l1 INT,
  kw_dmd_max DOUBLE PRECISION,
  kw_dmd INTEGER,
  va_dmd_max INTEGER,
  va_dmd_total INTEGER,
  current_dmd_max INTEGER,
  varh_imported_total INTEGER,
  varh_exported_total INTEGER,
  hour_m INT,
  hour_m_exported_kwh INT,
  CONSTRAINT pk_dev_measurements PRIMARY KEY (powermeter_id, timestamp),
  CONSTRAINT fk_dev_measurements_powermeter_id_powermeters FOREIGN KEY (powermeter_id) REFERENCES powermeters(powermeter_id) ON DELETE CASCADE
);

SELECT public.create_hypertable(
    'measurements',                             -- Name of the table
    'timestamp',                                -- Time column name
    partitioning_column => 'powermeter_id',     -- Partitioning column
    number_partitions   => 4,
    if_not_exists       => TRUE
);

-- Transfer ownership of schema and all tables to 'azure_pg_admin'
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'dev'
    LOOP
        EXECUTE 'ALTER TABLE dev.' || quote_ident(r.tablename) || ' OWNER TO azure_pg_admin;';
    END LOOP;
END $$;