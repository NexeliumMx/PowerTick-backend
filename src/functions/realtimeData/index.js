const { app } = require('@azure/functions');
const { getRealtimeData } = require('./getRealtimeData');

// Allowed serial number format
const serialNumberRegex = /^[A-Za-z0-9\-]+$/;

// Define the HTTP-triggered function
app.http('getRealtimeData', {
    route: 'powermeters/{serialNumber}/realtime',
    methods: ['GET'],
    authLevel: 'anonymous', // Adjust as needed for security
    handler: async (request, context) => {
        context.log(`HTTP function 'getRealtimeData' processed request for URL: "${request.url}"`);

        try {
            // Extract serial number from the URL path
            const serialNumber = request.params.serialNumber;
            context.log(`Extracted serial number: ${serialNumber}`);

            // Validate the serial number format
            if (!serialNumber || !serialNumberRegex.test(serialNumber)) {
                context.log('Invalid or missing serial number');
                return {
                    status: 400,
                    body: JSON.stringify({ message: 'Invalid or missing serial number.' }),
                    headers: { 'Content-Type': 'application/json' },
                };
            }

            // Extract optional query parameters (e.g., schema)
            const schemaName = request.query.get('schema') || 'powertic';
            context.log(`Using schema: ${schemaName}`);

            // Validate the schema name if necessary
            const allowedSchemas = ['powertic', 'demo'];
            const schemaRegex = /^[a-zA-Z0-9_]+$/;
            if (!allowedSchemas.includes(schemaName) || !schemaRegex.test(schemaName)) {
                context.log('Invalid or missing schema name');
                return {
                    status: 400,
                    body: JSON.stringify({ message: 'Invalid or missing schema name.' }),
                    headers: { 'Content-Type': 'application/json' },
                };
            }

            // Call the function to get real-time data
            const realtimeData = await getRealtimeData(schemaName, serialNumber);
            context.log(`Retrieved data: ${JSON.stringify(realtimeData)}`);

            // Check if data was found
            if (realtimeData.message) {
                context.log('No real-time data found');
                return {
                    status: 404,
                    body: JSON.stringify({ message: realtimeData.message }),
                    headers: { 'Content-Type': 'application/json' },
                };
            }

            // Return the real-time data
            return {
                status: 200,
                body: JSON.stringify(realtimeData),
                headers: { 'Content-Type': 'application/json' },
            };
        } catch (error) {
            context.log.error('Error fetching real-time data:', error);

            return {
                status: 500,
                body: JSON.stringify({
                    message: 'Error fetching real-time data',
                    error: error.message,
                }),
                headers: { 'Content-Type': 'application/json' },
            };
        }
    },
});
