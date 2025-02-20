/**
 * FileName: DB SQL scripts/d_transfer_tables_ownership.sql
 * Author(s): Arturo Vargas
 * Brief: SQL script for transferring ownership of all tables to a new owner.
 * Date: 2024-12-02
 *
 * Description:
 * This script automates the process of transferring ownership of all tables 
 * in the `demo`, `dev`, and `public` schemas to the specified owner `azure_pg_admin`. 
 * It uses a PL/pgSQL block to iterate over all tables in the mentioned schemas and 
 * dynamically alters their ownership. The process is performed in three distinct 
 * loops: one for each schema, ensuring that all relevant tables are updated to the 
 * new owner. This script simplifies table ownership management across multiple schemas.
 *
 * Copyright (c) 2025 BY: Nexelium Technological Solutions S.A. de C.V.
 * All rights reserved.
 */


DO $$
DECLARE
    tbl RECORD;
BEGIN
    -- Transfer ownership of all tables in the 'demo' schema
    FOR tbl IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'demo'
    LOOP
        EXECUTE format('ALTER TABLE demo.%I OWNER TO azure_pg_admin;', tbl.tablename);
    END LOOP;

    -- Transfer ownership of all tables in the 'dev' schema
    FOR tbl IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'dev'
    LOOP
        EXECUTE format('ALTER TABLE dev.%I OWNER TO azure_pg_admin;', tbl.tablename);
    END LOOP;

    -- Transfer ownership of all tables in the 'public' schema
    FOR tbl IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER TABLE public.%I OWNER TO azure_pg_admin;', tbl.tablename);
    END LOOP;
END $$;