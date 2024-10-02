const { app } = require('@azure/functions');
const { getTimestamp } = require('./dbQueries/getTimestamp'); // Import the getTimestamp function

// Set up the HTTP-triggered function
app.http('getData', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        try {
            // Fetch the latest timestamp using the getTimestamp function
            const latestTimestamp = await getTimestamp();

            // Return the fetched timestamp as the response
            return {
                body: {
                    message: 'Latest timestamp retrieved successfully',
                    timestamp: latestTimestamp
                }
            };
        } catch (error) {
            // Handle errors during the database query
            context.log.error('Error fetching timestamp:', error);

            return {
                status: 500, // Internal Server Error
                body: {
                    message: 'Error fetching timestamp',
                    error: error.message
                }
            };
        }
    }
});