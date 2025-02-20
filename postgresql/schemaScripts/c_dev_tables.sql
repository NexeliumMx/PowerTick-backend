/**
 * FileName: DB SQL scripts/c_demo_tables.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating and managing demo database tables.
 * Date: 2024-11-11
 *
 * Description:
 * This script defines the schema and tables for the dev database, including users, clients, 
 * powermeters, and measurements. It ensures proper relationships between entities and 
 * enforces data integrity constraints.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * Version History:
 * - 2024-11-11: Initial schema creation.
 * - 2024-09-01: Added `clients` table to manage customer information.
 * - 2024-09-11: Created `powermeters` table to store device metadata.
 * - 2024-10-04: Implemented `measurements` table to track power data.
 * - 2025-02-10: Improved foreign key constraints and optimized indexing.
 */

SET CONSTRAINTS ALL DEFERRED;

CREATE SCHEMA IF NOT EXISTS dev AUTHORIZATION azure_pg_admin;
SET search_path TO dev;

CREATE TABLE IF NOT EXISTS clients (
    client_id TEXT PRIMARY KEY, --RFC
    client_name TEXT, --Razon Social
    register_date TIMESTAMPTZ NOT NULL,
    subscription_status VARCHAR(50) NOT NULL,  --"active", "inactive", "trial"
    cloud_services_provider BOOLEAN NOT NULL, --Is Nexelium providing?
    payment BOOLEAN NOT NULL,
    payment_amount INT NOT NULL
);

