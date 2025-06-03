import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InboxService {
  // Singleton instance
  static final InboxService _instance = InboxService._internal();

  // Factory constructor to return the singleton instance
  factory InboxService() => _instance;

  // Private constructor for singleton pattern
  InboxService._internal();

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

  /// Send a message to another user
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

  /// Take action on excessive absence
  Future<Response> takeAction({
    required String type,
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
