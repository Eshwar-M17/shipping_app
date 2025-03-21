const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Database file path
const dbPath = path.join(__dirname, '..', 'database', 'shipping_app.db');

// Create database connection with Promise wrapper
const getDbConnection = () => {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('SQLite connection error:', err);
        reject(err);
        return;
      }
      console.log('Connected to SQLite database');
      
      // Add Promise wrappers for common database operations
      db.getAsync = (sql, params) => {
        return new Promise((resolve, reject) => {
          db.get(sql, params, (err, row) => {
            if (err) reject(err);
            else resolve(row);
          });
        });
      };
      
      db.allAsync = (sql, params) => {
        return new Promise((resolve, reject) => {
          db.all(sql, params, (err, rows) => {
            if (err) reject(err);
            else resolve(rows);
          });
        });
      };
      
      db.closeAsync = () => {
        return new Promise((resolve, reject) => {
          db.close((err) => {
            if (err) reject(err);
            else resolve();
          });
        });
      };
      
      resolve(db);
    });
  });
};

// Test database connection
const testConnection = async () => {
  try {
    const db = await getDbConnection();
    await db.getAsync('SELECT 1');
    console.log('SQLite database connected successfully');
    await db.closeAsync();
    return true;
  } catch (err) {
    console.error('Database connection failed:', err);
    throw err;
  }
};

module.exports = { getDbConnection, testConnection }; 