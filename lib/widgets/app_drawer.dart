import 'package:flutter/material.dart';
import '../services/auth_service.dart' as auth;
import '../services/profile_service.dart';
import '../models/user_profile.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

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
  bool _isCoursesExpanded = false;

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
      backgroundColor: const Color(0xFF161B39), // Dark navy background
      child: Column(
        children: [
          // App Logo and Brand
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF161B39),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/image/Screenshot 2025-05-20 035639.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // User Profile Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
              backgroundImage:
                  _userProfile?.image != null
                      ? NetworkImage(_userProfile!.image!)
                      : null,
                  child: _userProfile?.image == null
                      ? Icon(
                          Icons.person,
                          color: Colors.grey[700],
                          size: 24,
                      )
                      : null,
            ),
                const SizedBox(width: 12),
                Text(
                  _isLoading ? 'Loading...' : (_userProfile?.name ?? 'User'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
            ),
                ),
              ],
            ),
          ),

          // Menu items
          _buildMenuItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
          ),

          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          // Courses with submenu
          _buildExpandableMenuItem(
            icon: Icons.menu_book_outlined,
            title: 'Courses',
            isExpanded: _isCoursesExpanded,
            onTap: () {
              setState(() {
                _isCoursesExpanded = !_isCoursesExpanded;
              });
            },
          ),

          if (_isCoursesExpanded) ...[
            _buildSubmenuItem(
              title: 'CS',
              onTap: () {
                // Handle CS course navigation
                Navigator.pop(context);
              },
            ),
            _buildSubmenuItem(
              title: 'IT',
              onTap: () {
                // Handle IT course navigation
                Navigator.pop(context);
              },
            ),
          ],

          _buildMenuItem(
            icon: Icons.inbox_outlined,
            title: 'Inbox',
            onTap: () {
              // Handle inbox navigation
              Navigator.pop(context);
            },
          ),

          // Spacer to push logout to bottom
          const Spacer(),

          // Logout button
          _buildMenuItem(
            icon: Icons.logout_outlined,
            title: 'Log Out',
            onTap: _logout,
            showChevron: false,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: showChevron
          ? const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 22,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 22,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildSubmenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: 22,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 72, right: 24, top: 4, bottom: 4),
    );
  }
}
