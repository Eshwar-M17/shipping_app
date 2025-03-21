# 📦 Shipping App

A modern, feature-rich shipping application built with Flutter and Node.js that enables users to compare shipping rates from multiple couriers, book shipments, and track orders in real-time.

## 🌟 Key Features

- 🚚 **Multi-Courier Support**: Compare rates across multiple shipping providers
- 📦 **Smart Package Management**: Easy package size and weight calculation
- 📍 **Address Management**: Save and manage multiple pickup/delivery locations
- 💳 **Secure Payments**: Multiple payment options with secure processing
- 🔍 **Real-time Tracking**: Live shipment tracking with status updates
- 📱 **Cross-Platform**: Works seamlessly on iOS, Android, and Web

## 🎥 Demo & Screenshots

### Watch the Demo
<div align="center">
  <a href="https://www.youtube.com/watch?v=your-video-id">
    <img src="https://img.youtube.com/vi/your-video-id/maxresdefault.jpg" alt="Shipping App Demo" style="width:100%; max-width:800px;">
  </a>
  <p><em>👆 Click to watch the full demo video showcasing all features</em></p>
</div>

### 📱 App Screenshots

<table>
  <tr>
    <td>
      <img src="assets/screenshots/home_screen.png" width="200" alt="Home Screen">
      <p align="center"><em>Home Dashboard</em></p>
    </td>
    <td>
      <img src="assets/screenshots/package_detail_screen.png" width="200" alt="Package Details">
      <p align="center"><em>Package Details</em></p>
    </td>
    <td>
      <img src="assets/screenshots/adress_screen.png" width="200" alt="Address Screen">
      <p align="center"><em>Address Management</em></p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="assets/screenshots/shipping_option_screen.png" width="200" alt="Shipping Options">
      <p align="center"><em>Shipping Options</em></p>
    </td>
    <td>
      <img src="assets/screenshots/payment_screen.png" width="200" alt="Payment Screen">
      <p align="center"><em>Secure Payment</em></p>
    </td>
  </tr>
</table>

## 🚀 Technical Features

### Frontend (Flutter)
- 🎨 Material Design 3 with custom theme support
- 📱 Responsive UI that adapts to all screen sizes
- 🔄 Riverpod state management for efficient data flow
- 🌐 RESTful API integration with error handling
- 📍 Google Maps integration for address selection
- 💾 Local storage for user preferences
- 🔒 Secure credential management

### Backend (Node.js)
- 🔄 RESTful API with Express.js
- 🗄️ SQLite database with Prisma ORM
- 🔐 JWT authentication & authorization
- 📊 Rate calculation engine
- 🚚 Courier service integrations
- 📨 Email notifications
- 🔍 Order tracking system

## 📁 Project Structure

```
shipping_app/
├── lib/                     # Flutter app source code
│   ├── main.dart           # Entry point
│   ├── models/             # Data models
│   ├── providers/          # State management
│   ├── screens/            # UI screens
│   ├── services/           # API services
│   ├── theme/             # App theme
│   └── widgets/           # Reusable components
├── backend/                # Node.js backend
│   ├── src/               # Source code
│   ├── prisma/            # Database schema
│   └── tests/             # API tests
└── assets/                # App assets
    └── screenshots/       # App screenshots
```

## ⚙️ Setup Instructions

### Prerequisites
- Flutter SDK (latest stable)
- Node.js (v14 or higher)
- VS Code or Android Studio
- Android Studio/Xcode for emulators
- Git

### 1. Clone & Install

```bash
# Clone the repository
git clone https://github.com/yourusername/shipping_app.git

# Navigate to project
cd shipping_app

# Install Flutter dependencies
flutter pub get

# Setup backend
cd backend
npm install
```

### 2. Configuration

Create `.env` files:

#### Backend (.env)
```env
PORT=5000
JWT_SECRET=your_jwt_secret
DATABASE_URL="file:./dev.db"
SMTP_HOST=your_smtp_host
SMTP_USER=your_smtp_user
SMTP_PASS=your_smtp_pass
```

#### Flutter (.env)
```env
API_URL=http://localhost:5000
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

### 3. Run the App

```bash
# Start backend server
cd backend
npm run dev

# In a new terminal, run Flutter app
cd ..
flutter run
```

## 💻 Development

### Recommended VS Code Extensions
- Flutter
- Dart
- ESLint
- Prettier
- SQLite Viewer
- Thunder Client (API testing)

### Code Style
- Follow Flutter's style guide
- Use meaningful variable names
- Comment complex logic
- Write unit tests for critical features

## 🧪 Testing

```bash
# Run Flutter tests
flutter test

# Run backend tests
cd backend
npm test
```

## 📱 Using the App

1. **Create Account**: Sign up with email or Google
2. **Book Shipment**:
   - Enter package details
   - Add pickup/delivery addresses
   - Choose courier service
   - Make payment
3. **Track Order**: Use tracking number
4. **Manage Profile**: Update details, addresses

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

- 📧 Email: support@shippingapp.com
- 💬 Discord: [Join our community](https://discord.gg/shippingapp)
- 📚 Documentation: [View full docs](https://docs.shippingapp.com)

