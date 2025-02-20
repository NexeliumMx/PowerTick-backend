INSERT INTO public.supported_models (serial, manufacturer, series, model) VALUES
(1, 'Accuenergy', 'AcuRev 1300', 'acurev-1313-5a-x0'),
(2, 'Carlo Gavazzi', 'EM210', 'EM210-72D.MV5.3.X.OS.X');

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
    value_weight
)
FROM '/home/avargas/VScode/PowerTick-backend/modbusrtu_commands.csv'
DELIMITER ',' 
CSV HEADER 
NULL '';