// / Login screen that handles user authentication.
// / Provides clean UI for student login with national ID and password.


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../screens/dashboard_screen.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo section with reduced spacing
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/image/Screenshot 2025-05-20 042959.png',
                        height: 60,
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Login To Your Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // Email Field
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'johndoe@gmail.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1A9BD7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Password Field
                const Text(
                  'password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '******************',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1A9BD7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF181C36),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
