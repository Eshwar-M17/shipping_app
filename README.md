# Shiplee - Shipping App

A modern, feature-rich shipping app built with Flutter that allows users to compare shipping rates from multiple couriers, book shipments, and track orders in real-time.

## Features

- **Courier Comparison**: Compare shipping rates from multiple courier services
- **Shipment Booking**: Easy package details entry and address selection


## Screenshots

<table>
  <tr>
    <td><img src="screenshots/home_screen.png" width="200"></td>
    <td><img src="screenshots/package_detail_screen.png" width="200"></td>
    <td><img src="screenshots/adress_screen.png" width="200"></td>
  </tr>
  <tr>
    <td><img src="screenshots/shipping_option_screen.png" width="200"></td>
    <td><img src="screenshots/payment_screen.png" width="200"></td>
  </tr>
</table>

## Tech Stack

- **Frontend**: Flutter, Dart
- **State Management**: Riverpod
- **Backend**: Node.js (see [backend folder](./backend))
- **Database**: MySQL/SQLite

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
├── providers/                # Riverpod state providers
├── screens/                  # App screens
├── services/                 # API and other services
├── theme/                    # Theme configuration
└── widgets/                  # Reusable UI components
    ├── home/                 # Home screen widgets
    └── ...                   # Other widgets
```

## Getting Started

### Prerequisites

- Flutter (latest stable version)
- Dart SDK
- Android Studio / Xcode for emulators

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/Eshwar-M17/shipping_app
   ```

2. Navigate to the project directory:
   ```
   cd shipping_app
   ```

3. Set up Android SDK configuration:
   - Copy `android/local.properties.template` to `android/local.properties`
   - Update the paths in `local.properties` to match your system:
     ```properties
     # Windows example:
     sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk
     flutter.sdk=C:\\dev\\flutter

     # macOS/Linux example:
     # sdk.dir=/Users/YourUsername/Library/Android/sdk
     # flutter.sdk=/Users/YourUsername/flutter
     ```

4. Install dependencies:
   ```
   flutter pub get
   ```

5. Run the app:
   ```
   flutter run
   ```

### Backend Setup

For setting up the backend server, please refer to the [backend README](./backend/README.md).

## State Management

This app uses Riverpod for state management. The main providers include:

- Order providers for managing shipment orders
- Courier providers for fetching and comparing courier services
- Address providers for managing pickup and delivery addresses
- Authentication providers for user management

## UI Components

The app follows Material Design guidelines with custom components for a modern look and feel. Key components include:

- Custom service cards
- Step-by-step shipment booking process
- Interactive tracking view
- Courier comparison cards

