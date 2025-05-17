/// Authentication service that handles user login, logout, and password management.
/// Manages JWT tokens and user credentials using secure storage.
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // HTTP client for API requests
  final Dio _dio = Dio();
  
  // Secure storage for sensitive data
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API endpoints
  static const String baseUrl = 'https://api.qrollattendance.com/api';
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String resetPasswordEndpoint = '/reset-password';

  // Secure storage keys
  static const String tokenKey = 'jwt_token';
  static const String userIdKey = 'user_id';
  static const String roleIdKey = 'role_id';

  /// Authenticates user with email, password, and role ID
  /// Returns user data and stores authentication token
  Future<Map<String, dynamic>> login(
    String email,
    String password,
    int roleId,
  ) async {
    try {
      final response = await _dio.post(
        baseUrl + loginEndpoint,
        data: {'email': email, 'password': password, 'role_id': roleId},
      );

      if (response.statusCode == 200) {
        // Store authentication data securely
        final String token = response.data['data']['token'];
        final int userId = response.data['data']['user']['id'];

        await _secureStorage.write(key: tokenKey, value: token);
        await _secureStorage.write(key: userIdKey, value: userId.toString());
        await _secureStorage.write(key: roleIdKey, value: roleId.toString());

        return response.data;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Logs out the user and clears stored credentials
  /// Returns true if logout was successful
  Future<bool> logout() async {
    try {
      final token = await _secureStorage.read(key: tokenKey);

      final response = await _dio.post(
        baseUrl + logoutEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Clear all stored credentials
        await _secureStorage.deleteAll();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Clear tokens even if API call fails
      await _secureStorage.deleteAll();
      return false;
    }
  }

  /// Resets user password with old and new password
  /// Returns true if password reset was successful
  Future<bool> resetPassword(String oldPassword, String newPassword) async {
    try {
      final token = await _secureStorage.read(key: tokenKey);

      final response = await _dio.post(
        baseUrl + resetPasswordEndpoint,
        data: {'old_password': oldPassword, 'new_password': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }

  /// Changes user password with new password only
  /// Returns true if password change was successful
  Future<bool> changePassword(String newPassword) async {
    try {
      final token = await _secureStorage.read(key: tokenKey);

      final response = await _dio.post(
        baseUrl + resetPasswordEndpoint,
        data: {'password': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Password change error: $e');
    }
  }

  /// Checks if user is currently logged in
  /// Returns true if valid token exists
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Gets the user's role ID from secure storage
  /// Returns role ID if available, null otherwise
  Future<int?> getUserRoleId() async {
    final roleId = await _secureStorage.read(key: roleIdKey);
    return roleId != null ? int.parse(roleId) : null;
  }

  /// Gets the stored authentication token
  /// Returns token if available, null otherwise
  Future<String?> getToken() async {
    return await _secureStorage.read(key: tokenKey);
  }
}
