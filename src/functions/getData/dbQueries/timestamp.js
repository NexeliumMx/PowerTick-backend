const client = require('../../postgresqlClient');

async function timestamp() {
    try {
        const query = 'SELECT timestamp FROM "powertic"."measurements" ORDER BY "timestamp" DESC LIMIT 1;';
        const result = await client.query(query);

        if (result.rows.length > 0) {
            return result.rows[0].timestamp;
        } else {
            return 'No records found in the table.';
        }
    } catch (error) {
        console.error('Error fetching timestamp:', error.stack);
        throw error;
    }
}

module.exports = { timestamp };