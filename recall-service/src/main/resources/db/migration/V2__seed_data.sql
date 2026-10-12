-- V2__seed_data.sql
-- Demo data: a small food supply chain in Sri Lanka.
-- Rows reference each other by natural keys (names, SKUs, codes), never hard-coded IDs.
-- Users are seeded later (V3), once password hashing exists.

-- ===================== Suppliers =====================
INSERT INTO suppliers (name, contact_email, country) VALUES
                                                         ('Green Valley Farms',   'orders@greenvalley.example',   'Sri Lanka'),
                                                         ('Ceylon Dairy Co.',     'supply@ceylondairy.example',   'Sri Lanka'),
                                                         ('Ocean Fresh Seafoods', 'sales@oceanfresh.example',     'Maldives'),
                                                         ('Spice Route Exports',  'contact@spiceroute.example',   'India');

-- ===================== Products =====================
INSERT INTO products (supplier_id, name, category, sku)
SELECT s.id, v.name, v.category, v.sku
FROM (VALUES
          ('Green Valley Farms',   'Iceberg Lettuce',          'Vegetables', 'VEG-LET-001'),
          ('Green Valley Farms',   'Cherry Tomatoes 250g',     'Vegetables', 'VEG-TOM-002'),
          ('Green Valley Farms',   'Baby Spinach 200g',        'Vegetables', 'VEG-SPN-003'),
          ('Ceylon Dairy Co.',     'Fresh Milk 1L',            'Dairy',      'DAI-MLK-001'),
          ('Ceylon Dairy Co.',     'Natural Yogurt 400g',      'Dairy',      'DAI-YOG-002'),
          ('Ocean Fresh Seafoods', 'Frozen Tuna Steaks 500g',  'Seafood',    'SEA-TUN-001'),
          ('Ocean Fresh Seafoods', 'Frozen Prawns 500g',       'Seafood',    'SEA-PRW-002'),
          ('Spice Route Exports',  'Chilli Powder 250g',       'Spices',     'SPI-CHI-001')
     ) AS v (supplier_name, name, category, sku)
         JOIN suppliers s ON s.name = v.supplier_name;

-- ===================== Batches =====================
INSERT INTO batches (product_id, batch_number, production_date, expiry_date)
SELECT p.id, v.batch_number, v.production_date::date, v.expiry_date::date
FROM (VALUES
          ('VEG-LET-001', 'LET-2026-0412', '2026-10-08', '2026-10-18'),
          ('VEG-LET-001', 'LET-2026-0415', '2026-10-10', '2026-10-20'),
          ('VEG-TOM-002', 'TOM-2026-0388', '2026-10-07', '2026-10-21'),
          ('VEG-SPN-003', 'SPN-2026-0201', '2026-10-09', '2026-10-16'),
          ('DAI-MLK-001', 'MLK-2026-1093', '2026-10-05', '2026-10-19'),
          ('DAI-YOG-002', 'YOG-2026-0517', '2026-10-01', '2026-11-01'),
          ('DAI-YOG-002', 'YOG-2026-0530', '2026-10-11', '2026-11-11'),
          ('SEA-TUN-001', 'TUN-2026-0044', '2026-09-15', '2027-03-15'),
          ('SEA-PRW-002', 'PRW-2026-0102', '2026-09-20', '2027-03-20'),
          ('SPI-CHI-001', 'CHI-2026-0730', '2026-07-30', '2027-07-30')
     ) AS v (sku, batch_number, production_date, expiry_date)
         JOIN products p ON p.sku = v.sku;

-- ===================== Stores =====================
INSERT INTO stores (code, name, city, manager_email) VALUES
                                                         ('CMB-01', 'TraceFresh Market Colombo Fort',     'Colombo',   'manager.cmb01@tracefresh.example'),
                                                         ('CMB-02', 'TraceFresh Market Bambalapitiya',    'Colombo',   'manager.cmb02@tracefresh.example'),
                                                         ('KDY-01', 'TraceFresh Market Kandy City',       'Kandy',     'manager.kdy01@tracefresh.example'),
                                                         ('GAL-01', 'TraceFresh Market Galle',            'Galle',     'manager.gal01@tracefresh.example'),
                                                         ('NEG-01', 'TraceFresh Market Negombo',          'Negombo',   'manager.neg01@tracefresh.example'),
                                                         ('RTN-01', 'TraceFresh Market Ratnapura',        'Ratnapura', 'manager.rtn01@tracefresh.example');

