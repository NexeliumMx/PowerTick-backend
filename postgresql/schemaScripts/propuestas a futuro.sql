-- Optional: Table for additional roles and permissions if needed
CREATE TABLE IF NOT EXISTS Brokers (
  broker_name TEXT PRIMARY KEY,
  clients INT NOT NULL,
  facturation INT NOT NULL,
  contract_date TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    monthly_fee DECIMAL(10, 2) NOT NULL,
    last_payment_date DATE,
    next_due_date DATE NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Paid', 'Pending', 'Overdue')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    external_id VARCHAR(255) UNIQUE NOT NULL,  -- Stores Entra ID user ID for linking
    client_id INT REFERENCES clients(client_id) ON DELETE CASCADE,
    onboarding_completed BOOLEAN DEFAULT FALSE,
    account_verified BOOLEAN DEFAULT FALSE,
    access_level VARCHAR(50) DEFAULT 'basic',  -- Example: "basic", "premium"
    preferences JSONB,  -- Stores user preferences in JSON format
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





SET CONSTRAINTS ALL IMMEDIATE;

-- Insert default values
INSERT INTO demo.brokers (broker_name, clients, facturation, contract_date) 
VALUES ('not_set', 0, 0, NOW());

INSERT INTO demo.clients (broker, client, cloud_services, payment, payment_amount) 
VALUES ('not_set', 'not_set', FALSE, FALSE, 0);