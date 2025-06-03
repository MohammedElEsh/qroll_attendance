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

  /// Get user profile
  /// Automatically retrieves token from shared preferences
  Future<UserProfile?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get(
        '$baseUrl/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Get user profile with explicit token
  /// For backward compatibility
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
  /// Requires authentication token and profile data
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
