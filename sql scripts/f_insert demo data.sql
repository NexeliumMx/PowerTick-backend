INSERT INTO demo.clients (
  client_id,
  client_name,
  register_date,
  subscription_status,
  cloud_services_provider,
  payment,
  payment_amount
) VALUES (
  'not_set',                -- client_id
  'not_set',                -- client_name
  NOW(),                    -- register_date
  'inactive',               -- subscription_status
  FALSE,                    -- cloud_services_provider
  FALSE,                    -- payment
  0                         -- payment_amount
);



INSERT INTO demo.powermeters (
  client_id,
  serial_number,
  manufacturer,
  series,
  model,
  firmware_v,
  branch,
  "location",
  coordinates,
  load_center,
  register_date,
  facturation_interval_months,
  facturation_day
) VALUES (
  'not_set',                  -- client_id
  'DEMO0000001',              -- serial_number
  'not_set',                  -- manufacturer
  'not_set',                  -- series
  'not_set',                  -- model
  'not_set',                  -- firmware_v
  'not_set',                  -- branch
  'not_set',                  -- location
  'not_set',                  -- coordinates
  'not_set',                  -- load_center
  NOW(),                      -- register_date
  0,                          -- facturation_interval_months
  27                          -- facturation_day (example day)
);





-- Add clients
INSERT INTO demo.clients (client_id, client_name, register_date, subscription_status, cloud_services_provider, payment, payment_amount)
VALUES
    ('TSA123456789', 'Televisa San Ángel S.A. de C.V.', CURRENT_TIMESTAMP, 'active', TRUE, FALSE, 0),
    ('TCA123456789', 'Televisa Club América S.A. de C.V.', CURRENT_TIMESTAMP, 'active', TRUE, FALSE, 0),
    ('TEA123456789', 'Televisa Estadio Azteca S.A. de C.V.', CURRENT_TIMESTAMP, 'active', TRUE, FALSE, 0),
    ('TRA123456789', 'Televisa Radiópolis S.A. de C.V.', CURRENT_TIMESTAMP, 'active', TRUE, FALSE, 0),
    ('TSF123456789', 'Televisa Santa Fe S.A. de C.V.', CURRENT_TIMESTAMP, 'active', TRUE, FALSE, 0);

-- Add powermeters
UPDATE demo.powermeters SET client_id = 'TSA123456789' WHERE serial_number = 'DEMO0000001';
UPDATE demo.powermeters SET client_id = 'TCA123456789' WHERE serial_number = 'DEMO0000002';
UPDATE demo.powermeters SET client_id = 'TCA123456789' WHERE serial_number = 'DEMO0000003';
UPDATE demo.powermeters SET client_id = 'TEA123456789' WHERE serial_number = 'DEMO0000004';
UPDATE demo.powermeters SET client_id = 'TRA123456789' WHERE serial_number = 'DEMO0000005';
UPDATE demo.powermeters SET client_id = 'TSF123456789' WHERE serial_number = 'DEMO0000006';
UPDATE demo.powermeters SET client_id = 'TSF123456789' WHERE serial_number = 'DEMO0000007';
UPDATE demo.powermeters SET client_id = 'TSF123456789' WHERE serial_number = 'DEMO0000008';
UPDATE demo.powermeters SET client_id = 'TSF123456789' WHERE serial_number = 'DEMO0000009';