/// Login screen that handles user authentication.
/// Provides clean UI for student login with national ID and password.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Form and input controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Service instance
  final _authService = AuthService();

  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  final int _roleId = 4; // Fixed for student

  @override
  void initState() {
    super.initState();
  }

  /// Handles the login process
  /// Validates form inputs and attempts to authenticate the user
  Future<void> _login() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        roleId: _roleId,
      );

      if (!mounted) return;

      // Check for successful response
      if (response.statusCode == 200) {
        // Handle different response structures
        bool isSuccess = false;
        String? token;
        String? message;

        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;

          // Check for status field
          if (data.containsKey('status')) {
            isSuccess =
                data['status'] == true ||
                data['status'] == 'true' ||
                data['status'] == 1;
          } else {
            // If no status field, assume success if we have a token
            isSuccess =
                data.containsKey('token') ||
                (data.containsKey('data') &&
                    data['data'] is Map &&
                    data['data']['token'] != null);
          }

          // Extract token
          if (data.containsKey('token')) {
            token = data['token'];
          } else if (data.containsKey('data') && data['data'] is Map) {
            token = data['data']['token'];
          }

          // Extract message
          message = data['message'] ?? data['msg'];
        }

        if (isSuccess && token != null) {
          // Show success message
          _showSuccessSnackBar(message ?? 'Login successful! Welcome back.');

          // Small delay to show success message
          await Future.delayed(const Duration(milliseconds: 500));

          if (!mounted) return;

          // Navigate to dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          // Handle API error response
          final errorMsg = message ?? 'Invalid credentials. Please try again.';
          _showErrorSnackBar(errorMsg);
        }
      } else {
        // Handle non-200 status codes
        String errorMsg = 'Login failed. Please try again.';

        if (response.statusCode == 401) {
          errorMsg =
              'Invalid credentials. Please check your national ID and password.';
        } else if (response.statusCode == 422) {
          errorMsg = 'Invalid input. Please check your credentials.';
        } else if (response.statusCode != null && response.statusCode! >= 500) {
          errorMsg = 'Server error. Please try again later.';
        }

        _showErrorSnackBar(errorMsg);
      }
    } catch (e) {
      if (!mounted) return;

      // Handle different types of errors
      String errorMessage =
          'Login failed. Please check your connection and try again.';

      if (e.toString().contains('Connection timeout') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Network is unreachable')) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.toString().contains('Connection refused')) {
        errorMessage = 'Cannot connect to server. Please try again later.';
      } else if (e.toString().contains('Invalid credentials')) {
        errorMessage = 'Invalid national ID or password. Please try again.';
      } else if (e.toString().contains('401')) {
        errorMessage =
            'Invalid credentials. Please check your national ID and password.';
      } else if (e.toString().contains('422')) {
        errorMessage = 'Invalid input format. Please check your credentials.';
      }

      _showErrorSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Displays an error message in a snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Displays a success message in a snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo and branding
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // App logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade700,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'QRoll Attendance',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'University Student Portal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.indigo.shade600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Welcome title
                  Text(
                    'Student Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your credentials to access your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // National ID input field with validation
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'National ID',
                    hintText: 'Enter your national ID',
                    prefixIcon: Icons.badge_outlined,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your national ID';
                      }
                      if (value.trim().length < 8) {
                        return 'National ID must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password input field with toggle visibility
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    onSubmitted: (_) => _isLoading ? null : _login(),
                  ),
                  const SizedBox(height: 30),

                  // Login button with loading state
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
