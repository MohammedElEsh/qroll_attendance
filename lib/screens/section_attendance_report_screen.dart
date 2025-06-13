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
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          // Breadcrumb navigation
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
                  'SECTION ATTENDENCE REPORT',
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
            ),            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'SECTION\nNUMBER',
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
            ),),

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
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No section Data',
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

    switch (attendanceStatus.toLowerCase()) {
      case 'present':
      case 'attended':
        statusColor = Colors.green;
        break;
      case 'absent':
      case 'missed':
        statusColor = Colors.red;
        break;
      case 'late':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    sectionId,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  constraints: const BoxConstraints(maxWidth: 120),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendanceStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
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
