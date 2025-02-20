/**
 * FileName: DB SQL scripts/e_local_test_user.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for creating and granting privileges to a local test user.
 * Date: 2024-12-02
 *
 * Description:
 * This script creates a new database role `local_test_user` with specific privileges 
 * for testing purposes. The user is granted login capabilities but restricted from 
 * performing administrative tasks such as creating databases or roles. Additionally, 
 * the user inherits roles and does not have replication privileges or the ability to 
 * bypass row-level security. The password for the user is set to '12345678', and 
 * the user is granted the `azure_pg_admin` role with admin options, allowing them 
 * to manage other users with the same privileges.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */

CREATE ROLE local_test_user WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD '12345678';
GRANT azure_pg_admin TO local_test_user WITH ADMIN OPTION;