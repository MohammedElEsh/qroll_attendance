/// Main dashboard screen displayed after successful login.
/// Shows user profile information and provides access to key features.
import 'package:flutter/material.dart';
// import '../services/auth_service.dart' as auth;
import '../services/profile_service.dart';
import '../models/user_profile.dart';
import '../widgets/app_drawer.dart';
import '../features/qr_scanner/qr_scanner_screen.dart';
import '../screens/attendance_report.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Service instances
  final ProfileService _profileService = ProfileService();
  // final auth.AuthService _authService = auth.AuthService();

  // State variables
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads the user's profile information from the profile service
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _profileService.getProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load profile: $e');
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

  /// Navigates to the specified screen
  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      drawer: const AppDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadUserProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User profile greeting card with gradient background
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.shade800,
                              Colors.indigo.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Profile picture or initial avatar
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      _userProfile?.image != null
                                          ? NetworkImage(_userProfile!.image!)
                                          : null,
                                  child:
                                      _userProfile?.image == null
                                          ? Text(
                                            _userProfile?.name.isNotEmpty ==
                                                    true
                                                ? _userProfile!.name[0]
                                                    .toUpperCase()
                                                : 'S',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo.shade800,
                                            ),
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome,',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.indigo.shade100,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _userProfile?.name ?? 'Student',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Academic ID: ${_userProfile?.academicId ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Grid of main feature cards
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          // QR code scanner for attendance
                          _buildFeatureCard(
                            icon: Icons.qr_code_scanner,
                            title: 'Scan QR',
                            subtitle: 'Mark attendance',
                            color: Colors.blue,
                            onTap:
                                () =>
                                    _navigateToScreen(const QRScannerScreen()),
                          ),

                          // Attendance history and reports
                          _buildFeatureCard(
                            icon: Icons.assessment,
                            title: 'Attendance',
                            subtitle: 'View your records',
                            color: Colors.green,
                            onTap:
                                () => _navigateToScreen(
                                  const AttendanceReportScreen(),
                                ),
                          ),

                          // User profile management
                          _buildFeatureCard(
                            icon: Icons.person,
                            title: 'Profile',
                            subtitle: 'View & edit details',
                            color: Colors.orange,
                            onTap:
                                () => _navigateToScreen(const ProfileScreen()),
                          ),

                          // Password change functionality
                          _buildFeatureCard(
                            icon: Icons.lock,
                            title: 'Password',
                            subtitle: 'Change password',
                            color: Colors.purple,
                            onTap:
                                () => _navigateToScreen(
                                  const ChangePasswordScreen(),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Helpful tips section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: Colors.amber.shade700,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Quick Tips',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTipItem(
                              'Scan the QR code displayed by your instructor to mark attendance.',
                            ),
                            _buildTipItem(
                              'Make sure you\'re within the allowed time window to mark attendance.',
                            ),
                            _buildTipItem(
                              'Check your attendance report regularly to ensure accurate records.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.indigo.shade400, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
