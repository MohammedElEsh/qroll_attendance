import 'package:flutter/material.dart';
import '../services/auth_service.dart' as auth;
import '../services/profile_service.dart';
import '../models/user_profile.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../features/qr_scanner/qr_scanner_screen.dart';
import '../screens/attendance_report.dart';
import '../screens/profile_screen.dart';
import '../screens/change_password_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ProfileService _profileService = ProfileService();
  final auth.AuthService _authService = auth.AuthService();

  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
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
      }
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  try {
                    final result = await _authService.logout();

                    if (!mounted) return;

                    // Navigate to login screen only if the widget is still mounted
                    if (result) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logout failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo.shade800),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  _userProfile?.image != null
                      ? NetworkImage(_userProfile!.image!)
                      : null,
              child:
                  _userProfile?.image == null
                      ? Text(
                        _userProfile?.name.isNotEmpty == true
                            ? _userProfile!.name[0].toUpperCase()
                            : 'S',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                        ),
                      )
                      : null,
            ),
            accountName: Text(
              _isLoading ? 'Loading...' : (_userProfile?.name ?? 'Student'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              _isLoading ? '' : (_userProfile?.email ?? ''),
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Menu Items
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.qr_code_scanner,
            title: 'Scan QR Code',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.assessment,
            title: 'Attendance Report',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AttendanceReportScreen(),
                ),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          const Divider(),

          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: _logout,
            iconColor: Colors.red,
            textColor: Colors.red,
          ),

          const Spacer(),

          // App Version
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.indigo,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }
}
