const clientpg = require('../postgresqlClient');

// Function to generate query placeholders for prepared statements
function generatePlaceholders(count) {
    return Array.from({ length: count }, (_, i) => `$${i + 1}`).join(', ');
}

// Function to insert data into the database
async function InsertData(table_name, columns, values) {
    try {
        // Generate placeholders for values
        const placeholders = generatePlaceholders(values.length);

        // Join columns properly for the query
        const columnsString = columns.join(', ');
        const query = `INSERT INTO powertic.${table_name} (${columnsString}) VALUES (${placeholders})`;

        // Log the query and values for debugging
        console.log('Executing query:', query);
        console.log('With values:', values);

        // Execute the query
        await clientpg.query(query, values);

        console.log("Data inserted successfully");
        return { success: true, message: 'Data inserted successfully', data: values };

    } catch (error) {
        console.error('Error executing query:', error.message);
        throw error;
    }
}

module.exports = {
    InsertData
};