const { Client } = require('pg');

const client = new Client({
    host: "nexelium-pg.postgres.database.azure.com",
    user: "test_user",
    password: "12345678",
    database: "powertick",
    port: 5432,
    ssl: {
        rejectUnauthorized: false
    }
});

client.connect();

module.exports = client;