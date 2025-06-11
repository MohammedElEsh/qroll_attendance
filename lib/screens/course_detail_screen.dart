/// Course Detail Screen
///
/// Displays detailed information about a specific course
/// and provides access to course-related features
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../features/qr_scanner/qr_scanner_screen.dart';
import '../screens/lecture_attendance_report_screen.dart';
import '../screens/section_attendance_report_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.course.code != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Course Code: ${widget.course.code}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                  if (widget.course.instructor != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Instructor: ${widget.course.instructor}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Course Actions
            Text(
              'Course Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),

            // Action Cards
            _buildActionCard(
              icon: Icons.qr_code_scanner,
              title: 'Scan QR Code',
              subtitle: 'Mark attendance for this course',
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionCard(
              icon: Icons.school_outlined,
              title: 'View Lectures Attendance Report',
              subtitle: 'Check attendance for individual lectures',
              color: Colors.orange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => LectureAttendanceReportScreen(
                          course: widget.course,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionCard(
              icon: Icons.people_outline,
              title: 'View Section Attendance Report',
              subtitle: 'Check attendance for course sections',
              color: Colors.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => SectionAttendanceReportScreen(
                          course: widget.course,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Course Information
            if (widget.course.description != null ||
                widget.course.department != null ||
                widget.course.credits != null ||
                widget.course.schedule != null ||
                widget.course.location != null) ...[
              Text(
                'Course Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.course.description != null)
                      _buildInfoRow('Description', widget.course.description!),
                    if (widget.course.department != null)
                      _buildInfoRow('Department', widget.course.department!),
                    if (widget.course.credits != null)
                      _buildInfoRow(
                        'Credits',
                        widget.course.credits.toString(),
                      ),
                    if (widget.course.schedule != null)
                      _buildInfoRow('Schedule', widget.course.schedule!),
                    if (widget.course.location != null)
                      _buildInfoRow('Location', widget.course.location!),
                    if (widget.course.semester != null)
                      _buildInfoRow('Semester', widget.course.semester!),
                    if (widget.course.academicYear != null)
                      _buildInfoRow(
                        'Academic Year',
                        widget.course.academicYear!,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Attendance Statistics
            if (widget.course.attendancePercentage != null ||
                widget.course.totalSessions != null ||
                widget.course.attendedSessions != null) ...[
              Text(
                'Attendance Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.course.attendancePercentage != null)
                      _buildInfoRow(
                        'Attendance Percentage',
                        widget.course.formattedAttendancePercentage,
                      ),
                    if (widget.course.totalSessions != null)
                      _buildInfoRow(
                        'Total Sessions',
                        widget.course.totalSessions.toString(),
                      ),
                    if (widget.course.attendedSessions != null)
                      _buildInfoRow(
                        'Attended Sessions',
                        widget.course.attendedSessions.toString(),
                      ),
                    if (widget.course.totalSessions != null &&
                        widget.course.attendedSessions != null)
                      _buildInfoRow(
                        'Missed Sessions',
                        (widget.course.totalSessions! -
                                widget.course.attendedSessions!)
                            .toString(),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
