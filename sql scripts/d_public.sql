CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;

CREATE TABLE IF NOT EXISTS modbusrtu_commands (
  model TEXT,
  modbus_address SMALLINT,
  register_length SMALLINT,
  parameter TEXT,
  unit TEXT,
  data_type TEXT,
  r_w TEXT,
  data_range TEXT,
  industry_standard TEXT,  
  indb BOOLEAN,
  setup BOOLEAN,
  "timestamp" BOOLEAN,
  read_command TEXT,
  write_command TEXT,
  PRIMARY KEY (model, modbus_address)
);

CREATE TABLE IF NOT EXISTS supported_models (
  serial SERIAL PRIMARY KEY,
  manufacturer TEXT NOT NULL,
  series TEXT NOT NULL,
  model TEXT NOT NULL,
  UNIQUE (manufacturer, series, model)
);