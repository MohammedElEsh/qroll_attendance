import 'package:flutter/material.dart';
import '../services/auth_service.dart' as auth;
import '../services/profile_service.dart';
import '../services/course_service.dart';
import '../models/user_profile.dart';
import '../models/course.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/inbox_screen.dart';
import '../screens/course_detail_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ProfileService _profileService = ProfileService();
  final CourseService _courseService = CourseService();
  final auth.AuthService _authService = auth.AuthService();

  UserProfile? _userProfile;
  List<Course> _courses = [];
  bool _isLoading = true;
  bool _isCoursesLoading = false;
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

  Future<void> _loadCourses() async {
    if (_isCoursesLoading) return;

    setState(() {
      _isCoursesLoading = true;
    });

    try {
      final courses = await _courseService.getMyCourses();

      if (mounted) {
        setState(() {
          _courses = courses;
          _isCoursesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCoursesLoading = false;
        });
      }
    }
  }

  void _navigateToCourseDetail(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
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
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  navigator.pop();

                  try {
                    await _authService.logoutLocal();

                    if (!mounted) return;

                    // Navigate to login screen
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    if (!mounted) return;

                    scaffoldMessenger.showSnackBar(
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
      child: SafeArea(
        child: Column(
          children: [
            // Fixed header section
            _buildHeader(),

            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
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
                          MaterialPageRoute(
                            builder: (context) => const ModernProfileScreen(),
                          ),
                        );
                      },
                    ),

                    // Courses with submenu
                    _buildExpandableMenuItem(
                      icon: Icons.menu_book_outlined,
                      title: 'Courses',
                      isExpanded: _isCoursesExpanded,
                      onTap: () async {
                        setState(() {
                          _isCoursesExpanded = !_isCoursesExpanded;
                        });

                        // Load courses when expanding for the first time
                        if (_isCoursesExpanded && _courses.isEmpty) {
                          await _loadCourses();
                        }
                      },
                    ),

                    if (_isCoursesExpanded) ...[
                      if (_isCoursesLoading)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 72,
                            right: 24,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Loading courses...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_courses.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 72,
                            right: 24,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            'No courses found',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        ..._courses.map(
                          (course) => _buildSubmenuItem(
                            title: course.displayName,
                            onTap: () {
                              Navigator.pop(context);
                              _navigateToCourseDetail(course);
                            },
                          ),
                        ),
                    ],

                    _buildMenuItem(
                      icon: Icons.inbox_outlined,
                      title: 'Inbox',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const InboxScreen(),
                          ),
                        );
                      },
                    ),

                    // Logout button (now at bottom of scrollable content)
                    const SizedBox(
                      height: 40,
                    ), // Add some spacing before logout
                    _buildMenuItem(
                      icon: Icons.logout_outlined,
                      title: 'Log Out',
                      onTap: _logout,
                      showChevron: false,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the fixed header section with logo and user profile
  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo and Brand
        Padding(          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF161B39),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/image/Screenshot 2025-05-20 035639.png',
                fit: BoxFit.contain,
                height: 180,
              ),
            ),
          ),
        ),

        // User Profile Section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _userProfile?.image != null
                        ? NetworkImage(_userProfile!.image!)
                        : null,
                child:
                    _userProfile?.image == null
                        ? Icon(Icons.person, color: Colors.grey[700], size: 24)
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
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing:
          showChevron
              ? const Icon(Icons.chevron_right, color: Colors.white, size: 22)
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
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
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
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white, size: 22),
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 72,
        right: 24,
        top: 4,
        bottom: 4,
      ),
    );
  }
}
