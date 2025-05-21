/// Initial screen shown when the app starts.
/// Handles app initialization and authentication state check.
library;
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../screens/dashboard_screen.dart';
// import '../screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Checks authentication status and navigates to appropriate screen
  /// Shows splash screen for 10 seconds before redirecting
  Future<void> _navigateToNextScreen() async {
    // Wait for 2 seconds to display splash screen
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    // Check if the user is already logged in
    final bool isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // Navigate to the dashboard if already logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // Navigate to the login screen if not logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Gradient background from dark to light indigo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E), // Indigo 900
              Color(0xFF3949AB), // Indigo 600
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo container with shadow effect
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(76),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icons/app_logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 50),

            // Loading indicator with custom styling
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),

            // Loading text with custom styling
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
