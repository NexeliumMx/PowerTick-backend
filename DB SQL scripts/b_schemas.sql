/**
 * FileName: DB SQL scripts/b_schemas.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating database schemas.
 * Date: 2024-11-11
 *
 * Description:
 * This script creates the `demo`, `dev`, `production`, and `public` schemas 
 * within the `powertick` database. Each schema is assigned the `azure_pg_admin` 
 * as the owner. The script ensures that the schemas are only created if they 
 * do not already exist, allowing for safer execution in existing environments.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

CREATE SCHEMA IF NOT EXISTS demo AUTHORIZATION azure_pg_admin;
CREATE SCHEMA IF NOT EXISTS dev AUTHORIZATION azure_pg_admin;
CREATE SCHEMA IF NOT EXISTS production AUTHORIZATION azure_pg_admin;
CREATE SCHEMA IF NOT EXISTS public AUTHORIZATION azure_pg_admin;