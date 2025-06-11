/// Lecture Attendance Report Screen
///
/// Displays detailed attendance information for lectures in a specific course
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/student_service.dart';
import '../models/course.dart';

class LectureAttendanceReportScreen extends StatefulWidget {
  final Course course;

  const LectureAttendanceReportScreen({super.key, required this.course});

  @override
  State<LectureAttendanceReportScreen> createState() =>
      _LectureAttendanceReportScreenState();
}

class _LectureAttendanceReportScreenState
    extends State<LectureAttendanceReportScreen> {
  final StudentService _studentService = StudentService();

  List<dynamic> _lectureAttendance = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadLectureAttendance();
  }

  /// Loads lecture attendance data from the student service
  Future<void> _loadLectureAttendance() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final courseId = int.tryParse(widget.course.id ?? '0') ?? 0;
      print('LectureAttendance: Course ID: $courseId');
      print('LectureAttendance: Course Name: ${widget.course.name}');

      if (courseId == 0) {
        throw Exception('Invalid course ID: ${widget.course.id}');
      }

      final response = await _studentService.getStudentLectureAttendance(
        courseId,
      );

      if (mounted) {
        setState(() {
          if (response.statusCode == 200) {
            // Debug: Print response details
            print(
              'LectureAttendance: Response data type: ${response.data.runtimeType}',
            );
            print('LectureAttendance: Response data: ${response.data}');

            if (response.data is List) {
              _lectureAttendance = response.data;
              print(
                'LectureAttendance: Found ${_lectureAttendance.length} lecture records',
              );
            } else if (response.data is Map && response.data['data'] is List) {
              _lectureAttendance = response.data['data'];
              print(
                'LectureAttendance: Found ${_lectureAttendance.length} lecture records in data field',
              );
            } else if (response.data is Map &&
                response.data['lectures'] is List) {
              _lectureAttendance = response.data['lectures'];
              print(
                'LectureAttendance: Found ${_lectureAttendance.length} lecture records in lectures field',
              );
            } else {
              _lectureAttendance = [];
              print('LectureAttendance: No valid data structure found');
            }
          } else {
            _error =
                'Failed to load lecture attendance data (Status: ${response.statusCode})';
            print('LectureAttendance: HTTP Error ${response.statusCode}');
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print('LectureAttendance: Error occurred: $e');
      print('LectureAttendance: Error type: ${e.runtimeType}');
      if (mounted) {
        setState(() {
          _error = 'Failed to load lecture attendance: $e';
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
                colors: [Colors.orange.shade800, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lecture Attendance Report',
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
                    : _lectureAttendance.isEmpty
                    ? _buildEmptyView()
                    : _buildLectureList(),
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
              onPressed: _loadLectureAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
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
            Icon(Icons.school_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Lecture Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No lecture attendance records found for this course.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadLectureAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureList() {
    return RefreshIndicator(
      onRefresh: _loadLectureAttendance,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lectureAttendance.length,
        itemBuilder: (context, index) {
          final lecture = _lectureAttendance[index];
          return _buildLectureCard(lecture);
        },
      ),
    );
  }

  Widget _buildLectureCard(dynamic lecture) {
    // Extract lecture information from API response
    final String lectureId =
        lecture['lecture_id']?.toString() ?? lecture['id']?.toString() ?? '';
    final String lectureName =
        lecture['name']?.toString() ??
        lecture['title']?.toString() ??
        'Lecture $lectureId';
    final String lectureDate =
        lecture['date']?.toString() ?? lecture['created_at']?.toString() ?? '';
    final String attendanceStatus =
        lecture['status']?.toString() ??
        lecture['attendance_status']?.toString() ??
        'Unknown';
    final String lectureTime =
        lecture['time']?.toString() ?? lecture['start_time']?.toString() ?? '';
    final String location =
        lecture['location']?.toString() ?? lecture['room']?.toString() ?? '';

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
                    lectureName,
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
            if (lectureDate.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(lectureDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (lectureTime.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lectureTime,
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
