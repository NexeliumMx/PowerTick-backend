const client = require('../postgresqlClient');

async function getRealtimeData(schemaName, serialNumber) {
    try {
        const query = `
            SELECT
                "timestamp",
                "amps_total",
                "amps_phase_a",
                "amps_phase_b",
                "amps_phase_c",
                "voltage_ln_average",
                "phase_voltage_an",
                "phase_voltage_bn",
                "phase_voltage_cn",
                "voltage_ll_average",
                "phase_voltage_ab",
                "phase_voltage_bc",
                "phase_voltage_ca",
                "frequency",
                "total_real_power",
                "watts_phase_a",
                "watts_phase_b",
                "watts_phase_c",
                "ac_apparent_power_va",
                "va_phase_a",
                "va_phase_b",
                "va_phase_c",
                "reactive_power_var",
                "var_phase_a",
                "var_phase_b",
                "var_phase_c",
                "power_factor",
                "pf_phase_a",
                "pf_phase_b",
                "pf_phase_c",
                "total_real_energy_exported",
                "total_watt_hours_exported_in_phase_a",
                "total_watt_hours_exported_in_phase_b",
                "total_watt_hours_exported_in_phase_c",
                "total_real_energy_imported",
                "total_watt_hours_imported_phase_a",
                "total_watt_hours_imported_phase_b",
                "total_watt_hours_imported_phase_c",
                "total_va_hours_exported",
                "total_va_hours_exported_phase_a",
                "total_va_hours_exported_phase_b",
                "total_va_hours_exported_phase_c",
                "total_va_hours_imported",
                "total_va_hours_imported_phase_a",
                "total_va_hours_imported_phase_b",
                "total_va_hours_imported_phase_c",
                "total_var_hours_imported_q1",
                "total_var_hours_imported_q1_phase_a",
                "total_var_hours_imported_q1_phase_b",
                "total_var_hours_imported_q1_phase_c",
                "total_var_hours_imported_q2",
                "total_var_hours_imported_q2_phase_a",
                "total_var_hours_imported_q2_phase_b",
                "total_var_hours_imported_q2_phase_c",
                "total_var_hours_exported_q3",
                "total_var_hours_exported_q3_phase_a",
                "total_var_hours_exported_q3_phase_b",
                "total_var_hours_exported_q3_phase_c",
                "total_var_hours_exported_q4",
                "total_var_hours_exported_q4_phase_a",
                "total_var_hours_exported_q4_phase_b",
                "total_var_hours_exported_q4_phase_c"
            FROM "${schemaName}"."measurements"
            WHERE "serial_number" = $1
                AND "timestamp" <= DATE_TRUNC('minute', NOW() AT TIME ZONE 'UTC')
            ORDER BY "timestamp" DESC
            LIMIT 1;
        `;
        
        const values = [serialNumber];
        const result = await client.query(query, values);

        if (result.rows.length > 0) {
            const row = result.rows[0];

            // Parse each value to ensure numeric consistency
            const parseToNumber = (value) => (value === null ? null : Number(value));

            const realtimeData = {
                timestamp: row.timestamp,  // Add timestamp to the output
                amps_total: parseToNumber(row.amps_total),
                amps_phase_a: parseToNumber(row.amps_phase_a),
                amps_phase_b: parseToNumber(row.amps_phase_b),
                amps_phase_c: parseToNumber(row.amps_phase_c),
                voltage_ln_average: parseToNumber(row.voltage_ln_average),
                phase_voltage_an: parseToNumber(row.phase_voltage_an),
                phase_voltage_bn: parseToNumber(row.phase_voltage_bn),
                phase_voltage_cn: parseToNumber(row.phase_voltage_cn),
                voltage_ll_average: parseToNumber(row.voltage_ll_average),
                phase_voltage_ab: parseToNumber(row.phase_voltage_ab),
                phase_voltage_bc: parseToNumber(row.phase_voltage_bc),
                phase_voltage_ca: parseToNumber(row.phase_voltage_ca),
                frequency: parseToNumber(row.frequency),
                total_real_power: parseToNumber(row.total_real_power),
                watts_phase_a: parseToNumber(row.watts_phase_a),
                watts_phase_b: parseToNumber(row.watts_phase_b),
                watts_phase_c: parseToNumber(row.watts_phase_c),
                ac_apparent_power_va: parseToNumber(row.ac_apparent_power_va),
                va_phase_a: parseToNumber(row.va_phase_a),
                va_phase_b: parseToNumber(row.va_phase_b),
                va_phase_c: parseToNumber(row.va_phase_c),
                reactive_power_var: parseToNumber(row.reactive_power_var),
                var_phase_a: parseToNumber(row.var_phase_a),
                var_phase_b: parseToNumber(row.var_phase_b),
                var_phase_c: parseToNumber(row.var_phase_c),
                power_factor: parseToNumber(row.power_factor),
                pf_phase_a: parseToNumber(row.pf_phase_a),
                pf_phase_b: parseToNumber(row.pf_phase_b),
                pf_phase_c: parseToNumber(row.pf_phase_c),
                total_real_energy_exported: parseToNumber(row.total_real_energy_exported),
                total_watt_hours_exported_in_phase_a: parseToNumber(row.total_watt_hours_exported_in_phase_a),
                total_watt_hours_exported_in_phase_b: parseToNumber(row.total_watt_hours_exported_in_phase_b),
                total_watt_hours_exported_in_phase_c: parseToNumber(row.total_watt_hours_exported_in_phase_c),
                total_real_energy_imported: parseToNumber(row.total_real_energy_imported),
                total_watt_hours_imported_phase_a: parseToNumber(row.total_watt_hours_imported_phase_a),
                total_watt_hours_imported_phase_b: parseToNumber(row.total_watt_hours_imported_phase_b),
                total_watt_hours_imported_phase_c: parseToNumber(row.total_watt_hours_imported_phase_c),
                total_va_hours_exported: parseToNumber(row.total_va_hours_exported),
                total_va_hours_exported_phase_a: parseToNumber(row.total_va_hours_exported_phase_a),
                total_va_hours_exported_phase_b: parseToNumber(row.total_va_hours_exported_phase_b),
                total_va_hours_exported_phase_c: parseToNumber(row.total_va_hours_exported_phase_c),
                total_va_hours_imported: parseToNumber(row.total_va_hours_imported),
                total_va_hours_imported_phase_a: parseToNumber(row.total_va_hours_imported_phase_a),
                total_va_hours_imported_phase_b: parseToNumber(row.total_va_hours_imported_phase_b),
                total_va_hours_imported_phase_c: parseToNumber(row.total_va_hours_imported_phase_c),
                total_var_hours_imported_q1: parseToNumber(row.total_var_hours_imported_q1),
                total_var_hours_imported_q1_phase_a: parseToNumber(row.total_var_hours_imported_q1_phase_a),
                total_var_hours_imported_q1_phase_b: parseToNumber(row.total_var_hours_imported_q1_phase_b),
                total_var_hours_imported_q1_phase_c: parseToNumber(row.total_var_hours_imported_q1_phase_c),
                total_var_hours_imported_q2: parseToNumber(row.total_var_hours_imported_q2),
                total_var_hours_imported_q2_phase_a: parseToNumber(row.total_var_hours_imported_q2_phase_a),
                total_var_hours_imported_q2_phase_b: parseToNumber(row.total_var_hours_imported_q2_phase_b),
                total_var_hours_imported_q2_phase_c: parseToNumber(row.total_var_hours_imported_q2_phase_c),
                total_var_hours_exported_q3: parseToNumber(row.total_var_hours_exported_q3),
                total_var_hours_exported_q3_phase_a: parseToNumber(row.total_var_hours_exported_q3_phase_a),
                total_var_hours_exported_q3_phase_b: parseToNumber(row.total_var_hours_exported_q3_phase_b),
                total_var_hours_exported_q3_phase_c: parseToNumber(row.total_var_hours_exported_q3_phase_c),
                total_var_hours_exported_q4: parseToNumber(row.total_var_hours_exported_q4),
                total_var_hours_exported_q4_phase_a: parseToNumber(row.total_var_hours_exported_q4_phase_a),
                total_var_hours_exported_q4_phase_b: parseToNumber(row.total_var_hours_exported_q4_phase_b),
                total_var_hours_exported_q4_phase_c: parseToNumber(row.total_var_hours_exported_q4_phase_c)
            };
            return realtimeData;
        } else {
            return {
                message: 'No real-time data found for the specified serial number.',
            };
        }
    } catch (error) {
        console.error('Error fetching real-time data:', error.stack);
        throw error;
    }
}

module.exports = { getRealtimeData };