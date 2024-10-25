const axios = require('axios'); // Use axios for HTTP requests
const fs = require('fs');
const path = require('path');

// Function to back up data into a local file
function info_backup(data, file_path) {
    const dir = path.dirname(file_path);
    
    // Ensure directory exists
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }

    // If the file does not exist, create it and add the data
    if (!fs.existsSync(file_path)) {
        fs.writeFileSync(file_path, JSON.stringify([data], null, 4));
        console.log(`Created ${file_path} and backed up info.`);
    } else {
        // If file exists, append the new data
        try {
            const existing_data = JSON.parse(fs.readFileSync(file_path, 'utf8'));
            existing_data.push(data);
            fs.writeFileSync(file_path, JSON.stringify(existing_data, null, 4));
            console.log(`Data (${JSON.stringify(data)}) was backed up successfully.`);
        } catch (err) {
            console.log("Error reading existing file:", err);
        }
    }
}

// Define the data with your specific fields
const data = [
    {
        "table": "clients"
    },
    {
        "client": "SAS de CV",
        "broker": "DEF",
        "cloud_services": false,
        "payment": true,
        "payment_amount": 1000
    }
];

// URL of the local API endpoint
const url = "http://localhost:7071/api/pushData";

// Backup the data locally
const file_path = path.join("PowerTIC", "Raspberry_backup", "clients.json");

try {
    info_backup(data, file_path);
} catch (error) {
    console.log("Error while backing up data:", error);
}

// Try sending the data to the local pushData endpoint
axios.post(url, data)
    .then((response) => {
        console.log('Success:', response.data);
    })
    .catch((error) => {
        console.error('HTTP Request failed:', error.message);
    });