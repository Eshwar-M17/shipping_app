const fs = require('fs');
const path = require('path');
const { getDbConnection } = require('../config/db-sqlite');

// SQLite database path
const dbPath = path.join(__dirname, '..', 'database', 'shipping_app.db');

// Setup function
async function setupDatabase() {
  let db;
  try {
    // Create database directory if it doesn't exist
    const dbDir = path.dirname(dbPath);
    if (!fs.existsSync(dbDir)) {
      fs.mkdirSync(dbDir, { recursive: true });
    }
    
    // Remove existing database file if it exists
    if (fs.existsSync(dbPath)) {
      console.log('Removing existing database file...');
      fs.unlinkSync(dbPath);
    }
    
    // Get database connection
    db = await getDbConnection();
    console.log('SQLite database created successfully.');
    
    // Create tables
    console.log('Creating tables...');
    
    // Couriers table
    await db.runAsync(`
      CREATE TABLE couriers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        logo_url TEXT,
        base_price REAL NOT NULL,
        price_per_kg REAL NOT NULL,
        estimated_delivery TEXT,
        rating REAL
      )
    `);
    
    // Shipping zones table
    await db.runAsync(`
      CREATE TABLE shipping_zones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        from_postal_code TEXT NOT NULL,
        to_postal_code TEXT NOT NULL,
        zone_type TEXT NOT NULL
      )
    `);
    
    // Zone multipliers table
    await db.runAsync(`
      CREATE TABLE zone_multipliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        zone_type TEXT NOT NULL,
        courier_id INTEGER NOT NULL,
        price_multiplier REAL NOT NULL,
        FOREIGN KEY (courier_id) REFERENCES couriers(id)
      )
    `);
    
    // Users table
    await db.runAsync(`
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Orders table
    await db.runAsync(`
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        package_details TEXT,
        pickup_address TEXT,
        delivery_address TEXT,
        courier_id INTEGER,
        total_price REAL,
        status TEXT DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (courier_id) REFERENCES couriers(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    `);
    
    console.log('Tables created successfully.');
    
    // Insert sample data
    console.log('Inserting sample data...');
    
    // Insert couriers
    await db.runAsync(`
      INSERT INTO couriers (name, logo_url, base_price, price_per_kg, estimated_delivery, rating) VALUES
      ('Delhivery', 'assets/logos/delhivery.png', 80.00, 20.00, '2-3 Days', 4.5),
      ('DTDC', 'assets/logos/dtdc.png', 75.00, 25.00, '3-4 Days', 4.2),
      ('BlueDart', 'assets/logos/bluedart.png', 100.00, 30.00, '1-2 Days', 4.7),
      ('FedEx', 'assets/logos/fedex.png', 120.00, 35.00, '2-3 Days', 4.8),
      ('India Post', 'assets/logos/indiapost.png', 50.00, 15.00, '4-7 Days', 3.9)
    `);
    
    // Insert shipping zones
    await db.runAsync(`
      INSERT INTO shipping_zones (from_postal_code, to_postal_code, zone_type) VALUES
      ('400001', '400100', 'local'),
      ('400001', '500100', 'regional'),
      ('400001', '600100', 'national'),
      ('500001', '500100', 'local'),
      ('500001', '400100', 'regional'),
      ('500001', '600100', 'national'),
      ('600001', '600100', 'local'),
      ('600001', '400100', 'regional'),
      ('600001', '500100', 'regional')
    `);
    
    // Insert zone multipliers
    await db.runAsync(`
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
      ('national', 5, 2.5)
    `);
    
    // Insert sample users
    await db.runAsync(`
      INSERT INTO users (name, email, phone) VALUES
      ('John Doe', 'john@example.com', '9876543210'),
      ('Jane Smith', 'jane@example.com', '8765432109')
    `);
    
    // Insert sample orders
    await db.runAsync(`
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
       2, 100.00, 'in_transit')
    `);
    
    console.log('Sample data inserted successfully.');
    
  } catch (error) {
    console.error('Error setting up database:', error);
    process.exit(1);
  } finally {
    if (db) {
      await db.closeAsync();
    }
  }
}

// Run setup
setupDatabase().catch(err => {
  console.error('Setup failed:', err);
  process.exit(1);
}); 