/// Attendance report screen that displays student attendance records and statistics.
/// Shows attendance history grouped by month with summary statistics.
library;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/student_service.dart';
import '../models/attendance_record.dart';
import '../widgets/attendance_card.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  // Service instance for fetching attendance data
  final StudentService _studentService = StudentService();

  // State variables
  List<AttendanceRecord> _attendanceRecords = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  /// Loads attendance records from the student service
  Future<void> _loadAttendanceRecords() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final records = await _studentService.getAttendanceRecords();

      if (mounted) {
        setState(() {
          _attendanceRecords = records;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load attendance records: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
        backgroundColor: Colors.indigo,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? _buildErrorView()
              : _attendanceRecords.isEmpty
              ? _buildEmptyView()
              : _buildAttendanceList(),
    );
  }

  /// Builds the error view when attendance records fail to load
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
              onPressed: _loadAttendanceRecords,
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

  /// Builds the empty state view when no attendance records exist
  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Records Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any attendance records yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAttendanceRecords,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main attendance list view with grouped records and statistics
  Widget _buildAttendanceList() {
    // Group records by month for organized display
    final Map<String, List<AttendanceRecord>> groupedRecords = {};

    for (var record in _attendanceRecords) {
      final DateTime recordDate = DateTime.parse(record.date);
      final String monthYear = DateFormat('MMMM yyyy').format(recordDate);

      if (!groupedRecords.containsKey(monthYear)) {
        groupedRecords[monthYear] = [];
      }

      groupedRecords[monthYear]!.add(record);
    }

    // Calculate attendance statistics
    final int totalRecords = _attendanceRecords.length;
    final int presentCount =
        _attendanceRecords
            .where((record) => record.status.toLowerCase() == 'present')
            .length;
    final double attendancePercentage =
        totalRecords > 0 ? (presentCount / totalRecords) * 100 : 0;

    return RefreshIndicator(
      onRefresh: _loadAttendanceRecords,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance summary card with statistics
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Attendance Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        totalRecords.toString(),
                        Colors.blue.shade300,
                      ),
                      _buildStatItem(
                        'Present',
                        presentCount.toString(),
                        Colors.green.shade300,
                      ),
                      _buildStatItem(
                        'Absent',
                        (totalRecords - presentCount).toString(),
                        Colors.red.shade300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Attendance percentage progress bar
                  Stack(
                    children: [
                      // Progress background
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Progress indicator
                      Container(
                        height: 20,
                        width:
                            MediaQuery.of(context).size.width *
                            (attendancePercentage / 100) *
                            0.86, // Adjust for padding
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Attendance Records by Month
            ...groupedRecords.entries.map((entry) {
              final String monthYear = entry.key;
              final List<AttendanceRecord> records = entry.value;

              // Sort records by date (descending)
              records.sort(
                (a, b) =>
                    DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.indigo.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          monthYear,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Records for this month
                  ...records
                      .map((record) => AttendanceCard(record: record))
                      ,
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}
