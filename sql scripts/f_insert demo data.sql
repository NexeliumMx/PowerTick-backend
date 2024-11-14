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
