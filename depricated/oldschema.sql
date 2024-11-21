SET CONSTRAINTS ALL DEFERRED;

CREATE SCHEMA IF NOT EXISTS powertic;
SET search_path TO powertic;

CREATE TABLE IF NOT EXISTS Meters (
  serial_number TEXT PRIMARY KEY,
  sunspec_id TEXT NOT NULL,
  id TEXT NOT NULL,
  manufacturer TEXT NOT NULL,
  model TEXT NOT NULL,
  "version" TEXT NOT NULL,
  client TEXT NOT NULL,
  branch TEXT NOT NULL,
  "location" TEXT NOT NULL,
  load_center TEXT NOT NULL,
  register_date TIMESTAMPTZ NOT NULL,
  facturation_intervalmonths SMALLINT NOT NULL,
  UNIQUE (serial_number),
  FOREIGN KEY (client)
    REFERENCES clients (client)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS ModbusQueries (
  Serial INT PRIMARY KEY,
  modbus_Address JSONB NOT NULL,
  parameter_description TEXT NOT NULL,
  "standard" TEXT NOT NULL,
  data_type TEXT NOT NULL,
  data_range TEXT NOT NULL,
  model TEXT NOT NULL,
  mod_default TEXT NOT NULL,
  register_number SMALLINT NOT NULL,
  indb BOOLEAN NOT NULL,
  setup BOOLEAN NOT NULL,
  UNIQUE (Serial),
  UNIQUE (modbus_Address)
);

CREATE TABLE IF NOT EXISTS Measurements (
  "timestamp" TIMESTAMPTZ NOT NULL,
  amps_total SMALLINT NOT NULL,
  amps_phase_a SMALLINT NOT NULL,
  amps_phase_b SMALLINT NOT NULL,
  amps_phase_c SMALLINT NOT NULL,
  voltage_ln_average SMALLINT NOT NULL,
  phase_voltage_an SMALLINT NOT NULL,
  phase_voltage_bn SMALLINT NOT NULL,
  phase_voltage_cn SMALLINT NOT NULL,
  voltage_ll_average SMALLINT NOT NULL,
  phase_voltage_ab SMALLINT NOT NULL,
  phase_voltage_bc SMALLINT NOT NULL,
  phase_voltage_ca SMALLINT NOT NULL,
  frequency SMALLINT NOT NULL,
  total_real_power SMALLINT NOT NULL,
  watts_phase_a SMALLINT NOT NULL,
  watts_phase_b SMALLINT NOT NULL,
  watts_phase_c SMALLINT NOT NULL,
  ac_apparent_power_va SMALLINT NOT NULL,
  va_phase_a SMALLINT NOT NULL,
  va_phase_b SMALLINT NOT NULL,
  va_phase_c SMALLINT NOT NULL,
  reactive_power_var SMALLINT NOT NULL,
  var_phase_a SMALLINT NOT NULL,
  var_phase_b SMALLINT NOT NULL,
  var_phase_c SMALLINT NOT NULL,
  power_factor SMALLINT NOT NULL,
  pf_phase_a SMALLINT NOT NULL,
  pf_phase_b SMALLINT NOT NULL,
  pf_phase_c SMALLINT NOT NULL,
  total_real_energy_exported INT NOT NULL,
  total_watt_hours_exported_in_phase_a INT NOT NULL,
  total_watt_hours_exported_in_phase_b INT NOT NULL,
  total_watt_hours_exported_in_phase_c INT NOT NULL,
  total_real_energy_imported INT NOT NULL,
  total_watt_hours_imported_phase_a INT NOT NULL,
  total_watt_hours_imported_phase_b INT NOT NULL,
  total_watt_hours_imported_phase_c INT NOT NULL,
  total_va_hours_exported INT NOT NULL,
  total_va_hours_exported_phase_a INT NOT NULL,
  total_va_hours_exported_phase_b INT NOT NULL,
  total_va_hours_exported_phase_c INT NOT NULL,
  total_va_hours_imported INT NOT NULL,
  total_va_hours_imported_phase_a INT NOT NULL,
  total_va_hours_imported_phase_b INT NOT NULL,
  total_va_hours_imported_phase_c INT NOT NULL,
  total_var_hours_imported_q1 INT NOT NULL,
  total_var_hours_imported_q1_phase_a INT NOT NULL,
  total_var_hours_imported_q1_phase_b INT NOT NULL,
  total_var_hours_imported_q1_phase_c INT NOT NULL,
  total_var_hours_imported_q2 INT NOT NULL,
  total_var_hours_imported_q2_phase_a INT NOT NULL,
  total_var_hours_imported_q2_phase_b INT NOT NULL,
  total_var_hours_imported_q2_phase_c INT NOT NULL,
  total_var_hours_exported_q3 INT NOT NULL,
  total_var_hours_exported_q3_phase_a INT NOT NULL,
  total_var_hours_exported_q3_phase_b INT NOT NULL,
  total_var_hours_exported_q3_phase_c INT NOT NULL,
  total_var_hours_exported_q4 INT NOT NULL,
  total_var_hours_exported_q4_phase_a INT NOT NULL,
  total_var_hours_exported_q4_phase_b INT NOT NULL,
  total_var_hours_exported_q4_phase_c INT NOT NULL,
  serial_number TEXT NOT NULL,
  PRIMARY KEY ("timestamp", serial_number),
  FOREIGN KEY (serial_number)
    REFERENCES Meters (serial_number)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS clients (
  client TEXT PRIMARY KEY,
  broker TEXT NOT NULL,
  cloud_services BOOLEAN NOT NULL,
  payment BOOLEAN NOT NULL,
  payment_amount INT NOT NULL,
  FOREIGN KEY (broker)
    REFERENCES Brokers (broker_name)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);









SET CONSTRAINTS ALL IMMEDIATE;

-- Insert default values
INSERT INTO powertic.brokers (broker_name, clients, facturation, contract_date) 
VALUES ('not_set', 0, 0, NOW());

INSERT INTO powertic.clients (broker, client, cloud_services, payment, payment_amount) 
VALUES ('not_set', 'not_set', FALSE, FALSE, 0);