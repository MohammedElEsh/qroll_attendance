/// Section Attendance Report Screen
///
/// Displays detailed attendance information for sections in a specific course
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/student_service.dart';
import '../models/course.dart';

class SectionAttendanceReportScreen extends StatefulWidget {
  final Course course;

  const SectionAttendanceReportScreen({super.key, required this.course});

  @override
  State<SectionAttendanceReportScreen> createState() =>
      _SectionAttendanceReportScreenState();
}

class _SectionAttendanceReportScreenState
    extends State<SectionAttendanceReportScreen> {
  final StudentService _studentService = StudentService();

  List<dynamic> _sectionAttendance = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSectionAttendance();
  }

  /// Loads section attendance data from the student service
  Future<void> _loadSectionAttendance() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final courseId = int.tryParse(widget.course.id ?? '0') ?? 0;
      print('SectionAttendance: Course ID: $courseId');
      print('SectionAttendance: Course Name: ${widget.course.name}');

      if (courseId == 0) {
        throw Exception('Invalid course ID: ${widget.course.id}');
      }

      final response = await _studentService.getStudentSectionAttendance(
        courseId,
      );

      if (mounted) {
        setState(() {
          if (response.statusCode == 200) {
            // Debug: Print response details
            print(
              'SectionAttendance: Response data type: ${response.data.runtimeType}',
            );
            print('SectionAttendance: Response data: ${response.data}');

            if (response.data is List) {
              _sectionAttendance = response.data;
              print(
                'SectionAttendance: Found ${_sectionAttendance.length} section records',
              );
            } else if (response.data is Map && response.data['data'] is List) {
              _sectionAttendance = response.data['data'];
              print(
                'SectionAttendance: Found ${_sectionAttendance.length} section records in data field',
              );
            } else if (response.data is Map &&
                response.data['sections'] is List) {
              _sectionAttendance = response.data['sections'];
              print(
                'SectionAttendance: Found ${_sectionAttendance.length} section records in sections field',
              );
            } else {
              _sectionAttendance = [];
              print('SectionAttendance: No valid data structure found');
            }
          } else {
            _error =
                'Failed to load section attendance data (Status: ${response.statusCode})';
            print('SectionAttendance: HTTP Error ${response.statusCode}');
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print('SectionAttendance: Error occurred: $e');
      print('SectionAttendance: Error type: ${e.runtimeType}');
      if (mounted) {
        setState(() {
          _error = 'Failed to load section attendance: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 47, left: 123),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              'assets/image/Screenshot 2025-05-20 042959.png',
              width: 147,
              height: 46,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Course header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade800, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Section Attendance Report',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.course.displayName,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                if (widget.course.code != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Course Code: ${widget.course.code}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),

          // Content area
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error.isNotEmpty
                    ? _buildErrorView()
                    : _sectionAttendance.isEmpty
                    ? _buildEmptyView()
                    : _buildSectionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSectionAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Section Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No section attendance records found for this course.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSectionAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionList() {
    return RefreshIndicator(
      onRefresh: _loadSectionAttendance,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sectionAttendance.length,
        itemBuilder: (context, index) {
          final section = _sectionAttendance[index];
          return _buildSectionCard(section);
        },
      ),
    );
  }

  Widget _buildSectionCard(dynamic section) {
    // Extract section information from API response
    final String sectionId =
        section['section_id']?.toString() ?? section['id']?.toString() ?? '';
    final String sectionName =
        section['name']?.toString() ??
        section['title']?.toString() ??
        'Section $sectionId';
    final String sectionDate =
        section['date']?.toString() ?? section['created_at']?.toString() ?? '';
    final String attendanceStatus =
        section['status']?.toString() ??
        section['attendance_status']?.toString() ??
        'Unknown';
    final String sectionTime =
        section['time']?.toString() ?? section['start_time']?.toString() ?? '';
    final String location =
        section['location']?.toString() ?? section['room']?.toString() ?? '';
    final String instructor =
        section['instructor']?.toString() ??
        section['teacher']?.toString() ??
        '';

    // Determine status color
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;

    switch (attendanceStatus.toLowerCase()) {
      case 'present':
      case 'attended':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'absent':
      case 'missed':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'late':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    sectionName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        attendanceStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sectionDate.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(sectionDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (sectionTime.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sectionTime,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (location.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (instructor.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Instructor: $instructor',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
