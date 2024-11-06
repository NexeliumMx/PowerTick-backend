const { app } = require('@azure/functions');
const { getHistoricConsumption } = require('./getHistoricConsumption');

// Define the HTTP-triggered function for historical consumption data
app.http('getHistoricConsumption', {
    route: 'powermeters/{serialNumber}/history/consumption/hour',
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        const serialNumber = request.params.serialNumber;
        const schemaName = request.query.get('schema');

        // Check for missing schema parameter
        if (!schemaName) {
            return {
                status: 400,
                body: JSON.stringify({ message: 'Schema parameter is required.' }),
                headers: { 'Content-Type': 'application/json' },
            };
        }

        try {
            // Retrieve the historic consumption data for the past hour
            const consumptionData = await getHistoricConsumption(schemaName, serialNumber);

            return {
                status: 200,
                body: JSON.stringify(consumptionData),
                headers: { 'Content-Type': 'application/json' },
            };
        } catch (error) {
            context.log.error('Error fetching historical consumption data:', error);
            return {
                status: 500,
                body: JSON.stringify({ message: 'Error fetching historical consumption data', error: error.message }),
                headers: { 'Content-Type': 'application/json' },
            };
        }
    }
});
