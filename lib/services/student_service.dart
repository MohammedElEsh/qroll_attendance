import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_record.dart';

class StudentService {
  // Singleton instance
  static final StudentService _instance = StudentService._internal();

  // Factory constructor to return the singleton instance
  factory StudentService() => _instance;

  // Private constructor for singleton pattern
  StudentService._internal();

  // HTTP client for API requests
  final Dio _dio = Dio();

  // Storage key for auth token
  static const String tokenKey = 'auth_token';

  // Configurable base URL
  String baseUrl = 'https://azure-hawk-973666.hostingersite.com/api';

  /// Configure the base URL for the API
  void configureBaseUrl(String url) {
    baseUrl = url;
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Get all students
  /// Requires admin privileges
  Future<Response> getAllStudents() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/admin/students',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get student by ID
  /// Requires admin privileges
  Future<Response> getStudentById(int id) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/admin/students/$id',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Create a new student
  /// Requires admin privileges
  Future<Response> createStudent(Map<String, dynamic> data) async {
    try {
      final token = await getToken();

      // Convert data to FormData
      final formData = FormData.fromMap({
        'name': data['name'],
        'email': data['email'],
        'phone': data['phone'],
        'password': data['password'],
        'national_id': data['national_id'],
        'academic_id': data['academic_id'],
      });

      final response = await _dio.post(
        '$baseUrl/admin/students',
        data: formData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Update an existing student
  /// Requires admin privileges
  Future<Response> updateStudent(int id, Map<String, dynamic> data) async {
    try {
      final token = await getToken();

      // Create FormData with _method=PUT for Laravel-style updates
      final formData = FormData();
      formData.fields.add(MapEntry('_method', 'PUT'));

      // Add all data fields
      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      final response = await _dio.post(
        '$baseUrl/admin/students/$id',
        data: formData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Delete a student
  /// Requires admin privileges
  Future<Response> deleteStudent(int id) async {
    try {
      final token = await getToken();
      final response = await _dio.delete(
        '$baseUrl/admin/students/$id',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get courses for a specific student
  /// Requires admin privileges
  Future<Response> getStudentCourses(int id) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/admin/students/$id/courses',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get student lecture attendance for a course
  /// Requires student privileges
  Future<Response> getStudentLectureAttendance(int courseId) async {
    try {
      final token = await getToken();
      print('StudentService: Token exists: ${token != null}');
      print('StudentService: Token length: ${token?.length ?? 0}');
      print(
        'StudentService: Making request to: $baseUrl/student/courses/$courseId/lectures-attendance',
      );

      final response = await _dio.get(
        '$baseUrl/student/courses/$courseId/lectures-attendance',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get student section attendance for a course
  /// Requires student privileges
  Future<Response> getStudentSectionAttendance(int courseId) async {
    try {
      final token = await getToken();
      print('StudentService: Section Token exists: ${token != null}');
      print('StudentService: Section Token length: ${token?.length ?? 0}');
      print(
        'StudentService: Making request to: $baseUrl/student/courses/$courseId/sections-attendance',
      );

      final response = await _dio.get(
        '$baseUrl/student/courses/$courseId/sections-attendance',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Scan attendance QR code
  /// Requires student privileges
  Future<Response> scanAttendance(Map<String, dynamic> data) async {
    try {
      final token = await getToken();

      // Convert data to FormData
      final formData = FormData.fromMap({
        'lecture_id': data['lecture_id'],
        'course_id': data['course_id'],
        'timestamp': data['timestamp'],
        'signature': data['signature'],
      });

      final response = await _dio.post(
        '$baseUrl/student/attendance/scan',
        data: formData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get all attendance records for the logged-in student
  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/student/attendance',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => AttendanceRecord.fromJson(json))
            .toList();
      } else if (response.statusCode == 200 && response.data['data'] is List) {
        // If API wraps data in a 'data' field
        return (response.data['data'] as List)
            .map((json) => AttendanceRecord.fromJson(json))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Handle errors in a consistent way
  void _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        final responseData = e.response?.data;
        final errorMessage =
            responseData is Map ? responseData['message'] : null;
        throw Exception(errorMessage ?? 'Request failed');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Server is taking too long to respond. Please try again later.',
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          'Request timeout. Please check your internet connection.',
        );
      } else {
        throw Exception(e.message ?? 'An error occurred');
      }
    } else {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
