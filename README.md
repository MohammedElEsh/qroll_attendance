
# QRoll Attendance

QRoll Attendance is a modern Flutter app for educational institutions to manage student attendance efficiently using QR code scanning, secure authentication, and real-time messaging.


## Features

- **QR Code Attendance:** Mark attendance instantly by scanning QR codes
- **Secure Authentication:** JWT-based login, password management, and session handling
- **Attendance Analytics:** View attendance history, statistics, and dashboard overview
- **Messaging System:** Inbox for messages from staff, teachers, and TAs
- **Profile Management:** View and update personal info, including profile picture

## Tech Stack

- **Flutter** (Material 3) & **Dart**
- **Riverpod** for state management
- **REST API** with **Dio** for backend integration
- **JWT** for authentication
- **SharedPreferences**  for local/encrypted storage
- **QR Code Scanner**, **Image Picker**, and more

## Project Structure

```
lib/
├── main.dart            # App entry point & theme
├── models/              # Data models (user, course, etc.)
├── screens/             # UI screens (auth, dashboard, attendance, etc.)
├── services/            # API & business logic
├── utils/               # Helpers & utilities
├── widgets/             # Reusable UI components
```

## Getting Started

1. Install dependencies: `flutter pub get`
2. Run the app: `flutter run`
3. Configure backend endpoints in the services as needed

## License

MIT License © 2025 Mohamed M. El Esh

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.0 or higher (latest stable recommended)
- **Development Environment**:
  - Android Studio with Flutter plugin, or
  - VS Code with Flutter and Dart extensions
- **Testing Device**:
  - Android emulator (API level 21+) or physical Android device
  - iOS simulator or physical iOS device (for iOS development)
- **Additional Requirements**:
  - Camera permissions for QR code scanning
  - Internet connection for API communication

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MohammedElEsh/qroll_attendance.git
   cd qroll_attendance
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints:**
   - Update base URL in service files if needed
   - Default API base URL: `https://azure-hawk-973666.hostingersite.com/api/`

4. **Run the application:**
   ```bash
   # For development
   flutter run

   # For release build
   flutter build apk --release
   ```

### 🔧 Configuration

The app uses the following default configurations:
- **API Base URL**: `https://azure-hawk-973666.hostingersite.com/api/`
- **Student Role ID**: `4` (for login authentication)
- **Theme**: Material Design 3 with custom color scheme (`#7EF4E1`)
- **Font Family**: Inter (included in assets)

## 📱 Key Features Overview

### Authentication Flow
1. **Splash Screen**: App initialization and branding
2. **Login**: Secure authentication with national ID and password
3. **Dashboard**: Main hub with attendance overview and quick actions

### Attendance Management
1. **QR Scanning**: Camera-based attendance marking
2. **Attendance Reports**: Historical data with statistics
3. **Real-time Updates**: Instant attendance status updates

### Communication System
1. **Inbox**: Receive messages from staff and administrators
2. **Message Details**: Full message content with sender information
3. **Role Recognition**: Visual indicators for different sender types

### Profile Management
1. **View Profile**: Display personal and academic information
2. **Edit Profile**: Update personal details and preferences
3. **Password Change**: Secure password update functionality

## 🔒 Security Features

- **JWT Authentication**: Secure token-based user authentication
- **Encrypted Storage**: Sensitive data stored securely on device
- **Input Validation**: Comprehensive form validation and sanitization
- **Session Management**: Automatic token refresh and secure logout
- **API Security**: HTTPS communication with proper error handling

## 🎨 Design System

- **Material Design 3**: Modern, accessible UI components
- **Custom Theme**: Consistent color scheme with primary color `#7EF4E1`
- **Inter Font Family**: Professional typography throughout the app
- **Responsive Design**: Optimized for various screen sizes
- **Dark Navy Sidebar**: Elegant navigation with `#161B39` background

## 📊 Current Status

### ✅ Implemented Features
- Student authentication and session management
- QR code-based attendance marking
- Comprehensive attendance reporting
- Read-only inbox system for receiving messages
- Profile viewing and editing capabilities
- Password change functionality
- Modern, responsive UI design

### � Future Enhancements
- Push notifications for new messages
- Offline attendance marking capability
- Enhanced analytics and reporting
- Multi-language support
- Biometric authentication
- Course-specific attendance tracking

## 🤝 Contributing

We welcome contributions to improve QRoll Attendance! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Follow the existing code style and patterns
4. **Test thoroughly**: Ensure all features work as expected
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**: Describe your changes and their benefits

### Development Guidelines
- Follow Flutter best practices and conventions
- Maintain consistent code formatting
- Add comments for complex logic
- Update documentation for new features
- Test on both Android and iOS platforms

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Contributors

- **Mohammed ElEsh** - [@MohammedElEsh](https://github.com/MohammedElEsh) - Lead Developer
- **fathy** - [@fathygh](https://github.com/fathygh) - Lead Developer

## 📞 Support

For support, questions, or feature requests:
- Create an issue on GitHub
- Contact the development team
- Check the documentation for common solutions

---

**QRoll Attendance** - Making attendance management simple, secure, and efficient for educational institutions.

