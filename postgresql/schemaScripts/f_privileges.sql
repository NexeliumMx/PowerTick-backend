/**
 * FileName: DB SQL scripts/f_privileges.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for granting table privileges to `azure_pg_admin` role.
 * Date: 2024-12-02
 *
 * Description:
 * This script grants the `azure_pg_admin` role the following privileges on all tables 
 * in the `public`, `demo`, and `dev` schemas: SELECT, INSERT, UPDATE, and DELETE. 
 * These privileges allow the `azure_pg_admin` role full access to manipulate data 
 * in the specified schemas. The script ensures that the role has comprehensive control 
 * over all tables within the schemas, facilitating the administration of data.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO azure_pg_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA demo TO azure_pg_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA dev TO azure_pg_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA production TO azure_pg_admin;