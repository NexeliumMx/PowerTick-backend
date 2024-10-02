const client = require('./postgresqlClient');  // Use require instead of import

// Function to fetch the latest timestamp from the database
async function getTimestamp() {
    try {
        const query = 'SELECT timestamp FROM "powertic"."measurements" ORDER BY timestamp DESC LIMIT 1;';
        const result = await client.query(query);

        if (result.rows.length > 0) {
            console.log('Latest timestamp fetched:', result.rows[0].timestamp);
            return result.rows[0].timestamp;
        } else {
            return 'No records found in the table.';
        }
    } catch (error) {
        console.error('Error fetching timestamp:', error.stack);
        throw error;
    }
}

module.exports = { getTimestamp };  // Export using CommonJS