-- ===================== Shipments =====================
-- Note: LET-2026-0412 reaches CMB-01 twice (two deliveries).
--       YOG-2026-0530 has no shipments at all (recall would affect zero stores).
INSERT INTO shipments (batch_id, store_id, quantity, shipped_at)
SELECT b.id, st.id, v.quantity, v.shipped_at::timestamptz
FROM (VALUES
          ('LET-2026-0412', 'CMB-01', 120, '2026-10-09 07:30:00+05:30'),
          ('LET-2026-0412', 'CMB-02',  80, '2026-10-09 08:15:00+05:30'),
          ('LET-2026-0412', 'KDY-01',  60, '2026-10-09 11:00:00+05:30'),
          ('LET-2026-0412', 'GAL-01',  50, '2026-10-09 12:30:00+05:30'),
          ('LET-2026-0412', 'CMB-01',  40, '2026-10-10 07:30:00+05:30'),
          ('LET-2026-0415', 'NEG-01',  70, '2026-10-11 08:00:00+05:30'),
          ('LET-2026-0415', 'RTN-01',  45, '2026-10-11 10:30:00+05:30'),
          ('TOM-2026-0388', 'CMB-01',  90, '2026-10-08 07:45:00+05:30'),
          ('TOM-2026-0388', 'KDY-01',  60, '2026-10-08 11:15:00+05:30'),
          ('TOM-2026-0388', 'RTN-01',  30, '2026-10-09 09:00:00+05:30'),
          ('SPN-2026-0201', 'CMB-02',  40, '2026-10-10 08:30:00+05:30'),
          ('SPN-2026-0201', 'GAL-01',  25, '2026-10-10 12:00:00+05:30'),
          ('MLK-2026-1093', 'CMB-01', 200, '2026-10-06 06:00:00+05:30'),
          ('MLK-2026-1093', 'CMB-02', 150, '2026-10-06 06:30:00+05:30'),
          ('MLK-2026-1093', 'KDY-01', 120, '2026-10-06 09:30:00+05:30'),
          ('MLK-2026-1093', 'GAL-01', 100, '2026-10-06 10:00:00+05:30'),
          ('MLK-2026-1093', 'NEG-01',  90, '2026-10-06 07:30:00+05:30'),
          ('MLK-2026-1093', 'RTN-01',  80, '2026-10-06 11:00:00+05:30'),
          ('YOG-2026-0517', 'CMB-01',  60, '2026-10-03 07:00:00+05:30'),
          ('YOG-2026-0517', 'KDY-01',  40, '2026-10-03 10:30:00+05:30'),
          ('TUN-2026-0044', 'CMB-01',  30, '2026-09-20 08:00:00+05:30'),
          ('TUN-2026-0044', 'NEG-01',  25, '2026-09-20 09:30:00+05:30'),
          ('TUN-2026-0044', 'GAL-01',  20, '2026-09-21 11:00:00+05:30'),
          ('PRW-2026-0102', 'CMB-02',  35, '2026-09-25 08:00:00+05:30'),
          ('PRW-2026-0102', 'NEG-01',  40, '2026-09-25 09:00:00+05:30'),
          ('CHI-2026-0730', 'RTN-01',  50, '2026-08-05 10:00:00+05:30'),
          ('CHI-2026-0730', 'KDY-01',  40, '2026-08-05 13:00:00+05:30')
     ) AS v (batch_number, store_code, quantity, shipped_at)
         JOIN batches b ON b.batch_number = v.batch_number
         JOIN stores  st ON st.code       = v.store_code;