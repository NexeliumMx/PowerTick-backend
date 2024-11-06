const client = require('../postgresqlClient');

async function getHistoricConsumption(schemaName, serialNumber) {
    try {
        // SQL query to retrieve data for the last hour with a 5-minute interval
        const query = `
            SELECT
                "timestamp",
                "total_real_energy_imported",
                "total_var_hours_imported_q1"
            FROM "${schemaName}"."measurements"
            WHERE "serial_number" = $1
              AND "timestamp" >= NOW() - INTERVAL '1 hour' - INTERVAL '5 minutes'
              AND "timestamp" < NOW()
            ORDER BY "timestamp" ASC
        `;

        const values = [serialNumber];
        const result = await client.query(query, values);

        if (result.rows.length > 0) {
            // Return the raw rows as JSON
            return result.rows;
        } else {
            return { message: 'No data found for the specified serial number.' };
        }
    } catch (error) {
        console.error('Error fetching last hour consumption data:', error.stack);
        throw error;
    }
}

module.exports = { getHistoricConsumption };
