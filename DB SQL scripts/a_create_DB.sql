/**
 * FileName: DB SQL scripts/a_create_DB.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating the PowerTick database.
 * Date: 2024-11-11
 *
 * Description:
 * This script creates the `powertick` database with UTF-8 encoding and specifies 
 * the database owner as `azure_pg_admin`. The database is configured with a 
 * connection limit of -1 (unlimited connections) and is not set as a template. 
 * The script ensures that the database is properly initialized for further schema 
 * creation and data management.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

CREATE DATABASE "powertick"
    WITH
    OWNER = azure_pg_admin
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;