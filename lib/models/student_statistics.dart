/// Student Statistics Model
/// 
/// This model represents the student statistics data structure
/// and provides methods to convert from/to JSON format
class StudentStatistics {
  final String? studentId;
  final String? studentName;
  final String? academicId;
  final int? totalCourses;
  final int? activeCourses;
  final int? completedCourses;
  final double? overallAttendancePercentage;
  final int? totalSessions;
  final int? attendedSessions;
  final int? missedSessions;
  final int? totalCredits;
  final double? gpa;
  final String? academicStatus;
  final String? currentSemester;
  final String? academicYear;
  final List<CourseStatistic>? courseStatistics;
  final AttendanceTrend? attendanceTrend;
  final DateTime? lastUpdated;

  const StudentStatistics({
    this.studentId,
    this.studentName,
    this.academicId,
    this.totalCourses,
    this.activeCourses,
    this.completedCourses,
    this.overallAttendancePercentage,
    this.totalSessions,
    this.attendedSessions,
    this.missedSessions,
    this.totalCredits,
    this.gpa,
    this.academicStatus,
    this.currentSemester,
    this.academicYear,
    this.courseStatistics,
    this.attendanceTrend,
    this.lastUpdated,
  });

  /// Factory constructor to create StudentStatistics from JSON
  factory StudentStatistics.fromJson(Map<String, dynamic> json) {
    return StudentStatistics(
      studentId: json['student_id']?.toString(),
      studentName: json['student_name']?.toString(),
      academicId: json['academic_id']?.toString(),
      totalCourses: json['total_courses'] is int ? json['total_courses'] : int.tryParse(json['total_courses']?.toString() ?? ''),
      activeCourses: json['active_courses'] is int ? json['active_courses'] : int.tryParse(json['active_courses']?.toString() ?? ''),
      completedCourses: json['completed_courses'] is int ? json['completed_courses'] : int.tryParse(json['completed_courses']?.toString() ?? ''),
      overallAttendancePercentage: json['overall_attendance_percentage'] is double 
          ? json['overall_attendance_percentage'] 
          : double.tryParse(json['overall_attendance_percentage']?.toString() ?? ''),
      totalSessions: json['total_sessions'] is int ? json['total_sessions'] : int.tryParse(json['total_sessions']?.toString() ?? ''),
      attendedSessions: json['attended_sessions'] is int ? json['attended_sessions'] : int.tryParse(json['attended_sessions']?.toString() ?? ''),
      missedSessions: json['missed_sessions'] is int ? json['missed_sessions'] : int.tryParse(json['missed_sessions']?.toString() ?? ''),
      totalCredits: json['total_credits'] is int ? json['total_credits'] : int.tryParse(json['total_credits']?.toString() ?? ''),
      gpa: json['gpa'] is double ? json['gpa'] : double.tryParse(json['gpa']?.toString() ?? ''),
      academicStatus: json['academic_status']?.toString(),
      currentSemester: json['current_semester']?.toString(),
      academicYear: json['academic_year']?.toString(),
      courseStatistics: json['course_statistics'] != null
          ? (json['course_statistics'] as List)
              .map((item) => CourseStatistic.fromJson(item))
              .toList()
          : null,
      attendanceTrend: json['attendance_trend'] != null
          ? AttendanceTrend.fromJson(json['attendance_trend'])
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'])
          : null,
    );
  }

