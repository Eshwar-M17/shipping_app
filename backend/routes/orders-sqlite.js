const express = require('express');
const router = express.Router();
const { getDbConnection } = require('../config/db-sqlite');

/**
 * @route   POST /api/orders
 * @desc    Create a new order
 * @access  Public
 */
router.post('/', async (req, res) => {
  let db;
  try {
    const { 
      user_id, 
      package_details,
      pickup_address,
      delivery_address,
      courier_id,
      total_price
    } = req.body;
    
    if (!package_details || !pickup_address || !delivery_address || !courier_id || !total_price) {
      return res.status(400).json({ 
        success: false, 
        message: 'Missing required fields' 
      });
    }

    db = await getDbConnection();
    
    const result = await db.run(
      `INSERT INTO orders (
        user_id, package_details, pickup_address, delivery_address, 
        courier_id, total_price, status
      ) VALUES (?, ?, ?, ?, ?, ?, 'pending')`,
      [
        user_id || null, 
        JSON.stringify(package_details),
        JSON.stringify(pickup_address),
        JSON.stringify(delivery_address),
        courier_id,
        total_price
      ]
    );

    res.status(201).json({
      success: true,
      data: {
        id: result.lastID,
        message: 'Order created successfully'
      }
    });
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error creating order'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

/**
 * @route   GET /api/orders
 * @desc    Get all orders for a user
 * @access  Public
 */
router.get('/', async (req, res) => {
  let db;
  try {
    const { user_id } = req.query;
    
    db = await getDbConnection();
    
    let query = `
      SELECT o.*, c.name AS courier_name, c.logo_url AS courier_logo
      FROM orders o
      JOIN couriers c ON o.courier_id = c.id
    `;
    
    const params = [];
    
    if (user_id) {
      query += ' WHERE o.user_id = ?';
      params.push(user_id);
    }
    
    query += ' ORDER BY o.created_at DESC';
    
    const rows = await db.all(query, params);
    
    // Parse JSON fields
    const orders = rows.map(order => ({
      ...order,
      package_details: JSON.parse(order.package_details),
      pickup_address: JSON.parse(order.pickup_address),
      delivery_address: JSON.parse(order.delivery_address)
    }));
    
    res.json({
      success: true,
      data: orders
    });
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error fetching orders'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

/**
 * @route   GET /api/orders/:id
 * @desc    Get order by ID
 * @access  Public
 */
router.get('/:id', async (req, res) => {
  let db;
  try {
    db = await getDbConnection();
    
    const row = await db.get(
      `SELECT o.*, c.name AS courier_name, c.logo_url AS courier_logo
       FROM orders o
       JOIN couriers c ON o.courier_id = c.id
       WHERE o.id = ?`,
      [req.params.id]
    );
    
    if (!row) {
      return res.status(404).json({ 
        success: false, 
        message: 'Order not found' 
      });
    }
    
    // Parse JSON fields
    const order = {
      ...row,
      package_details: JSON.parse(row.package_details),
      pickup_address: JSON.parse(row.pickup_address),
      delivery_address: JSON.parse(row.delivery_address)
    };
    
    res.json({
      success: true,
      data: order
    });
  } catch (error) {
    console.error('Error fetching order:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error fetching order'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

/**
 * @route   PUT /api/orders/:id/status
 * @desc    Update order status
 * @access  Public
 */
router.put('/:id/status', async (req, res) => {
  let db;
  try {
    const { status } = req.body;
    
    if (!status) {
      return res.status(400).json({ 
        success: false, 
        message: 'Status is required' 
      });
    }
    
    db = await getDbConnection();
    
    const result = await db.run(
      'UPDATE orders SET status = ? WHERE id = ?',
      [status, req.params.id]
    );
    
    if (result.changes === 0) {
      return res.status(404).json({ 
        success: false, 
        message: 'Order not found' 
      });
    }
    
    res.json({
      success: true,
      message: 'Order status updated successfully'
    });
  } catch (error) {
    console.error('Error updating order status:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error updating order status'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

module.exports = router; 