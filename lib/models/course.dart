/// Course Model
///
/// This model represents the course data structure
/// and provides methods to convert from/to JSON format
class Course {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? instructor;
  final String? department;
  final String? doctorId;
  final String? teacherId;
  final int? credits;
  final String? semester;
  final String? academicYear;
  final String? schedule;
  final String? location;
  final int? totalSessions;
  final int? attendedSessions;
  final double? attendancePercentage;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Course({
    this.id,
    this.name,
    this.code,
    this.description,
    this.instructor,
    this.department,
    this.doctorId,
    this.teacherId,
    this.credits,
    this.semester,
    this.academicYear,
    this.schedule,
    this.location,
    this.totalSessions,
    this.attendedSessions,
    this.attendancePercentage,
    this.status,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to create Course from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      instructor: json['instructor']?.toString(),
      department: json['department']?.toString(),
      doctorId: json['doctor_id']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      credits:
          json['credits'] is int
              ? json['credits']
              : int.tryParse(json['credits']?.toString() ?? ''),
      semester: json['semester']?.toString(),
      academicYear: json['academic_year']?.toString(),
      schedule: json['schedule']?.toString(),
      location: json['location']?.toString(),
      totalSessions:
          json['total_sessions'] is int
              ? json['total_sessions']
              : int.tryParse(json['total_sessions']?.toString() ?? ''),
      attendedSessions:
          json['attended_sessions'] is int
              ? json['attended_sessions']
              : int.tryParse(json['attended_sessions']?.toString() ?? ''),
      attendancePercentage:
          json['attendance_percentage'] is double
              ? json['attendance_percentage']
              : double.tryParse(
                json['attendance_percentage']?.toString() ?? '',
              ),
      status: json['status']?.toString(),
      startDate:
          json['start_date'] != null
              ? DateTime.tryParse(json['start_date'])
              : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  /// Convert Course to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'instructor': instructor,
      'department': department,
      'doctor_id': doctorId,
      'teacher_id': teacherId,
      'credits': credits,
      'semester': semester,
      'academic_year': academicYear,
      'schedule': schedule,
      'location': location,
      'total_sessions': totalSessions,
      'attended_sessions': attendedSessions,
      'attendance_percentage': attendancePercentage,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of Course with updated fields
  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? instructor,
    String? department,
    String? doctorId,
    String? teacherId,
    int? credits,
    String? semester,
    String? academicYear,
    String? schedule,
    String? location,
    int? totalSessions,
    int? attendedSessions,
    double? attendancePercentage,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      department: department ?? this.department,
      doctorId: doctorId ?? this.doctorId,
      teacherId: teacherId ?? this.teacherId,
      credits: credits ?? this.credits,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      schedule: schedule ?? this.schedule,
      location: location ?? this.location,
      totalSessions: totalSessions ?? this.totalSessions,
      attendedSessions: attendedSessions ?? this.attendedSessions,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the course is active
  bool get isActive {
    return status?.toLowerCase() == 'active';
  }

  /// Get display name (fallback to code if name is not available)
  String get displayName {
    return name?.isNotEmpty == true ? name! : code ?? 'Unknown Course';
  }

  /// Get formatted attendance percentage
  String get formattedAttendancePercentage {
    if (attendancePercentage == null) return 'N/A';
    return '${attendancePercentage!.toStringAsFixed(1)}%';
  }

  /// Get attendance status based on percentage
  String get attendanceStatus {
    if (attendancePercentage == null) return 'Unknown';
    if (attendancePercentage! >= 75) return 'Good';
    if (attendancePercentage! >= 50) return 'Warning';
    return 'Critical';
  }

  /// Get attendance status color
  String get attendanceStatusColor {
    switch (attendanceStatus) {
      case 'Good':
        return 'green';
      case 'Warning':
        return 'orange';
      case 'Critical':
        return 'red';
      default:
        return 'grey';
    }
  }

  @override
  String toString() {
    return 'Course{'
        'id: $id, '
        'name: $name, '
        'code: $code, '
        'instructor: $instructor, '
        'attendancePercentage: $attendancePercentage'
        '}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.instructor == instructor;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, code, instructor);
  }
}
