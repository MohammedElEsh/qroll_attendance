/// Profile screen that displays user information and allows profile management.
/// Shows personal details, contact information, and account details.
library;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/profile_service.dart';
import '../models/user_profile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Service instance for profile operations
  final ProfileService _profileService = ProfileService();

  // State variables
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Loads the user's profile information from the profile service
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = '';
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
          _error = 'Failed to load profile: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.indigo,
        actions: [
          // Edit profile button in app bar
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EditProfileScreen(userProfile: _userProfile!),
                    ),
                  )
                  .then((_) => _loadUserProfile());
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? _buildErrorView()
              : _buildProfileView(),
    );
  }

  /// Builds the error view when profile loading fails
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main profile view with user information
  Widget _buildProfileView() {
    if (_userProfile == null) {
      return const Center(child: Text('No profile data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header with image and basic information
          Center(
            child: Column(
              children: [
                // Profile picture or initial avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.shade100,
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
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade800,
                            ),
                          )
                          : null,
                ),
                const SizedBox(height: 16),

                // User's full name
                Text(
                  _userProfile!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // User's role badge
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _userProfile!.roleName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),

                // Academic ID display
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'ID: ${_userProfile!.academicId}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Contact information section
          _buildSectionHeader('Contact Information'),
          _buildInfoItem(Icons.email, 'Email', _userProfile!.email),
          _buildInfoItem(Icons.phone, 'Phone', _userProfile!.phone),

          const SizedBox(height: 24),

          // Personal information section
          _buildSectionHeader('Personal Information'),
          _buildInfoItem(Icons.badge, 'National ID', _userProfile!.nationalId),
          _buildInfoItem(
            Icons.calendar_today,
            'Birth Date',
            _formatDate(_userProfile!.birthDate),
          ),
          _buildInfoItem(Icons.location_on, 'Address', _userProfile!.address),

          const SizedBox(height: 24),

          // Account information section
          _buildSectionHeader('Account Information'),
          _buildInfoItem(
            Icons.access_time,
            'Created On',
            _formatDate(_userProfile!.createdAt),
          ),
          _buildInfoItem(
            Icons.update,
            'Last Updated',
            _formatDate(_userProfile!.updatedAt),
          ),

          const SizedBox(height: 30),

          // Edit profile button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EditProfileScreen(userProfile: _userProfile!),
                      ),
                    )
                    .then((_) => _loadUserProfile());
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
          ),
        ),
        Divider(color: Colors.indigo.shade200, thickness: 2),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.indigo.shade700, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}
