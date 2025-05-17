import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_record.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPresent = record.status.toLowerCase() == 'present';
    
    // Format date and time
    DateTime recordDate;
    String formattedDate = '';
    String formattedTime = '';
    String dayOfWeek = '';
    
    try {
      recordDate = DateTime.parse(record.date);
      formattedDate = DateFormat('MMM dd, yyyy').format(recordDate);
      dayOfWeek = DateFormat('EEEE').format(recordDate);
      
      if (record.time.isNotEmpty) {
        final timeFormatted = DateFormat.jm().format(
          DateFormat('HH:mm:ss').parse(record.time),
        );
        formattedTime = timeFormatted;
      }
    } catch (e) {
      formattedDate = record.date;
      formattedTime = record.time;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPresent 
              ? Colors.green.shade100 
              : Colors.red.shade100,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showAttendanceDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status indicator
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isPresent 
                      ? Colors.green.shade50 
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isPresent 
                        ? Icons.check_circle 
                        : Icons.cancel,
                    color: isPresent 
                        ? Colors.green 
                        : Colors.red,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Attendance details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.lectureName,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$formattedDate ($dayOfWeek)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    if (formattedTime.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPresent 
                      ? Colors.green.shade100 
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  record.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPresent 
                        ? Colors.green.shade800 
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAttendanceDetails(BuildContext context) {
    final bool isPresent = record.status.toLowerCase() == 'present';
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              
              // Status icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isPresent 
                      ? Colors.green.shade50 
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPresent 
                      ? Icons.check_circle 
                      : Icons.cancel,
                  color: isPresent 
                      ? Colors.green 
                      : Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              
              // Status text
              Text(
                isPresent ? 'Present' : 'Absent',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPresent 
                      ? Colors.green.shade800 
                      : Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 24),
              
              // Details
              _buildDetailRow('Course', record.courseName),
              _buildDetailRow('Lecture', record.lectureName),
              _buildDetailRow('Date', record.date),
              _buildDetailRow('Time', record.time),
              _buildDetailRow('Student ID', record.studentId.toString()),
              
              const SizedBox(height: 24),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 