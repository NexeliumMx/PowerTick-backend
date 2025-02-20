psql -h nexelium-pg.postgres.database.azure.com -U arturo.vargas@nexelium.com.mx -d powertick

\COPY modbusrtu_commands (
    model,
    modbus_address,
    parameter,
    unit,
    register_length,
    data_type,
    r_w,
    data_range,
    industry_standard,
    indb,
    setup_read,
    setup_write,
    "timestamp",
    read_command,
    write_command,
    value_weight,
    address
)
FROM '/home/avargas/VScode/PowerTick-backend/DB SQL scripts/populate modbus commands table/modbus_uploadCSVtoDB.txt'
DELIMITER ',' 
CSV HEADER 
NULL '';