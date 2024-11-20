CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;

CREATE TABLE IF NOT EXISTS modbusrtu_commands (
    model TEXT,
    modbus_address INTEGER,
    parameter TEXT,
    unit TEXT,
    register_length SMALLINT,
    data_type TEXT,
    r_w TEXT,
    data_range TEXT,
    industry_standard TEXT,
    indb BOOLEAN DEFAULT FALSE,
    setup_read BOOLEAN DEFAULT FALSE,
    setup_write BOOLEAN DEFAULT FALSE,
    "timestamp" BOOLEAN DEFAULT FALSE,
    read_command TEXT DEFAULT NULL,
    write_command TEXT DEFAULT NULL,
    value_weight NUMERIC DEFAULT NULL,
    PRIMARY KEY (model, modbus_address)
);

CREATE TABLE IF NOT EXISTS supported_models (
  serial SERIAL PRIMARY KEY,
  manufacturer TEXT NOT NULL,
  series TEXT NOT NULL,
  model TEXT NOT NULL,
  UNIQUE (manufacturer, series, model)
);