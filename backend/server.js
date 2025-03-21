require('dotenv').config();
const express = require('express');
const cors = require('cors');
const shippingRoutes = require('./routes/shipping-sqlite');
const ordersRoutes = require('./routes/orders-sqlite');

// Initialize express app
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/shipping', shippingRoutes);
app.use('/api/orders', ordersRoutes);

// Home route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Shipping App API',
    endpoints: {
      shipping: '/api/shipping/rates',
      couriers: '/api/shipping/couriers',
      orders: '/api/orders'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Something went wrong!'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 