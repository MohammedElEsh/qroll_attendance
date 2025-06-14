// / Main dashboard screen displayed after successful login.
// / Shows courses and sections overview.

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/course_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  int _courseCount = 0;
  int _sectionCount = 0;

  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {

      // Get statistics from API
      final statistics = await _courseService.getMyStatistics();


      if (mounted) {
        setState(() {
          _courseCount = statistics?.coursesCount ?? 0;
          _sectionCount =
              statistics?.coursesCount ?? 0; // Same number as courses
          _isLoading = false;
        });

      }
    } catch (e) {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Handle specific error cases
        String errorMessage = 'Failed to load dashboard data';
        if (e.toString().contains('No authentication token found')) {
          errorMessage = 'Session expired. Please login again.';
        } else if (e.toString().contains('Connection timeout')) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }

        _showErrorSnackBar(errorMessage);
      }
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Image.asset(
          'assets/image/Screenshot 2025-05-20 042959.png',
          height: 100,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 155, left: 99),
                    width: 182,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDashboardItem(
                          imagePath: 'assets/image/lecIcon.png',
                          title: 'Courses',
                          count: _courseCount,
                        ),
                        const SizedBox(height: 40),
                        _buildDashboardItem(
                          imagePath: 'assets/image/secIcon.png',
                          title: 'Sections',
                          count: _sectionCount,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildDashboardItem({
    required String imagePath,
    required String title,
    required int count,
  }) {
    return Container(
      width: 180,
      height: 92,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 23,
            left: 16,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.grey[100]?.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(imagePath, width: 46, height: 46),
            ),
          ),
          Positioned(
            left: 72,
            top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
