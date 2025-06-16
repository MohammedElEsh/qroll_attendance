import 'package:flutter_test/flutter_test.dart';
import 'package:qroll_attendance/utils/qr_test_helper.dart';
import 'dart:convert';

/// Test file to verify QR Scanner fixes for API response handling
///
/// This test verifies that the QR scanner correctly handles:
/// 1. Working QR codes that return "Attendance recorded"
/// 2. Failing QR codes that return "Invalid QR data"
/// 3. Proper JSON format validation
void main() {
  group('QR Scanner API Response Fix Tests', () {
    test('should generate working QR code with correct format', () {
      // Arrange & Act
      final workingQR = QRTestHelper.generateWorkingQRCode();
      final parsedData = jsonDecode(workingQR);

      // Assert
      expect(parsedData['lecture_id'], equals(122));
      expect(parsedData['course_id'], equals(4));
      expect(parsedData['timestamp'], equals(1749930959));
      expect(
        parsedData['signature'],
        equals(
          '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
        ),
      );

      print('✅ Working QR Code: $workingQR');
    });

    test('should generate failing QR code with correct format', () {
      // Arrange & Act
      final failingQR = QRTestHelper.generateFailingQRCode();
      final parsedData = jsonDecode(failingQR);

      // Assert
      expect(parsedData['lecture_id'], equals(3));
      expect(parsedData['course_id'], equals(5));
      expect(parsedData['timestamp'], equals(1748440148));
      expect(
        parsedData['signature'],
        equals(
          '93c28f6c0928804b6f5d628b6e7b35aba3494b7273ca690fe81d4b2c34094a17',
        ),
      );

      print('❌ Failing QR Code: $failingQR');
    });

    test('should validate QR code format correctly', () {
      // Arrange
      final workingQR = QRTestHelper.generateWorkingQRCode();
      final failingQR = QRTestHelper.generateFailingQRCode();
      final invalidQR = 'invalid-json';

      // Act & Assert
      expect(QRTestHelper.validateQRCode(workingQR), isTrue);
      expect(QRTestHelper.validateQRCode(failingQR), isTrue);
      expect(QRTestHelper.validateQRCode(invalidQR), isFalse);
    });

    test('should simulate successful API response correctly', () {
      // Arrange & Act
      final successResponse = QRTestHelper.simulateSuccessfulResponse();

      // Assert
      expect(successResponse['message'], equals('Attendance recorded'));
      expect(successResponse['attendance_status'], equals('true'));
      expect(successResponse['student']['id'], equals(7));
      expect(successResponse['student']['name'], equals('student2'));

      print('✅ Success Response: $successResponse');
    });

    test('should simulate failed API response correctly', () {
      // Arrange & Act
      final failedResponse = QRTestHelper.simulateFailedResponse();

      // Assert
      expect(failedResponse['message'], equals('Invalid QR data'));
      expect(failedResponse.containsKey('attendance_status'), isFalse);
      expect(failedResponse.containsKey('student'), isFalse);

      print('❌ Failed Response: $failedResponse');
    });

    test('should determine success from API response correctly', () {
      // Test successful response detection
      final successResponse = QRTestHelper.simulateSuccessfulResponse();

      // Simulate the logic from QRScannerScreen
      bool success =
          successResponse['success'] == true ||
          successResponse['status'] == 'success' ||
          successResponse['status'] == true ||
          successResponse['status'] == 200 ||
          successResponse['attendance_status'] == 'true' ||
          successResponse['attendance_status'] == true ||
          (successResponse.containsKey('message') &&
              successResponse['message'].toString().toLowerCase().contains(
                'recorded',
              ));

      expect(
        success,
        isTrue,
        reason: 'Should detect success from attendance_status and message',
      );

      // Test failed response detection
      final failedResponse = QRTestHelper.simulateFailedResponse();

      success =
          failedResponse['success'] == true ||
          failedResponse['status'] == 'success' ||
          failedResponse['status'] == true ||
          failedResponse['status'] == 200 ||
          failedResponse['attendance_status'] == 'true' ||
          failedResponse['attendance_status'] == true ||
          (failedResponse.containsKey('message') &&
              failedResponse['message'].toString().toLowerCase().contains(
                'recorded',
              ));

      expect(
        success,
        isFalse,
        reason: 'Should detect failure from missing success indicators',
      );
    });

    test('should handle different QR code scenarios', () {
      // Arrange
      final testCodes = QRTestHelper.getTestQRCodes();

      // Act & Assert
      expect(testCodes.containsKey('valid_working'), isTrue);
      expect(testCodes.containsKey('valid_failing'), isTrue);
      expect(testCodes.containsKey('valid_new'), isTrue);
      expect(testCodes.containsKey('expired'), isTrue);
      expect(testCodes.containsKey('invalid_json'), isTrue);

      // Validate each scenario
      expect(QRTestHelper.validateQRCode(testCodes['valid_working']!), isTrue);
      expect(QRTestHelper.validateQRCode(testCodes['valid_failing']!), isTrue);
      expect(QRTestHelper.validateQRCode(testCodes['valid_new']!), isTrue);
      expect(QRTestHelper.validateQRCode(testCodes['invalid_json']!), isFalse);

      print('🧪 All test scenarios validated successfully');
    });
  });

  group('API Request Format Tests', () {
    test('should format API request correctly as FormData', () {
      // Arrange
      final qrCode = QRTestHelper.generateWorkingQRCode();

      // Act
      final apiFormat = QRTestHelper.getAPIRequestFormat(qrCode);

      // Assert
      expect(apiFormat, isNotNull);
      expect(apiFormat!.containsKey('data'), isTrue);

      // Parse the JSON string in the 'data' field
      final dataJson = jsonDecode(apiFormat['data']!);
      expect(dataJson['lecture_id'], equals(122));
      expect(dataJson['course_id'], equals(4));
      expect(dataJson['timestamp'], equals(1749930959));
      expect(
        dataJson['signature'],
        equals(
          '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
        ),
      );

      print('📡 API Request Format (FormData): $apiFormat');
    });

    test('should format API request correctly as JSON', () {
      // Arrange
      final qrCode = QRTestHelper.generateWorkingQRCode();

      // Act
      final apiFormat = QRTestHelper.getAPIRequestFormatAsJSON(qrCode);

      // Assert
      expect(apiFormat, isNotNull);
      expect(apiFormat!['lecture_id'], equals(122));
      expect(apiFormat['course_id'], equals(4));
      expect(apiFormat['timestamp'], equals(1749930959));
      expect(
        apiFormat['signature'],
        equals(
          '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
        ),
      );

      print('📡 API Request Format (JSON): $apiFormat');
    });

    test(
      'should demonstrate the difference between working and failing QR codes',
      () {
        // Test working QR code
        final workingQR = QRTestHelper.generateWorkingQRCode();
        final workingData = QRTestHelper.getAPIRequestFormat(workingQR);

        // Test failing QR code
        final failingQR = QRTestHelper.generateFailingQRCode();
        final failingData = QRTestHelper.getAPIRequestFormat(failingQR);

        print('✅ Working QR Data: $workingData');
        print('❌ Failing QR Data: $failingData');

        // Both should be valid format, but different data
        expect(workingData, isNotNull);
        expect(failingData, isNotNull);

        // Parse the JSON strings to compare
        final workingJson = jsonDecode(workingData!['data']!);
        final failingJson = jsonDecode(failingData!['data']!);

        expect(
          workingJson['lecture_id'],
          isNot(equals(failingJson['lecture_id'])),
        );
      },
    );
  });
}
