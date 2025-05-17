# QRoll Attendance

A Flutter mobile application for managing student attendance using QR code scanning.

## Features

- **Student Authentication**: Secure login and authentication system
- **QR Code Scanning**: Mark attendance by scanning QR codes
- **Attendance Reports**: View attendance history with detailed statistics
- **Profile Management**: View and update personal information
- **Password Management**: Change password securely

## Technology Stack

- Flutter (Frontend)
- REST API integration for backend communication
- Dio for API calls
- Secure Storage for JWT tokens
- Riverpod for state management

## Project Structure

The application follows a structured architecture:

```
lib/
├── main.dart                 # App entry point
├── core/                     # Core utilities
│   ├── api_constants.dart    # API endpoints
│   └── app_routes.dart       # Navigation routes
├── models/                   # Data models
│   ├── user_profile.dart     # User profile model
│   ├── attendance_record.dart # Attendance model
│   └── student.dart          # Student model
├── services/                 # API services
│   ├── auth_service.dart     # Authentication service
│   ├── profile_service.dart  # Profile management
│   ├── student_service.dart  # Student CRUD operations
│   └── role_service.dart     # Role management
├── features/                 # Feature modules
│   └── qr_scanner/           # QR scanning feature
│       ├── qr_scanner_screen.dart
│       ├── qr_result_screen.dart
│       └── scanner_overlay.dart
├── screens/                  # Application screens
│   ├── splash_screen.dart    # Splash screen
│   ├── login_screen.dart     # Login page
│   ├── dashboard_screen.dart # Main dashboard
│   ├── attendance_report.dart # Attendance history
│   ├── profile_screen.dart   # Profile view
│   ├── edit_profile_screen.dart # Edit profile
│   └── change_password_screen.dart # Change password
└── widgets/                  # Reusable UI components
    ├── custom_button.dart    # Custom button
    ├── custom_textfield.dart # Custom text field
    ├── app_drawer.dart       # Navigation drawer
    └── attendance_card.dart  # Attendance record card
```

## Getting Started

### Prerequisites

- Flutter SDK (Latest stable version)
- Android Studio / VS Code
- Android / iOS emulator or physical device

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/qroll_attendance.git
   ```

2. Navigate to the project directory:
   ```
   cd qroll_attendance
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Current Status

The application currently supports student users. Future updates will include:
- Admin functionality
- Teacher management
- Course management
- Enhanced reporting

## Security

- JWT token-based authentication
- Secure password storage
- Input validation and sanitization

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Firebase / Custom Backend (Optional)**
- **QR Code Scanner**: `mobile_scanner` or `qr_code_scanner`

## 🗂 Folder Structure

See the `lib/` folder for organized UI, services, and reusable widgets.

## 🤝 Contributing

1. Fork the repo
2. Clone it locally
3. Create a new branch (`feature/my-feature`)
4. Commit your changes
5. Push and open a PR

## 📷 UI Preview

*(Insert UI screenshot here)*

## 👨‍💻 Contributors

- [@MohammedElEsh](https://github.com/MohammedElEsh)
- [Your Friend's GitHub Profile]

