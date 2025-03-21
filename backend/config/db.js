const mysql = require('mysql2/promise');
require('dotenv').config();

// Database Configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'shipping_app_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

// Create a pool of connections
const pool = mysql.createPool(dbConfig);

// Test database connection
const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log('Database connected successfully');
    connection.release();
    return true;
  } catch (error) {
    console.error('Database connection failed:', error);
    return false;
  }
};

module.exports = { pool, testConnection }; 