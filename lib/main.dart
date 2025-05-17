/// Entry point of the QRoll Attendance application.
/// Initializes the app with Riverpod state management and sets up the main UI.
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
        // Configure color scheme with indigo as the primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        // Set Inter as the default font family
        fontFamily: 'Inter',
        // Customize app bar appearance
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        // Configure elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
          ),
        ),
        // Configure input field styling
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
