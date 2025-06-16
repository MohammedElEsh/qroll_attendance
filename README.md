# QRoll Attendance

A comprehensive Flutter mobile application for managing student attendance using QR code scanning, with integrated messaging and profile management features.

## ✨ Features

### 🔐 Authentication & Security
- **Secure Student Login**: JWT token-based authentication system
- **Password Management**: Change password securely with validation
- **Session Management**: Automatic token refresh and secure logout

### 📱 Core Functionality
- **QR Code Scanning**: Mark attendance by scanning QR codes with camera integration
- **Attendance Reports**: View detailed attendance history with statistics and analytics
- **Dashboard**: Modern, intuitive dashboard with attendance overview and quick actions

### 💬 Communication
- **Inbox System**: Read-only message viewer for receiving communications from:
  - Teachers and Instructors
  - Administrative Staff
  - Teaching Assistants
- **Message Details**: View full message content with sender information and timestamps
- **Role-based Messaging**: Visual indicators for different sender roles

### 👤 Profile Management
- **Profile Viewing**: Display personal information and student details
- **Profile Updates**: Edit and update personal information
- **User Avatar**: Profile picture support with fallback initials

## 🛠️ Technology Stack

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for Flutter development
- **Material Design 3**: Modern UI components and design system

### Backend Integration
- **REST API**: Integration with custom backend services
- **Dio**: HTTP client for API communication with interceptors and error handling
- **JWT Authentication**: Secure token-based authentication system

### State Management & Storage
- **Riverpod**: Reactive state management solution
- **SharedPreferences**: Local storage for user preferences and tokens
- **Flutter Secure Storage**: Encrypted storage for sensitive data

### Additional Libraries
- **QR Code Scanner**: Camera-based QR code scanning functionality
- **Image Picker**: Profile picture selection and upload
- **Pull to Refresh**: Enhanced user experience with refresh indicators

## 📁 Project Structure

The application follows a clean, modular architecture with separation of concerns:

```
lib/
├── main.dart                    # App entry point with theme configuration
├── models/                      # Data models and entities
│   ├── user_profile.dart        # User profile data model
│   ├── student.dart             # Student information model
│   └── inbox_message.dart       # Message data model with JSON serialization
├── services/                    # API services and business logic
│   ├── auth_service.dart        # Authentication and session management
│   ├── profile_service.dart     # Profile data management
│   ├── student_service.dart     # Student-related operations
│   └── inbox_service.dart       # Message retrieval and management
├── screens/                     # Application screens and pages
│   ├── splash_screen.dart       # App startup and initialization
│   ├── login_screen.dart        # User authentication interface
│   ├── dashboard_screen.dart    # Main dashboard with overview
│   ├── profile_screen.dart      # User profile display and editing
│   ├── change_password_screen.dart # Password change functionality
│   ├── inbox_screen.dart        # Message inbox with list view
│   └── message_detail_screen.dart # Individual message viewer
├── widgets/                     # Reusable UI components
│   ├── custom_button.dart       # Styled button component
│   ├── custom_textfield.dart    # Form input field component
│   ├── app_drawer.dart          # Navigation sidebar
│   └── message_card.dart        # Message list item component
├── features/                    # Feature-specific modules
│   └── qr_scanner/              # QR code scanning functionality
│       ├── qr_scanner_screen.dart
│       ├── qr_result_screen.dart
│       └── scanner_overlay.dart
└── assets/                      # Static resources
    ├── fonts/                   # Inter font family
    ├── icons/                   # App icons and logos
    └── images/                  # UI images and screenshots
```

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

