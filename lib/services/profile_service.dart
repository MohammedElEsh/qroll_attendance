/// Profile service that handles user profile data management.
/// Provides functionality to fetch and update user profile information.
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_profile.dart';
import 'auth_service.dart';

class ProfileService {
  // HTTP client for API requests
  final Dio _dio = Dio();

  // Secure storage for authentication token
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API endpoints
  static const String baseUrl = 'https://api.qrollattendance.com/api';
  static const String profileEndpoint = '/profile';
  static const String updateProfileEndpoint = '/profile/update';

  /// Fetches the user's profile information from the API
  /// Returns a UserProfile object with user details
  Future<UserProfile> getProfile() async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.get(
        baseUrl + profileEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  /// Updates the user's profile information
  /// Accepts profile fields and optional image file
  /// Returns updated UserProfile object
  Future<UserProfile> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String birthDate,
    required String address,
    dynamic image,
  }) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      // Prepare form data with profile fields and optional image
      final data = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'national_id': nationalId,
        'birth_date': birthDate,
        'address': address,
        if (image != null) 'image': await MultipartFile.fromFile(image),
      });

      final response = await _dio.post(
        baseUrl + updateProfileEndpoint,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }
}
