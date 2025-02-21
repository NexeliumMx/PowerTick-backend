SELECT
    "timestamp",
    "total_real_energy_imported" - LAG("total_real_energy_imported") OVER (ORDER BY "timestamp") AS "real_energy_consumption_profile",
    "total_var_hours_imported_q1" - LAG("total_var_hours_imported_q1") OVER (ORDER BY "timestamp") AS "reactive_energy_consumption_profile"
FROM "demo"."measurements"
WHERE "serial_number" = 'DEMO0000001'
AND "timestamp" >= NOW() - INTERVAL '1 hour' - INTERVAL '5 minutes'
AND "timestamp" < NOW()
ORDER BY "timestamp" DESC;