  /// Convert StudentStatistics to JSON format
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'academic_id': academicId,
      'total_courses': totalCourses,
      'active_courses': activeCourses,
      'completed_courses': completedCourses,
      'overall_attendance_percentage': overallAttendancePercentage,
      'total_sessions': totalSessions,
      'attended_sessions': attendedSessions,
      'missed_sessions': missedSessions,
      'total_credits': totalCredits,
      'gpa': gpa,
      'academic_status': academicStatus,
      'current_semester': currentSemester,
      'academic_year': academicYear,
      'course_statistics': courseStatistics?.map((item) => item.toJson()).toList(),
      'attendance_trend': attendanceTrend?.toJson(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Get formatted overall attendance percentage
  String get formattedOverallAttendance {
    if (overallAttendancePercentage == null) return 'N/A';
    return '${overallAttendancePercentage!.toStringAsFixed(1)}%';
  }

  /// Get overall attendance status
  String get overallAttendanceStatus {
    if (overallAttendancePercentage == null) return 'Unknown';
    if (overallAttendancePercentage! >= 75) return 'Good';
    if (overallAttendancePercentage! >= 50) return 'Warning';
    return 'Critical';
  }

  /// Get formatted GPA
  String get formattedGpa {
    if (gpa == null) return 'N/A';
    return gpa!.toStringAsFixed(2);
  }

  @override
  String toString() {
    return 'StudentStatistics{'
        'studentId: $studentId, '
        'overallAttendancePercentage: $overallAttendancePercentage, '
        'totalCourses: $totalCourses, '
        'gpa: $gpa'
        '}';
  }
}

/// Course Statistic Model for individual course performance
class CourseStatistic {
  final String? courseId;
  final String? courseName;
  final String? courseCode;
  final double? attendancePercentage;
  final int? totalSessions;
  final int? attendedSessions;
  final String? grade;
  final String? status;

  const CourseStatistic({
    this.courseId,
    this.courseName,
    this.courseCode,
    this.attendancePercentage,
    this.totalSessions,
    this.attendedSessions,
    this.grade,
    this.status,
  });

  factory CourseStatistic.fromJson(Map<String, dynamic> json) {
    return CourseStatistic(
      courseId: json['course_id']?.toString(),
      courseName: json['course_name']?.toString(),
      courseCode: json['course_code']?.toString(),
      attendancePercentage: json['attendance_percentage'] is double 
          ? json['attendance_percentage'] 
          : double.tryParse(json['attendance_percentage']?.toString() ?? ''),
      totalSessions: json['total_sessions'] is int ? json['total_sessions'] : int.tryParse(json['total_sessions']?.toString() ?? ''),
      attendedSessions: json['attended_sessions'] is int ? json['attended_sessions'] : int.tryParse(json['attended_sessions']?.toString() ?? ''),
      grade: json['grade']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'course_code': courseCode,
      'attendance_percentage': attendancePercentage,
      'total_sessions': totalSessions,
      'attended_sessions': attendedSessions,
      'grade': grade,
      'status': status,
    };
  }
}

/// Attendance Trend Model for tracking attendance over time
class AttendanceTrend {
  final List<MonthlyAttendance>? monthlyData;
  final String? trend; // 'improving', 'declining', 'stable'
  final double? trendPercentage;

  const AttendanceTrend({
    this.monthlyData,
    this.trend,
    this.trendPercentage,
  });

  factory AttendanceTrend.fromJson(Map<String, dynamic> json) {
    return AttendanceTrend(
      monthlyData: json['monthly_data'] != null
          ? (json['monthly_data'] as List)
              .map((item) => MonthlyAttendance.fromJson(item))
              .toList()
          : null,
      trend: json['trend']?.toString(),
      trendPercentage: json['trend_percentage'] is double 
          ? json['trend_percentage'] 
          : double.tryParse(json['trend_percentage']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_data': monthlyData?.map((item) => item.toJson()).toList(),
      'trend': trend,
      'trend_percentage': trendPercentage,
    };
  }
}

/// Monthly Attendance Model for trend analysis
class MonthlyAttendance {
  final String? month;
  final int? year;
  final double? attendancePercentage;
  final int? totalSessions;
  final int? attendedSessions;

  const MonthlyAttendance({
    this.month,
    this.year,
    this.attendancePercentage,
    this.totalSessions,
    this.attendedSessions,
  });

  factory MonthlyAttendance.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendance(
      month: json['month']?.toString(),
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? ''),
      attendancePercentage: json['attendance_percentage'] is double 
          ? json['attendance_percentage'] 
          : double.tryParse(json['attendance_percentage']?.toString() ?? ''),
      totalSessions: json['total_sessions'] is int ? json['total_sessions'] : int.tryParse(json['total_sessions']?.toString() ?? ''),
      attendedSessions: json['attended_sessions'] is int ? json['attended_sessions'] : int.tryParse(json['attended_sessions']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'attendance_percentage': attendancePercentage,
      'total_sessions': totalSessions,
      'attended_sessions': attendedSessions,
    };
  }
}
