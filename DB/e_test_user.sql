-- Create the user
CREATE ROLE test_user WITH LOGIN PASSWORD '12345678';

-- Grant connection privileges on the database
GRANT CONNECT ON DATABASE powertick TO test_user;

-- Grant read and write privileges on all tables in the schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO test_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA demo TO test_user;

-- Optionally, grant usage on the schema to access objects
GRANT USAGE ON SCHEMA public TO test_user;
GRANT USAGE ON SCHEMA demo TO test_user;