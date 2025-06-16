import 'dart:convert';

/// Helper class for testing QR Scanner functionality
/// This class provides utilities to test QR code generation and validation
class QRTestHelper {
  /// Generate a test QR code with valid format
  static String generateTestQRCode({
    int lectureId = 122,
    int courseId = 4,
    int? timestamp,
    String signature =
        '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
  }) {
    final qrData = {
      'lecture_id': lectureId,
      'course_id': courseId,
      'timestamp': timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'signature': signature,
    };

    return jsonEncode(qrData);
  }

  /// Generate a working QR code (based on successful API test)
  static String generateWorkingQRCode() {
    final qrData = {
      'lecture_id': 122,
      'course_id': 4,
      'timestamp': 1749930959,
      'signature':
          '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
    };

    return jsonEncode(qrData);
  }

  /// Generate a failing QR code (based on failed API test)
  static String generateFailingQRCode() {
    final qrData = {
      'lecture_id': 3,
      'course_id': 5,
      'timestamp': 1748440148,
      'signature':
          '93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4b2c34094a17',
    };

    return jsonEncode(qrData);
  }

  /// Validate QR code format
  static bool validateQRCode(String qrCode) {
    try {
      final data = jsonDecode(qrCode);

      if (data is! Map<String, dynamic>) return false;

      // Check required fields
      final requiredFields = [
        'lecture_id',
        'course_id',
        'timestamp',
        'signature',
      ];
      for (final field in requiredFields) {
        if (!data.containsKey(field) || data[field] == null) {
          return false;
        }
      }

      // Validate data types
      if (data['lecture_id'] is! int) return false;
      if (data['course_id'] is! int) return false;
      if (data['timestamp'] is! int) return false;
      if (data['signature'] is! String) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if QR code is expired (older than 1 hour)
  static bool isQRCodeExpired(String qrCode) {
    try {
      final data = jsonDecode(qrCode);
      if (data is! Map<String, dynamic>) return true;

      final timestamp = data['timestamp'] as int?;
      if (timestamp == null) return true;

      final qrTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final now = DateTime.now();
      final difference = now.difference(qrTime).inMinutes;

      return difference > 60; // Expired if older than 1 hour
    } catch (e) {
      return true;
    }
  }

  /// Parse QR code data
  static Map<String, dynamic>? parseQRCode(String qrCode) {
    try {
      final data = jsonDecode(qrCode);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Generate test QR codes for different scenarios
  static Map<String, String> getTestQRCodes() {
    return {
      'valid_working': generateWorkingQRCode(),
      'valid_failing': generateFailingQRCode(),
      'valid_new': generateTestQRCode(),
      'expired': generateTestQRCode(
        timestamp:
            DateTime.now()
                .subtract(const Duration(hours: 2))
                .millisecondsSinceEpoch ~/
            1000,
      ),
      'invalid_json': 'not-a-json-string',
      'missing_fields': jsonEncode({'lecture_id': 3}),
      'wrong_types': jsonEncode({
        'lecture_id': 'not-a-number',
        'course_id': 5,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'signature': '93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4',
      }),
    };
  }

  /// Test all QR code scenarios
  static Map<String, bool> testAllScenarios() {
    final testCodes = getTestQRCodes();
    final results = <String, bool>{};

    for (final entry in testCodes.entries) {
      final scenario = entry.key;
      final qrCode = entry.value;

      switch (scenario) {
        case 'valid_working':
        case 'valid_failing':
        case 'valid_new':
          results[scenario] =
              validateQRCode(qrCode) && !isQRCodeExpired(qrCode);
          break;
        case 'expired':
          results[scenario] = validateQRCode(qrCode) && isQRCodeExpired(qrCode);
          break;
        case 'invalid_json':
        case 'missing_fields':
        case 'wrong_types':
          results[scenario] = !validateQRCode(qrCode);
          break;
      }
    }

    return results;
  }

  /// Print test results
  static void printTestResults() {
    print('\n🧪 QR Scanner Test Results:');
    print('=' * 40);

    final results = testAllScenarios();

    for (final entry in results.entries) {
      final scenario = entry.key;
      final passed = entry.value;
      final icon = passed ? '✅' : '❌';

      print('$icon $scenario: ${passed ? 'PASSED' : 'FAILED'}');
    }

    final allPassed = results.values.every((result) => result);
    print('=' * 40);
    print(allPassed ? '🎉 All tests PASSED!' : '⚠️ Some tests FAILED!');

    if (allPassed) {
      print('✅ QR Scanner is ready for attendance scanning!');
      print(
        '✅ Students will be marked as PRESENT when scanning valid QR codes!',
      );
    }
  }

  /// Get API request format for a QR code (FormData with 'data' field)
  static Map<String, String>? getAPIRequestFormat(String qrCode) {
    final data = parseQRCode(qrCode);
    if (data == null) return null;

    // Return as FormData format with 'data' field containing JSON string
    final jsonString = jsonEncode({
      'lecture_id': data['lecture_id'],
      'course_id': data['course_id'],
      'timestamp': data['timestamp'],
      'signature': data['signature'],
    });

    return {'data': jsonString};
  }

  /// Get API request format as JSON (for direct JSON requests)
  static Map<String, dynamic>? getAPIRequestFormatAsJSON(String qrCode) {
    final data = parseQRCode(qrCode);
    if (data == null) return null;

    return {
      'lecture_id': data['lecture_id'],
      'course_id': data['course_id'],
      'timestamp': data['timestamp'],
      'signature': data['signature'],
    };
  }

  /// Get the JSON string that goes in the 'data' field
  static String? getDataFieldContent(String qrCode) {
    final data = parseQRCode(qrCode);
    if (data == null) return null;

    return jsonEncode({
      'lecture_id': data['lecture_id'],
      'course_id': data['course_id'],
      'timestamp': data['timestamp'],
      'signature': data['signature'],
    });
  }

  /// Simulate API response for testing
  static Map<String, dynamic> simulateAPIResponse({
    bool success = true,
    String? message,
    Map<String, dynamic>? additionalData,
  }) {
    if (success) {
      return {
        'message': message ?? 'Attendance recorded',
        'student': {'id': 7, 'name': 'student2', 'email': 'student2@gmail.com'},
        'attendance_status': 'true',
        ...?additionalData,
      };
    } else {
      return {'message': message ?? 'Invalid QR data', ...?additionalData};
    }
  }

  /// Simulate successful API response (based on real API)
  static Map<String, dynamic> simulateSuccessfulResponse() {
    return {
      'message': 'Attendance recorded',
      'student': {'id': 7, 'name': 'student2', 'email': 'student2@gmail.com'},
      'attendance_status': 'true',
    };
  }

  /// Simulate failed API response (based on real API)
  static Map<String, dynamic> simulateFailedResponse() {
    return {'message': 'Invalid QR data'};
  }
}
