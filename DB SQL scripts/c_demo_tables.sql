SET CONSTRAINTS ALL DEFERRED;

CREATE SCHEMA IF NOT EXISTS demo AUTHORIZATION azure_pg_admin;
SET search_path TO demo;

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
  ct INT, -- Current Transformer
  vt INT, -- Voltage Transformer
  UNIQUE (serial_number),
  FOREIGN KEY (client_id)
    REFERENCES clients (client_id)
    ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS measurements (
  "timestamp" TIMESTAMPTZ,
  serial_number TEXT,
  amps_total SMALLINT,
  amps_phase_a SMALLINT,
  amps_phase_b SMALLINT,
  amps_phase_c SMALLINT,
  voltage_ln_average SMALLINT,
  phase_voltage_an SMALLINT,
  phase_voltage_bn SMALLINT,
  phase_voltage_cn SMALLINT,
  voltage_ll_average SMALLINT,
  phase_voltage_ab SMALLINT,
  phase_voltage_bc SMALLINT,
  phase_voltage_ca SMALLINT,
  frequency SMALLINT,
  total_real_power SMALLINT,
  watts_phase_a SMALLINT,
  watts_phase_b SMALLINT,
  watts_phase_c SMALLINT,
  ac_apparent_power_va SMALLINT,
  va_phase_a SMALLINT,
  va_phase_b SMALLINT,
  va_phase_c SMALLINT,
  reactive_power_var SMALLINT,
  var_phase_a SMALLINT,
  var_phase_b SMALLINT,
  var_phase_c SMALLINT,
  power_factor SMALLINT,
  pf_phase_a SMALLINT,
  pf_phase_b SMALLINT,
  pf_phase_c SMALLINT,
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
  PRIMARY KEY ("timestamp", serial_number),
  FOREIGN KEY (serial_number)
    REFERENCES powermeters (serial_number)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

SET CONSTRAINTS ALL IMMEDIATE;