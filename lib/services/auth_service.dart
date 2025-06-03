// / Authentication service for student users.
// / Handles login, logout, password reset, and password change operations.

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  // Factory constructor to return the singleton instance
  factory AuthService() => _instance;

  // Private constructor for singleton pattern
  AuthService._internal();

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

  /// Login with email, password and role ID
  /// Returns the full response for flexibility
  Future<Response> login({
    required String email,
    required String password,
    required int roleId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'role_id': roleId,
      });

      // Configure Dio with timeout and headers
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      };

      final response = await _dio.post('$baseUrl/login', data: formData);

      // Handle different response structures and store token
      if (response.statusCode == 200) {
        String? token;
        bool hasStatus = false;
        bool statusValue = false;

        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;

          // Check status field
          if (data.containsKey('status')) {
            hasStatus = true;
            statusValue =
                data['status'] == true ||
                data['status'] == 'true' ||
                data['status'] == 1;
          }

          // Extract token from different possible locations
          if (data.containsKey('token')) {
            token = data['token'];
          } else if (data.containsKey('data') && data['data'] is Map) {
            final nestedData = data['data'] as Map<String, dynamic>;
            if (nestedData.containsKey('token')) {
              token = nestedData['token'];
            }
          } else if (data.containsKey('access_token')) {
            token = data['access_token'];
          }
        }

        // Store token if found and status is successful (or no status field exists)
        if (token != null && (!hasStatus || statusValue)) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(tokenKey, token);
        }
      }

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Logout the current user
  Future<Response> logout({
    required String email,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({'email': email, 'password': password});

      final response = await _dio.post('$baseUrl/logout', data: formData);

      // If successful, remove the stored token
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(tokenKey);
      }

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Reset password with old and new password
  Future<Response> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final formData = FormData.fromMap({
        'old_password': oldPassword,
        'new_password': newPassword,
      });

      final response = await _dio.post(
        '$baseUrl/reset-password',
        data: formData,
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Change password with new password
  Future<Response> changePassword({required String newPassword}) async {
    try {
      final formData = FormData.fromMap({'password': newPassword});

      final response = await _dio.post(
        '$baseUrl/change-password',
        data: formData,
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Simple logout that just clears the stored token
  Future<void> logoutLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
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
