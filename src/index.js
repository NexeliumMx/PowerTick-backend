const { app } = require('@azure/functions');

// Setup function app
app.setup({
    enableHttpStream: true,
});

// Import the function files
require('./functions/pushData/index');
require('./functions/realtimeData/index');
require('./functions/historicalData/index');