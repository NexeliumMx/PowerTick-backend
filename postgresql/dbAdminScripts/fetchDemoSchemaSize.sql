SELECT pg_size_pretty(sum(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))) AS schema_size
FROM pg_tables
WHERE schemaname = 'demo';