CREATE TABLE IF NOT EXISTS powermeters (
  client_id TEXT,
  -- hardware details
  serial_number TEXT PRIMARY KEY,
  manufacturer TEXT,
  series TEXT,
  model TEXT,
  firmware_v TEXT, 
  -- location details
  branch TEXT,
  "location" TEXT, -- CP
  coordinates TEXT, -- Lat, Long
  load_center TEXT,
  -- dates
  register_date TIMESTAMPTZ,
  facturation_interval_months SMALLINT, -- 1 or 2
  facturation_day SMALLINT, --27
  time_zone TEXT, --"America/Mexico_City"
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
  serial_number INT,
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
  FOREIGN KEY (client_id)
    REFERENCES clients (client_id)
    ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS measurements (
  "timestamp" TIMESTAMPTZ,
  serial_number TEXT,
  amps_total INT,
  amps_phase_a INT,
  amps_phase_b INT,
  amps_phase_c INT,
  voltage_ln_average INT,
  phase_voltage_an INT,
  phase_voltage_bn INT,
  phase_voltage_cn INT,
  voltage_ll_average INT,
  phase_voltage_ab INT,
  voltage_bc INT,
  phase_voltage_ca INT,
  frequency INT,
  total_real_power INT,
  watts_phase_a INT,
  watts_phase_b INT,
  watts_phase_c INT,
  ac_apparent_power_va INT,
  va_phase_a INT,
  va_phase_b INT,
  va_phase_c INT,
  reactive_power_var INT,
  var_phase_a INT,
  var_phase_b INT,
  var_phase_c INT,
  power_factor INT,
  pf_phase_a INT,
  pf_phase_b INT,
  pf_phase_c INT,
  total_real_energy_exported INT,
  total_watt_hours_exported_in_phase_a INT,
  total_watt_hours_exported_in_phase_b INT,
  total_watt_hours_exported_in_phase_c INT,
  total_real_energy_imported INT,
  total_watt_hours_imported_phase_a INT,
  total_watt_hours_imported_phase_b INT,
  total_watt_hours_imported_phase_c INT,
  total_va_hours_exported INT,
  total_va_hours_exported_phase_a INT,
  total_va_hours_exported_phase_b INT,
  total_va_hours_exported_phase_c INT,
  total_va_hours_imported INT,
  total_va_hours_imported_phase_a INT,
  total_va_hours_imported_phase_b INT,
  total_va_hours_imported_phase_c INT,
  total_var_hours_imported_q1 INT,
  total_var_hours_imported_q1_phase_a INT,
  total_var_hours_imported_q1_phase_b INT,
  total_var_hours_imported_q1_phase_c INT,
  total_var_hours_imported_q2 INT,
  total_var_hours_imported_q2_phase_a INT,
  total_var_hours_imported_q2_phase_b INT,
  total_var_hours_imported_q2_phase_c INT,
  total_var_hours_exported_q3 INT,
  total_var_hours_exported_q3_phase_a INT,
  total_var_hours_exported_q3_phase_b INT,
  total_var_hours_exported_q3_phase_c INT,
  total_var_hours_exported_q4 INT,
  total_var_hours_exported_q4_phase_a INT,
  total_var_hours_exported_q4_phase_b INT,
  total_var_hours_exported_q4_phase_c INT,
  phase_sequence INT,
  hour_counter INT,
  hour_counter_neg INT,
  thd_current_phase_a INT,
  thd_current_phase_b INT,
  thd_current_phase_c INT,
  thd_voltage_average_ln INT,
  thd_voltage_phase_an INT,
  thd_voltage_phase_bn INT,
  thd_voltage_phase_cn INT,
  thd_voltage_average_ll INT,
  thd_voltage_phase_ab INT,
  thd_voltage_phase_bc INT,
  thd_voltage_phase_ca INT,
  amps_neutral INT,
  input_active_power_total_max_demand FLOAT,
  input_active_power_total_max_demand_occur_time BIGINT,
  input_active_power_rate1_max_demand_and_occur_time FLOAT,
  input_active_power_rate1_max_demand_occur_time BIGINT,
  input_active_power_rate2_max_demand_and_occur_time FLOAT,
  input_active_power_rate2_max_demand_occur_time BIGINT,
  input_active_power_rate3_max_demand_and_occur_time FLOAT,
  input_active_power_rate3_max_demand_occur_time BIGINT,
  input_active_power_rate4_max_demand_and_occur_time FLOAT,
  input_active_power_rate4_max_demand_occur_time BIGINT,
  output_active_power_total_max_demand FLOAT,
  output_active_power_total_max_demand_occur_time BIGINT,
  output_active_power_rate1_max_demand FLOAT,
  output_active_power_rate1_max_demand_occur_time BIGINT,
  output_active_power_rate2_max_demand FLOAT,
  output_active_power_rate2_max_demand_occur_time BIGINT,
  output_active_power_rate3_max_demand FLOAT,
  output_active_power_rate3_max_demand_occur_time BIGINT,
  output_active_power_rate4_max_demand FLOAT,
  output_active_power_rate4_max_demand_occur_time BIGINT,
  clock_year SMALLINT,
  clock_month SMALLINT,
  clock_date SMALLINT,
  clock_hour SMALLINT,
  clock_minute SMALLINT,
  clock_second SMALLINT,
  ac_apparent_power_va INT,
  reactive_power_var INT,
  dmd_w INT,
  dmd_va INT,
  dmd_watts_total INT,
  dmd_va_total INT,
  dmd_a_max INT,
  input_active_power_total_demand INT,
  input_reactive_power_total_demand INT,
  input_active_power_par INT,
  input_reactive_power_par INT,
  input_active_power_tariff_1 INT,
  input_active_power_tariff_2 INT,
  input_active_power_tariff_3 INT,
  input_active_power_tariff_4 INT,
  input_reactive_power_tariff_1 INT,
  input_reactive_power_tariff_2 INT,
  input_reactive_power_tariff_3 INT,
  input_reactive_power_tariff_4 INT,
  output_active_power_total_demand INT,
  output_reactive_power_total_demand INT,
  hour_counter INT,
  counter_1 INT,
  counter_2 INT,
  counter_3 INT,
  PRIMARY KEY ("timestamp", serial_number),
  FOREIGN KEY (serial_number)
    REFERENCES powermeters (serial_number)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


SET CONSTRAINTS ALL IMMEDIATE;