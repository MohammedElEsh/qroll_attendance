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
        toolbarHeight: 80,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Image.asset(
            'assets/image/Screenshot 2025-05-20 042959.png',
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb navigation
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'COURCES',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.course.name ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '>',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'LECTURE ATTENDENCE REPORT',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          // Table header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'LECTURE\nNUMBER',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'DATE',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _isLoading
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
          return _buildLectureRow(lecture, index + 1);
        },
      ),
    );
  }

  Widget _buildLectureRow(dynamic lecture, int number) {
    final String lectureDate = 
        lecture['date']?.toString() ?? lecture['created_at']?.toString() ?? '';
    final String attendanceStatus =
        lecture['status']?.toString() ??
        lecture['attendance_status']?.toString() ??
        'Unknown';

    // Determine status appearance
    Color statusColor;
    Color bgColor;
    switch (attendanceStatus.toLowerCase()) {
      case 'present':
      case 'attended':
        statusColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case 'absent':
      case 'missed':
        statusColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        bgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _formatDate(lectureDate),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              constraints: const BoxConstraints(maxWidth: 120),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                attendanceStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
