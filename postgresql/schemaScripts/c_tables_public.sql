/**
 * FileName: DB SQL scripts/c_public_tables.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating public schema tables.
 * Date: 2024-11-11
 *
 * Description:
 * This script creates the necessary tables in the `public` schema for storing 
 * information related to Modbus RTU commands and supported device models.
 * It first sets the search path to the `public` schema and then proceeds to create:
 * - `modbusrtu_commands` table: Stores details about Modbus RTU commands, including 
 *   parameters like model, modbus address, register length, data type, and command 
 *   specifics such as read/write permissions and commands. It also includes default 
 *   values for certain columns and establishes a composite primary key using model 
 *   and modbus address.
 * - `supported_models` table: Stores details about supported device models, with 
 *   information on manufacturer, series, and model. It also defines a unique constraint 
 *   on the combination of manufacturer, series, and model.
 * The tables ensure that information related to Modbus commands and device models 
 * is properly structured and accessible for further operations.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 *
 * Change Log:
 * - 2025-05-22:
 *   - Added: CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public; to ensure uuid_generate_v4() is available in the public schema.
 */

CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public;

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
    read_command INT DEFAULT NULL,
    write_command INT DEFAULT NULL,
    value_weight NUMERIC DEFAULT NULL,
    "address" INT,
    PRIMARY KEY (model, modbus_address)
);

CREATE TABLE IF NOT EXISTS supported_models (
  serial SERIAL PRIMARY KEY,
  manufacturer TEXT NOT NULL,
  series TEXT NOT NULL,
  model TEXT NOT NULL,
  UNIQUE (manufacturer, series, model)
);