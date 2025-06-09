/// Inbox service for messaging and notifications.
/// Handles sending messages, taking actions, and retrieving inbox data.
library;

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InboxService {
  // Singleton instance
  static final InboxService _instance = InboxService._internal();

  // Factory constructor to return the singleton instance
  factory InboxService() => _instance;

  // Private constructor for singleton pattern
  InboxService._internal();

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

  /// Send a message to another user (POST /inbox)
  Future<Response> sendMessage({
    required int receiverId,
    required String message,
  }) async {
    try {
      final token = await getToken();

      // Create form data
      final formData = FormData.fromMap({
        'receiver_id': receiverId,
        'message': message,
      });

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      };

      final response = await _dio.post(
        '$baseUrl/inbox',
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

  /// Take action on excessive absence (POST /take-action)
  Future<Response> takeAction({
    required String type, // 'lecture' or 'section'
    required double absencePercentage,
    required int courseId,
    required String message,
  }) async {
    try {
      final token = await getToken();

      // Create form data
      final formData = FormData.fromMap({
        'type': type,
        'absence_percentage': absencePercentage,
        'course_id': courseId,
        'message': message,
      });

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      };

      final response = await _dio.post(
        '$baseUrl/take-action',
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

  /// Get student inbox messages (GET /student/inbox)
  Future<Response> getInboxMessages() async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/student/inbox',
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

  /// Get specific inbox message (GET /student/inbox/{id})
  Future<Response> getInboxMessage(int messageId) async {
    try {
      final token = await getToken();

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      final response = await _dio.get(
        '$baseUrl/student/inbox/$messageId',
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
