// / Course Service for handling course and statistics related API calls.
// / Provides methods to fetch student courses and statistics data.

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/student_statistics.dart';

class CourseService {
  // Singleton instance
  static final CourseService _instance = CourseService._internal();

  // Factory constructor to return the singleton instance
  factory CourseService() => _instance;

  // Private constructor for singleton pattern
  CourseService._internal();

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

  /// Get student's courses
  /// Returns a list of courses enrolled by the student
  Future<List<Course>> getMyCourses() async {
    try {
      // Get token from SharedPreferences
      final token = await getToken();

      print('CourseService: Token exists: ${token != null}');
      print('CourseService: Token length: ${token?.length ?? 0}');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      print('CourseService: Making request to: $baseUrl/my-courses');

      final response = await _dio.get(
        '$baseUrl/my-courses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Debug: Print response details
      print('CourseService: Response status: ${response.statusCode}');
      print('CourseService: Response data type: ${response.data.runtimeType}');
      print(
        'CourseService: Response data length: ${response.data is List ? response.data.length : 'N/A'}',
      );
      print('CourseService: Response data: ${response.data}');

      // Check if response is successful
      if (response.statusCode == 200) {
        final responseData = response.data;

        // Handle direct array response (your API format)
        if (responseData is List) {
          // Direct array of courses
          return responseData
              .map((courseJson) => Course.fromJson(courseJson))
              .toList();
        }
        // Handle different response structures
        else if (responseData is Map<String, dynamic>) {
          // Check for status field
          if (responseData.containsKey('status')) {
            final status = responseData['status'];

            // Handle different status types
            bool isSuccess = false;
            if (status is bool) {
              isSuccess = status;
            } else if (status is String) {
              isSuccess = status.toLowerCase() == 'true' || status == '1';
            } else if (status is int) {
              isSuccess = status == 1;
            }

            if (!isSuccess) {
              final message = responseData['message'] ?? 'Request failed';
              throw Exception(message);
            }
          }

          // Extract data
          dynamic coursesData;
          if (responseData.containsKey('data')) {
            coursesData = responseData['data'];
          } else if (responseData.containsKey('courses')) {
            coursesData = responseData['courses'];
          } else {
            coursesData = responseData;
          }

          if (coursesData != null) {
            if (coursesData is List) {
              // Convert list of courses
              return coursesData
                  .map((courseJson) => Course.fromJson(courseJson))
                  .toList();
            } else if (coursesData is Map<String, dynamic> &&
                coursesData.containsKey('courses')) {
              // Handle nested structure
              final coursesList = coursesData['courses'];
              if (coursesList is List) {
                return coursesList
                    .map((courseJson) => Course.fromJson(courseJson))
                    .toList();
              }
            }
          }

          // If no courses found, return empty list
          return [];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load courses');
      }
    } catch (e) {
      print('CourseService: Error occurred: $e');
      print('CourseService: Error type: ${e.runtimeType}');
      _handleError(e);
      rethrow;
    }
  }

  /// Get student's statistics
  /// Returns comprehensive statistics about the student's academic performance
  Future<StudentStatistics?> getMyStatistics() async {
    try {
      // Get token from SharedPreferences
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/my-statistics',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Check if response is successful
      if (response.statusCode == 200) {
        final responseData = response.data;

        // Handle different response structures
        if (responseData is Map<String, dynamic>) {
          // Check for status field
          if (responseData.containsKey('status')) {
            final status = responseData['status'];

            // Handle different status types
            bool isSuccess = false;
            if (status is bool) {
              isSuccess = status;
            } else if (status is String) {
              isSuccess = status.toLowerCase() == 'true' || status == '1';
            } else if (status is int) {
              isSuccess = status == 1;
            }

            if (!isSuccess) {
              final message = responseData['message'] ?? 'Request failed';
              throw Exception(message);
            }
          }

          // Extract data
          dynamic statisticsData;
          if (responseData.containsKey('data')) {
            statisticsData = responseData['data'];
          } else if (responseData.containsKey('statistics')) {
            statisticsData = responseData['statistics'];
          } else {
            statisticsData = responseData;
          }

          if (statisticsData != null &&
              statisticsData is Map<String, dynamic>) {
            return StudentStatistics.fromJson(statisticsData);
          } else {
            throw Exception('Invalid statistics data structure');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: Failed to load statistics',
        );
      }
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get courses with raw response (for debugging)
  /// Returns the full response for flexibility
  Future<Response> getMyCoursesRaw() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        '$baseUrl/my-courses',
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

  /// Get statistics with raw response (for debugging)
  /// Returns the full response for flexibility
  Future<Response> getMyStatisticsRaw() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        '$baseUrl/my-statistics',
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

  /// Test connection to API
  Future<void> testConnection() async {
    try {
      final response = await _dio.get('$baseUrl/health');
      if (response.statusCode != 200) {
        throw Exception('API connection test failed');
      }
    } catch (e) {
      // Connection test failed, but don't throw error
      // This is just for debugging purposes
    }
  }

  /// Check if token exists and is valid format
  Future<Map<String, dynamic>> debugToken() async {
    final token = await getToken();

    return {
      'exists': token != null,
      'length': token?.length ?? 0,
      'preview':
          token != null && token.length > 10
              ? '${token.substring(0, 10)}...'
              : token,
      'isEmpty': token?.isEmpty ?? true,
    };
  }

  /// Get course by ID
  /// Returns a specific course by its ID
  Future<Course?> getCourseById(String courseId) async {
    try {
      final courses = await getMyCourses();
      return courses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => throw Exception('Course not found'),
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get active courses only
  /// Returns only courses that are currently active
  Future<List<Course>> getActiveCourses() async {
    try {
      final courses = await getMyCourses();
      return courses.where((course) => course.isActive).toList();
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get courses with low attendance
  /// Returns courses where attendance is below the specified threshold
  Future<List<Course>> getCoursesWithLowAttendance({
    double threshold = 75.0,
  }) async {
    try {
      final courses = await getMyCourses();
      return courses.where((course) {
        return course.attendancePercentage != null &&
            course.attendancePercentage! < threshold;
      }).toList();
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Handle errors and provide clean error messages
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
