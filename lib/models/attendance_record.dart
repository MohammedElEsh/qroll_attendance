class AttendanceRecord {
  final int id;
  final String date;
  final String time;
  final String status; // "present" or "absent"
  final String courseName;
  final String lectureName;
  final int studentId;
  final String createdAt;
  final String updatedAt;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.courseName,
    required this.lectureName,
    required this.studentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      courseName: json['course_name'],
      lectureName: json['lecture_name'],
      studentId: json['student_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'status': status,
      'course_name': courseName,
      'lecture_name': lectureName,
      'student_id': studentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
} 