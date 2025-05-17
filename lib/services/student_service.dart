/// Student service that manages student-related operations.
/// Provides functionality for CRUD operations on students and their attendance records.
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/student.dart';
import '../models/attendance_record.dart';
import 'auth_service.dart';

class StudentService {
  // HTTP client for API requests
  final Dio _dio = Dio();
  // Secure storage for authentication tokens
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // API endpoints
  static const String baseUrl = 'https://api.qrollattendance.com/api';
  static const String studentsEndpoint = '/students';

  /// Fetches all students from the API
  /// Returns a list of Student objects
  Future<List<Student>> getStudents() async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.get(
        baseUrl + studentsEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data['data'];
        return studentsData.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get students');
      }
    } catch (e) {
      throw Exception('Students fetch error: $e');
    }
  }

  /// Fetches a single student by their ID
  /// Returns a Student object
  Future<Student> getStudent(int id) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.get(
        '${baseUrl}${studentsEndpoint}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Student.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get student');
      }
    } catch (e) {
      throw Exception('Student fetch error: $e');
    }
  }

  /// Creates a new student with the provided information
  /// Returns the created Student object
  Future<Student> createStudent({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String nationalId,
    required String academicId,
  }) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.post(
        baseUrl + studentsEndpoint,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'national_id': nationalId,
          'academic_id': academicId,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return Student.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create student');
      }
    } catch (e) {
      throw Exception('Student creation error: $e');
    }
  }

  /// Updates an existing student's information
  /// Returns the updated Student object
  Future<Student> updateStudent({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String academicId,
  }) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.post(
        '${baseUrl}${studentsEndpoint}/$id',
        data: {
          '_method': 'PUT',
          'name': name,
          'email': email,
          'phone': phone,
          'national_id': nationalId,
          'academic_id': academicId,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Student.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update student');
      }
    } catch (e) {
      throw Exception('Student update error: $e');
    }
  }

  /// Deletes a student by their ID
  /// Returns true if deletion was successful
  Future<bool> deleteStudent(int id) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.delete(
        '${baseUrl}${studentsEndpoint}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Student deletion error: $e');
    }
  }

  /// Fetches attendance records for the current student
  /// Returns a list of AttendanceRecord objects
  Future<List<AttendanceRecord>> getAttendanceRecords() async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.get(
        '${baseUrl}/attendance',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> recordsData = response.data['data'];
        return recordsData
            .map((json) => AttendanceRecord.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to get attendance records');
      }
    } catch (e) {
      throw Exception('Attendance records fetch error: $e');
    }
  }

  /// Submits attendance using QR code data
  /// Returns the response data from the server
  Future<Map<String, dynamic>> submitQRAttendance(String qrData) async {
    try {
      final token = await _secureStorage.read(key: AuthService.tokenKey);

      final response = await _dio.post(
        '${baseUrl}/attendance/scan',
        data: {'qr_data': qrData},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to submit attendance');
      }
    } catch (e) {
      throw Exception('Attendance submission error: $e');
    }
  }
}
