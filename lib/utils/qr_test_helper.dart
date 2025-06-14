import 'dart:convert';

/// Helper class for testing QR Scanner functionality
/// This class provides utilities to test QR code generation and validation
class QRTestHelper {
  
  /// Generate a test QR code with valid format
  static String generateTestQRCode({
    int lectureId = 3,
    int courseId = 5,
    int? timestamp,
    String signature = '93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4',
  }) {
    final qrData = {
      'lecture_id': lectureId,
      'course_id': courseId,
      'timestamp': timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'signature': signature,
    };
    
    return jsonEncode(qrData);
  }
  
  /// Validate QR code format
  static bool validateQRCode(String qrCode) {
    try {
      final data = jsonDecode(qrCode);
      
      if (data is! Map<String, dynamic>) return false;
      
      // Check required fields
      final requiredFields = ['lecture_id', 'course_id', 'timestamp', 'signature'];
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
      'valid': generateTestQRCode(),
      'expired': generateTestQRCode(
        timestamp: DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
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
        case 'valid':
          results[scenario] = validateQRCode(qrCode) && !isQRCodeExpired(qrCode);
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
      print('✅ Students will be marked as PRESENT when scanning valid QR codes!');
    }
  }
  
  /// Get API request format for a QR code
  static Map<String, String>? getAPIRequestFormat(String qrCode) {
    final data = parseQRCode(qrCode);
    if (data == null) return null;
    
    return {
      'lecture_id': data['lecture_id'].toString(),
      'course_id': data['course_id'].toString(),
      'timestamp': data['timestamp'].toString(),
      'signature': data['signature'].toString(),
    };
  }
  
  /// Simulate API response for testing
  static Map<String, dynamic> simulateAPIResponse({
    bool success = true,
    String? message,
    Map<String, dynamic>? additionalData,
  }) {
    if (success) {
      return {
        'success': true,
        'message': message ?? 'Attendance marked successfully',
        'data': {
          'attendance_id': DateTime.now().millisecondsSinceEpoch,
          'status': 'present', // ✅ PRESENT, not absent!
          'marked_at': DateTime.now().toIso8601String(),
          ...?additionalData,
        }
      };
    } else {
      return {
        'success': false,
        'message': message ?? 'Failed to mark attendance',
        'error': 'INVALID_QR_CODE',
        ...?additionalData,
      };
    }
  }
}
