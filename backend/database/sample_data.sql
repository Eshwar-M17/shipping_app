-- Sample data for shipping_app_db
USE shipping_app_db;

-- Couriers
INSERT INTO couriers (name, logo_url, base_price, price_per_kg, estimated_delivery, rating) VALUES
('Delhivery', 'assets/logos/delhivery.png', 80.00, 20.00, '2-3 Days', 4.5),
('DTDC', 'assets/logos/dtdc.png', 75.00, 25.00, '3-4 Days', 4.2),
('BlueDart', 'assets/logos/bluedart.png', 100.00, 30.00, '1-2 Days', 4.7),
('FedEx', 'assets/logos/fedex.png', 120.00, 35.00, '2-3 Days', 4.8),
('India Post', 'assets/logos/indiapost.png', 50.00, 15.00, '4-7 Days', 3.9);

-- Shipping zones
INSERT INTO shipping_zones (from_postal_code, to_postal_code, zone_type) VALUES
('400001', '400100', 'local'),
('400001', '500100', 'regional'),
('400001', '600100', 'national'),
('500001', '500100', 'local'),
('500001', '400100', 'regional'),
('500001', '600100', 'national'),
('600001', '600100', 'local'),
('600001', '400100', 'regional'),
('600001', '500100', 'regional');

-- Zone multipliers
INSERT INTO zone_multipliers (zone_type, courier_id, price_multiplier) VALUES
-- Delhivery
('local', 1, 1.0),
('regional', 1, 1.5),
('national', 1, 2.0),
-- DTDC
('local', 2, 1.0),
('regional', 2, 1.6),
('national', 2, 2.2),
-- BlueDart
('local', 3, 1.0),
('regional', 3, 1.4),
('national', 3, 1.8),
-- FedEx
('local', 4, 1.0),
('regional', 4, 1.3),
('national', 4, 1.7),
-- India Post
('local', 5, 1.0),
('regional', 5, 1.8),
('national', 5, 2.5);

-- Sample users
INSERT INTO users (name, email, phone) VALUES
('John Doe', 'john@example.com', '9876543210'),
('Jane Smith', 'jane@example.com', '8765432109');

-- Sample orders
INSERT INTO orders (user_id, package_details, pickup_address, delivery_address, courier_id, total_price, status) VALUES
(1, 
 '{"weight": 2.5, "length": 30, "width": 20, "height": 15, "category": "Electronics"}',
 '{"name": "John Doe", "street": "123 Main St", "city": "Mumbai", "state": "Maharashtra", "postal_code": "400001", "phone": "9876543210"}',
 '{"name": "Alice Brown", "street": "456 Park Ave", "city": "Delhi", "state": "Delhi", "postal_code": "110001", "phone": "7654321098"}',
 3, 175.00, 'delivered'),
(2, 
 '{"weight": 1.0, "length": 20, "width": 15, "height": 10, "category": "Clothing"}',
 '{"name": "Jane Smith", "street": "789 Oak Rd", "city": "Bangalore", "state": "Karnataka", "postal_code": "560001", "phone": "8765432109"}',
 '{"name": "Bob White", "street": "321 Pine St", "city": "Chennai", "state": "Tamil Nadu", "postal_code": "600001", "phone": "6543210987"}',
 2, 100.00, 'in_transit'); 