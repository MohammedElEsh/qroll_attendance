/// Student Statistics Model
/// Simple model for dashboard statistics
class StudentStatistics {
  final int? coursesCount;

  const StudentStatistics({this.coursesCount});

  /// Factory constructor to create StudentStatistics from JSON
  factory StudentStatistics.fromJson(Map<String, dynamic> json) {
    return StudentStatistics(
      coursesCount:
          json['courses_count'] is int
              ? json['courses_count']
              : int.tryParse(json['courses_count']?.toString() ?? ''),
    );
  }

  /// Convert StudentStatistics to JSON format
  Map<String, dynamic> toJson() {
    return {'courses_count': coursesCount};
  }

  @override
  String toString() {
    return 'StudentStatistics{coursesCount: $coursesCount}';
  }
}
