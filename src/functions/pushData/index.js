const { app } = require('@azure/functions');
const { InsertData } = require('./pushDataFormatter');

app.http('pushData', {
    methods: ['POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`HTTP function processed request for URL "${request.url}"`);

        try {
            // For POST requests, data should be in the request body
            const data = await request.json();
            context.log('Received data:', data);

            // Ensure data is an array
            if (!Array.isArray(data)) {
                throw new Error('Expected data to be an array of objects');
            }

            let table_name = '';

            // Loop over the data array and insert each item into the database
            for (const item of data) {
                if (item.table) {
                    table_name = item.table;
                    context.log("Table name found:", table_name);
                } else {
                    if (!table_name) {
                        throw new Error('Table name not specified before data objects');
                    }

                    const columns = Object.keys(item);
                    const values = Object.values(item);

                    try {
                        await InsertData(table_name, columns, values);
                        context.log('Data inserted successfully');
                    } catch (error) {
                        context.error('Error inserting data:', error.message);
                        throw error;
                    }
                }
            }

            return { status: 200, body: 'Data inserted successfully' };

        } catch (error) {
            context.error('Error processing request:', error.message);
            return { status: 500, body: 'Data insertion failed' };
        }
    }
});