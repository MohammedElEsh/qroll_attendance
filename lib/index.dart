/// QRoll Attendance App - Main Index
///
/// This file serves as the main barrel export for the QRoll Attendance application.
/// It provides a single import point for all major components including models,
/// services, screens, widgets, and features.
///
/// Usage:
/// ```dart
/// import 'package:qroll_attendance/index.dart';
/// ```

library qroll_attendance;

// =============================================================================
// MODELS - Data models and entities
// =============================================================================

/// Core data models
export 'models/attendance_record.dart';
export 'models/course.dart';
export 'models/inbox_message.dart';
export 'models/student.dart';
export 'models/student_statistics.dart';
export 'models/user_profile.dart';

// =============================================================================
// SERVICES - API services and business logic
// =============================================================================

/// Authentication and user management
export 'services/auth_service.dart';

/// Course and academic data
export 'services/course_service.dart';

/// Student operations and statistics
export 'services/student_service.dart';

/// Attendance and absence tracking
export 'services/absence_service.dart';

/// User profile management
export 'services/profile_service.dart';

/// Messaging and notifications
export 'services/inbox_service.dart';

// =============================================================================
// SCREENS - Application screens and pages
// =============================================================================

/// Authentication screens
export 'screens/splash_screen.dart';
export 'screens/login_screen.dart';

/// Main application screens
export 'screens/dashboard_screen.dart';
export 'screens/profile_screen.dart';
export 'screens/change_password_screen.dart';

/// Course and attendance screens
export 'screens/course_detail_screen.dart';
export 'screens/attendance_report.dart';
export 'screens/lecture_attendance_report_screen.dart';
export 'screens/section_attendance_report_screen.dart';

/// Communication screens
export 'screens/inbox_screen.dart';
export 'screens/message_detail_screen.dart';

// =============================================================================
// WIDGETS - Reusable UI components
// =============================================================================

/// Navigation components
export 'widgets/app_drawer.dart';

/// Form components
export 'widgets/custom_button.dart';
export 'widgets/custom_textfield.dart';

/// Display components
export 'widgets/attendance_card.dart';
export 'widgets/message_card.dart';

// =============================================================================
// FEATURES - Feature-specific modules
// =============================================================================

/// QR Scanner feature
export 'features/qr_scanner/qr_scanner_screen.dart';
export 'features/qr_scanner/qr_result_screen.dart';

// =============================================================================
// UTILITIES - Helper functions and utilities
// =============================================================================

/// Testing and development utilities
export 'utils/qr_test_helper.dart';

// =============================================================================
// MAIN APPLICATION
// =============================================================================

/// Main application entry point
export 'main.dart';
