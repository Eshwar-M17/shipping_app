-- Database Schema for Shipping App
CREATE DATABASE IF NOT EXISTS shipping_app_db;
USE shipping_app_db;

-- Couriers table
CREATE TABLE IF NOT EXISTS couriers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  logo_url VARCHAR(255),
  base_price DECIMAL(10,2) NOT NULL,
  price_per_kg DECIMAL(10,2) NOT NULL,
  estimated_delivery VARCHAR(50),
  rating DECIMAL(3,1)
);

-- Shipping zones table
CREATE TABLE IF NOT EXISTS shipping_zones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  from_postal_code VARCHAR(20) NOT NULL,
  to_postal_code VARCHAR(20) NOT NULL,
  zone_type VARCHAR(50) NOT NULL
);

-- Zone multipliers table
CREATE TABLE IF NOT EXISTS zone_multipliers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  zone_type VARCHAR(50) NOT NULL,
  courier_id INT NOT NULL,
  price_multiplier DECIMAL(5,2) NOT NULL,
  FOREIGN KEY (courier_id) REFERENCES couriers(id)
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  package_details JSON,
  pickup_address JSON,
  delivery_address JSON,
  courier_id INT,
  total_price DECIMAL(10,2),
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (courier_id) REFERENCES couriers(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
); 