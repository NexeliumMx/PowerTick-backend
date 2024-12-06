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
  phase_voltage_bc INT,
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
  PRIMARY KEY ("timestamp", serial_number),
  FOREIGN KEY (serial_number)
    REFERENCES powermeters (serial_number)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


SET CONSTRAINTS ALL IMMEDIATE;