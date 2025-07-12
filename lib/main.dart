// / Entry point of the QRoll Attendance application.
// / Initializes the app with Riverpod state management and sets up the main UI.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application.
/// Configures the app's theme and initial route.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRoll Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Enable Material 3 design system
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7EF4E1),
          brightness: Brightness.light,
          primary: const Color(0xFF7EF4E1),
          secondary: const Color(0xFF7EF4E1),
          surface: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.black,
        ),
        // Set Inter as the default font family
        fontFamily: 'Inter',
        // Customize app bar appearance
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Configure card styling for dashboard stats
        cardTheme: CardThemeData(
          color: Colors.grey[100],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Configure elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7EF4E1),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        // Configure input field styling
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[100],
          hintStyle: const TextStyle(color: Colors.black54),
          labelStyle: const TextStyle(color: Colors.black),
        ),
        // Configure icon theme
        iconTheme: const IconThemeData(color: Colors.black),
        // Configure text theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.black),
        ),
        // Configure drawer theme to match the dark navy sidebar
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1A1E38),
          scrimColor: Colors.black54,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
