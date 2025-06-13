import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../screens/change_password_screen.dart';
import '../widgets/app_drawer.dart';

/// Modern Profile Screen with responsive design and comprehensive error handling
/// Displays user profile information with form fields for editing
class ModernProfileScreen extends StatefulWidget {
  const ModernProfileScreen({super.key});

  @override
  State<ModernProfileScreen> createState() => _ModernProfileScreenState();
}

class _ModernProfileScreenState extends State<ModernProfileScreen> {  // Service instances for API calls
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  // Text controllers for form fields - manage user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _academicIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();

  // State management variables
  bool _isLoading = true; // Controls loading spinner visibility
  String? _errorMessage; // Stores error messages for display
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    // Initialize profile data loading on screen creation
    _checkTokenAndLoadProfile();
  }

  /// Validates user authentication and loads profile data
  /// Checks if user is logged in before attempting to load profile
  Future<void> _checkTokenAndLoadProfile() async {
    try {
      // Verify user authentication status
      final isLoggedIn = await _authService.isLoggedIn();

      if (!isLoggedIn) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User is not logged in. Please log in first.';
        });
        return;
      }

      // Test API connectivity before proceeding
      await _profileService.testConnection();

      // Load user profile data
      await _loadProfile();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error checking login status: ${e.toString()}';
      });
    }
  }
  /// Fetches user profile data from API and populates form fields
  /// Handles loading states and error scenarios
  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Fetch profile data from service
      final profile = await _profileService.getProfile();

      if (profile != null) {
        // Populate form controllers with profile data
        setState(() {
          _nameController.text = profile.name ?? '';
          _academicIdController.text = profile.academicId ?? '';
          _emailController.text = profile.email ?? '';
          _nationalIdController.text = profile.nationalId ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User data not found';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
    }
  }
  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    _nameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Navigation drawer for app-wide navigation
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/image/Screenshot 2025-05-20 042959.png',
          height: 100,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      ElevatedButton(
                        onPressed: _checkTokenAndLoadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header
                      const Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User name field - editable
                      _buildTextField('Name', _nameController),
                      const SizedBox(height: 12),

                      // Academic ID field - read-only for security
                      _buildTextField(
                        'Academic ID',
                        _academicIdController,
                        enabled: false,
                      ),
                      const SizedBox(height: 12),

                      // Email field - editable
                      _buildTextField('Email', _emailController),
                      const SizedBox(height: 12),

                      // National ID field - editable
                      _buildTextField('National ID', _nationalIdController),
                      const SizedBox(height: 12),                      // Password field - masked display only
                      _buildPasswordField(),
                      const SizedBox(height: 40),

                      // Navigation button to password change screen
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ChangePasswordScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// Builds a reusable text field widget with consistent styling
  /// [label] - Field label text
  /// [controller] - Text controller for field value
  /// [enabled] - Whether field is editable (default: true)
  /// [maxLines] - Number of text lines (default: 1)
  /// [icon] - Optional suffix icon
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        // Text input field with consistent styling
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: enabled ? Colors.black : Colors.grey[600],
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            // Border styling for different states
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            // Optional suffix icon
            suffixIcon:
                icon != null
                    ? Icon(icon, color: Colors.grey[600], size: 20)
                    : null,
            // Placeholder text for empty disabled fields
            hintText: controller.text.isEmpty && !enabled ? 'No data' : null,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ),
      ],
    );
  }
  /// Builds a password field with masked text display
  /// Shows asterisks instead of actual password for security
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          obscureText: !_showPassword,
          enabled: false,
          initialValue: '********************',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
