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