# Shipping App Backend

This is the backend server for the Shiplee shipping app. It provides REST API endpoints for shipping rate calculations and order management.

## Prerequisites

- Node.js (v14 or higher)
- SQLite (included in the project)

## Setup Instructions

1. Install dependencies:
   ```
   npm install
   ```

2. Set up environment variables:
   Create a `.env` file in the root directory:
   ```
   PORT=5000
   ```

3. Set up the SQLite database:
   ```
   npm run setup-sqlite
   ```

4. Start the server:
   ```
   npm run dev
   ```

## API Endpoints

### Shipping Rates

- `POST /api/shipping/rates` - Calculate shipping rates
  ```json
  {
    "weight": 2.5,
    "dimensions": {
      "length": 30,
      "width": 20,
      "height": 15
    },
    "pickup_postal_code": "400001",
    "delivery_postal_code": "500100"
  }
  ```

### Orders

- `POST /api/orders` - Create a new order
  ```json
  {
    "package_details": {
      "weight": 2.5,
      "length": 30,
      "width": 20,
      "height": 15,
      "category": "Electronics"
    },
    "pickup_address": {
      "name": "John Doe",
      "street": "123 Main St",
      "city": "Mumbai",
      "state": "Maharashtra",
      "postal_code": "400001",
      "phone": "9876543210"
    },
    "delivery_address": {
      "name": "Alice Brown",
      "street": "456 Park Ave",
      "city": "Delhi",
      "state": "Delhi",
      "postal_code": "110001",
      "phone": "7654321098"
    },
    "courier_id": 3,
    "total_price": 175.00
  }
  ```

## Integration with Flutter App

The Flutter app connects to this backend through the `ShippingApiService` class. The service automatically handles:
- API URL selection based on platform (web, Android, iOS)
- Request/response formatting
- Error handling
- Timeout management
- Fallback to dummy data when needed 