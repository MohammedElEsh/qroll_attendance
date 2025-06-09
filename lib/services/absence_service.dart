// / Absence service for tracking student attendance and absences.
// / Handles excessive absence tracking for lectures and sections.

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenceService {
  // Singleton instance
  static final AbsenceService _instance = AbsenceService._internal();

  // Factory constructor to return the singleton instance
  factory AbsenceService() => _instance;

  // Private constructor for singleton pattern
  AbsenceService._internal();

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

  /// Get students with excessive lecture absences for a course
  /// GET /courses/{courseId}/excessive-absence/lectures
  Future<Response> getExcessiveLectureAbsences(int courseId) async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/courses/$courseId/excessive-absence/lectures',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get students with excessive section absences for a course
  /// GET /courses/{courseId}/excessive-absence/sections
  Future<Response> getExcessiveSectionAbsences(int courseId) async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/courses/$courseId/excessive-absence/sections',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get attendance records for a specific lecture in a course
  /// GET /courses/{courseId}/lectures/{lectureId}/attendance
  Future<Response> getLectureAttendance(int courseId, int lectureId) async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/courses/$courseId/lectures/$lectureId/attendance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get attendance records for a specific section in a course
  /// GET /courses/{courseId}/sections/{sectionId}/attendance
  Future<Response> getSectionAttendance(int courseId, int sectionId) async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/courses/$courseId/sections/$sectionId/attendance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
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
