import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AbsenceService {
  // Singleton instance
  static final AbsenceService _instance = AbsenceService._internal();

  // Factory constructor to return the singleton instance
  factory AbsenceService() => _instance;

  // Private constructor for singleton pattern
  AbsenceService._internal();

  // HTTP client for API requests
  final Dio _dio = Dio();
  
  // Secure storage for tokens
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Storage key for auth token
  static const String tokenKey = 'auth_token';
  
  // Configurable base URL
  String baseUrl = 'https://api.qrollattendance.com/api';
  
  /// Configure the base URL for the API
  void configureBaseUrl(String url) {
    baseUrl = url;
  }
  
  /// Get the stored authentication token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: tokenKey);
  }

  /// Get students with excessive lecture absences for a course
  Future<Response> getExcessiveLectureAbsences(int courseId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/courses/$courseId/excessive-absence/lectures',
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

  /// Get students with excessive section absences for a course
  Future<Response> getExcessiveSectionAbsences(int courseId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/courses/$courseId/excessive-absence/sections',
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

  /// Get attendance records for a specific lecture in a course
  Future<Response> getLectureAttendance(int courseId, int lectureId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/courses/$courseId/lectures/$lectureId/attendance',
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

  /// Get attendance records for a specific section in a course
  Future<Response> getSectionAttendance(int courseId, int sectionId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/courses/$courseId/sections/$sectionId/attendance',
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
  
  /// Handle errors in a consistent way
  void _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        final responseData = e.response?.data;
        final errorMessage = responseData is Map ? responseData['message'] : null;
        throw Exception(errorMessage ?? 'Request failed');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is taking too long to respond. Please try again later.');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('Request timeout. Please check your internet connection.');
      } else {
        throw Exception(e.message ?? 'An error occurred');
      }
    } else {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
