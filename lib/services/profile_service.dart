import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService {
  // Singleton instance
  static final ProfileService _instance = ProfileService._internal();

  // Factory constructor to return the singleton instance
  factory ProfileService() => _instance;

  // Private constructor for singleton pattern
  ProfileService._internal();

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

  /// Get user profile with extensive debugging
  Future<UserProfile?> getProfile() async {
    try {

      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token != null) {
      }

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }


      // Configure Dio with debugging
      _dio.options.connectTimeout = const Duration(seconds: 30);
      _dio.options.receiveTimeout = const Duration(seconds: 30);

      // Add interceptor for debugging
      _dio.interceptors.clear();
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.next(options);
          },
          onResponse: (response, handler) {
            handler.next(response);
          },
          onError: (error, handler) {
            if (error.response != null) {
            }
            handler.next(error);
          },
        ),
      );

      final response = await _dio.get(
        '$baseUrl/profile',
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
          dynamic profileData;
          if (responseData.containsKey('data')) {
            profileData = responseData['data'];
          } else {
            profileData = responseData;
          }

          if (profileData != null && profileData is Map<String, dynamic>) {
            final profile = UserProfile.fromJson(profileData);
            return profile;
          } else {
            throw Exception('Invalid profile data structure');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load profile');
      }
    } catch (e) {

      if (e is DioException) {
      }

      _handleError(e);
      rethrow;
    }
  }

  /// Test connection to API
  Future<void> testConnection() async {
    try {
    // ignore: empty_catches
    } catch (e) {
    }
  }

  /// Check if token exists and is valid format
  Future<Map<String, dynamic>> debugToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    return {
      'exists': token != null,
      'length': token?.length ?? 0,
      'preview': token != null && token.length > 10
          ? '${token.substring(0, 10)}...'
          : token,
      'isEmpty': token?.isEmpty ?? true,
    };
  }

  /// Get user profile with explicit token (for testing)
  Future<Response> getProfileWithToken(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Update user profile
  Future<Response> updateProfile({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Convert data to FormData
      final formData = FormData();

      // Add text fields
      if (data.containsKey('name')) {
        formData.fields.add(MapEntry('name', data['name']));
      }
      if (data.containsKey('email')) {
        formData.fields.add(MapEntry('email', data['email']));
      }
      if (data.containsKey('phone')) {
        formData.fields.add(MapEntry('phone', data['phone']));
      }
      if (data.containsKey('national_id')) {
        formData.fields.add(MapEntry('national_id', data['national_id']));
      }
      if (data.containsKey('birth_date')) {
        formData.fields.add(MapEntry('birth_date', data['birth_date']));
      }
      if (data.containsKey('address')) {
        formData.fields.add(MapEntry('address', data['address']));
      }

      // Add image if provided
      if (data.containsKey('image') && data['image'] != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              data['image'],
              filename: data['image'].split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        '$baseUrl/profile/update',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response;
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