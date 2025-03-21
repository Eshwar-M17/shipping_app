const express = require('express');
const router = express.Router();
const { getDbConnection } = require('../config/db-sqlite');

/**
 * @route   POST /api/shipping/rates
 * @desc    Calculate shipping rates based on package details and postal codes
 * @access  Public
 */
router.post('/rates', async (req, res) => {
  let db;
  try {
    const { weight, dimensions, pickup_postal_code, delivery_postal_code } = req.body;
    
    if (!weight || !pickup_postal_code || !delivery_postal_code) {
      return res.status(400).json({ 
        success: false, 
        message: 'Missing required fields' 
      });
    }

    // Get database connection
    db = await getDbConnection();

    // Find the zone type for the given postal codes
    const zoneRow = await db.getAsync(
      `SELECT zone_type FROM shipping_zones 
       WHERE from_postal_code = ? AND to_postal_code = ?`, 
      [pickup_postal_code, delivery_postal_code]
    );

    let zoneType;
    if (!zoneRow) {
      // Default to 'national' if no specific zone found
      zoneType = 'national';
    } else {
      zoneType = zoneRow.zone_type;
    }

    // Get couriers with pricing based on zone
    const rows = await db.allAsync(
      `SELECT c.id, c.name, c.logo_url, c.base_price, c.price_per_kg, 
              c.estimated_delivery, c.rating, zm.price_multiplier
       FROM couriers c
       JOIN zone_multipliers zm ON c.id = zm.courier_id
       WHERE zm.zone_type = ?`,
      [zoneType]
    );

    // Calculate final rates for each courier
    const rates = rows.map(courier => ({
      id: courier.id.toString(),
      name: courier.name,
      logo: courier.logo_url,
      basePrice: courier.base_price,
      pricePerKg: courier.price_per_kg,
      estimatedDelivery: courier.estimated_delivery,
      rating: courier.rating,
      total: courier.base_price + (courier.price_per_kg * weight * courier.price_multiplier)
    }));

    await db.closeAsync();
    
    return res.json({
      success: true,
      data: {
        rates,
        zoneType
      }
    });

  } catch (error) {
    console.error('Error calculating shipping rates:', error);
    if (db) {
      await db.closeAsync();
    }
    return res.status(500).json({
      success: false,
      message: 'Error calculating shipping rates',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/shipping/couriers
 * @desc    Get all available courier services
 * @access  Public
 */
router.get('/couriers', async (req, res) => {
  let db;
  try {
    db = await getDbConnection();
    const rows = await db.all('SELECT * FROM couriers');
    
    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('Error fetching couriers:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error fetching couriers'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

/**
 * @route   GET /api/shipping/courier/:id
 * @desc    Get details of a specific courier
 * @access  Public
 */
router.get('/courier/:id', async (req, res) => {
  let db;
  try {
    db = await getDbConnection();
    const row = await db.get(
      'SELECT * FROM couriers WHERE id = ?', 
      [req.params.id]
    );
    
    if (!row) {
      return res.status(404).json({ 
        success: false, 
        message: 'Courier not found' 
      });
    }
    
    res.json({
      success: true,
      data: row
    });
  } catch (error) {
    console.error('Error fetching courier:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Server error fetching courier'
    });
  } finally {
    if (db) {
      await db.close();
    }
  }
});

module.exports = router; 