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

#### Calculate Shipping Rates
- **Endpoint**: `POST /api/shipping/rates`
- **Description**: Calculate shipping rates from multiple courier services
- **Request Body**:
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
- **Response**:
  ```json
  {
    "success": true,
    "rates": [
      {
        "courier_id": 1,
        "courier_name": "Express Courier",
        "base_price": 150.00,
        "distance_charge": 25.00,
        "weight_charge": 37.50,
        "total_price": 212.50,
        "estimated_days": "2-3",
        "service_type": "Express"
      },
      {
        "courier_id": 2,
        "courier_name": "Standard Post",
        "base_price": 100.00,
        "distance_charge": 20.00,
        "weight_charge": 25.00,
        "total_price": 145.00,
        "estimated_days": "4-5",
        "service_type": "Standard"
      }
    ]
  }
  ```
- **Error Response**:
  ```json
  {
    "success": false,
    "error": {
      "code": "INVALID_WEIGHT",
      "message": "Package weight must be between 0.1 and 50 kg"
    }
  }
  ```

## Integration with Flutter App

The Flutter app connects to this backend through the `ShippingApiService` class. The service automatically handles:
- API URL selection based on platform (web, Android, iOS)
- Request/response formatting
- Error handling
- Timeout management
- Fallback to dummy data when needed 