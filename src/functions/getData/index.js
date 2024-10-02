const { app } = require('@azure/functions');
const { getTimestamp } = require('./dbQueries/getTimestamp');

app.http('getTimestamp', {
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        try {
            const latestTimestamp = await getTimestamp();

            return {
                body: JSON.stringify({ timestamp: latestTimestamp }),
                headers: {
                    'Content-Type': 'application/json'
                }
            };
        } catch (error) {
            context.log.error('Error fetching timestamp:', error);

            return {
                status: 500,
                body: JSON.stringify({
                    message: 'Error fetching timestamp',
                    error: error.message
                }),
                headers: {
                    'Content-Type': 'application/json'
                }
            };
        }
    }
});