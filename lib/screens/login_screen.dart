/// Login screen that handles user authentication.
/// Provides email/password login with role selection functionality.
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/auth_service.dart';
import '../services/role_service.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/custom_button.dart';
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

  // Service instances
  final _authService = AuthService();
  final _roleService = RoleService();

  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  List<Role> _roles = [];
  int _selectedRoleId = 1; // Default: Student

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  /// Loads available roles from the role service
  Future<void> _loadRoles() async {
    try {
      final roles = await _roleService.getRoles();
      setState(() {
        _roles = roles;
        if (roles.isNotEmpty) {
          _selectedRoleId = roles.first.id;
        }
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load roles: $e');
    }
  }

  /// Handles the login process
  /// Validates form inputs and attempts to authenticate the user
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
        _selectedRoleId,
      );

      if (!mounted) return;

      if (result['status'] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        _showErrorSnackBar(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorSnackBar('Login failed: $e');
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
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
                  // App logo and title container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'QROLL',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        Text(
                          'ATTENDANCE',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 4,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login form title
                  Text(
                    'Log In To Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Email input field with validation
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password input field with toggle visibility
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Role selection dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedRoleId,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        hint: const Text('Select Role'),
                        style: TextStyle(
                          color: Colors.indigo.shade900,
                          fontSize: 16,
                        ),
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              _selectedRoleId = value;
                            });
                          }
                        },
                        items:
                            _roles.map<DropdownMenuItem<int>>((Role role) {
                              return DropdownMenuItem<int>(
                                value: role.id,
                                child: Text(role.name),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login button with loading state
                  CustomButton(
                    text: 'Login',
                    onPressed: _isLoading ? null : _login,
                    isLoading: _isLoading,
                    loadingIndicator: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Version Text
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
