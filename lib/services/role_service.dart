/// Role service that manages user role information.
/// Provides functionality to fetch available roles from the API.
library;
import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RoleService {
  // HTTP client for API requests
  final Dio _dio = Dio();
  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API endpoints
  static const String baseUrl = 'https://api.qrollattendance.com/api';
  static const String rolesEndpoint = '/roles';

  /// Fetches all available roles from the API
  /// Returns a list of Role objects
  Future<List<Role>> getRoles() async {
    try {
      final response = await _dio.get(baseUrl + rolesEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> rolesData = response.data['data'];
        return rolesData.map((json) => Role.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get roles');
      }
    } catch (e) {
      throw Exception('Roles fetch error: $e');
    }
  }
}

/// Model class representing a user role
class Role {
  /// Unique identifier for the role
  final int id;

  /// Name of the role (e.g., "Student", "Teacher")
  final String name;

  /// Timestamp when the role was created
  final String createdAt;

  /// Timestamp when the role was last updated
  final String updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a Role instance from JSON data
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// Converts the Role instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
