const { app } = require('@azure/functions');

// Setup function app
app.setup({
    enableHttpStream: true,
});

// Import the function files
require('./functions/getData/index'); // Import getData function
require('./functions/pushData/index'); // Import pushData function (if it exists)