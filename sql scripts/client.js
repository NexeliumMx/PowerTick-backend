const { Client } = require('pg');

const client = new Client({
    host: "powertic.postgres.database.azure.com",
    user: "superadmin",
    password: "vafja6-hexpem-javdyN",
    database: "postgres",
    port: 5432,
    ssl: {
        rejectUnauthorized: false
    }
});

client.connect();

module.exports = client;