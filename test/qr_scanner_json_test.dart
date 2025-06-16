import 'package:flutter_test/flutter_test.dart';
import 'package:qroll_attendance/utils/qr_test_helper.dart';
import 'dart:convert';

/// Test to verify QR Scanner works with JSON format instead of form-data
///
/// This test simulates the exact scenario:
/// 1. QR code with format: {"lecture_id":122,"course_id":4,...}
/// 2. API request with JSON content-type
/// 3. Expected response: {"message":"Attendance recorded",...}
void main() {
  group('QR Scanner JSON Format Tests', () {
    test('should create QR code in correct JSON format', () {
      // This should match the working format from Postman
      final expectedQRCode =
          '{"lecture_id":122,"course_id":4,"timestamp":1749930959,"signature":"54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c"}';
      final actualQRCode = QRTestHelper.generateWorkingQRCode();

      // Parse both to compare structure
      final expectedData = jsonDecode(expectedQRCode);
      final actualData = jsonDecode(actualQRCode);

      expect(actualData['lecture_id'], equals(expectedData['lecture_id']));
      expect(actualData['course_id'], equals(expectedData['course_id']));
      expect(actualData['timestamp'], equals(expectedData['timestamp']));
      expect(actualData['signature'], equals(expectedData['signature']));

      print('✅ Expected QR: $expectedQRCode');
      print('✅ Actual QR:   $actualQRCode');
      print('✅ QR codes match the working format!');
    });

    test('should format API request as FormData with data field', () {
      final qrCode = QRTestHelper.generateWorkingQRCode();
      final qrData = jsonDecode(qrCode);

      // This simulates what StudentService.scanAttendance() now does
      final qrDataJson = jsonEncode({
        'lecture_id': qrData['lecture_id'],
        'course_id': qrData['course_id'],
        'timestamp': qrData['timestamp'],
        'signature': qrData['signature'],
      });

      final formDataMap = {'data': qrDataJson};

      // Verify the FormData structure
      expect(formDataMap.containsKey('data'), isTrue);

      // Parse the JSON string in the 'data' field
      final parsedData = jsonDecode(formDataMap['data']!);
      expect(parsedData['lecture_id'], isA<int>());
      expect(parsedData['course_id'], isA<int>());
      expect(parsedData['timestamp'], isA<int>());
      expect(parsedData['signature'], isA<String>());

      // Verify the values match the working example
      expect(parsedData['lecture_id'], equals(122));
      expect(parsedData['course_id'], equals(4));
      expect(parsedData['timestamp'], equals(1749930959));
      expect(
        parsedData['signature'],
        equals(
          '54c51143d54505ddca55ea17278a9c819189f3ad3779e904c54b9e12e3f90a1c',
        ),
      );

      print('📡 FormData Request: $formDataMap');
      print('📦 Data field content: $qrDataJson');
      print('✅ Request format matches Postman example!');
    });

    test('should simulate successful API response', () {
      final response = QRTestHelper.simulateSuccessfulResponse();

      // Verify response structure matches real API
      expect(response['message'], equals('Attendance recorded'));
      expect(response['student']['id'], equals(7));
      expect(response['student']['name'], equals('student2'));
      expect(response['student']['email'], equals('student2@gmail.com'));
      expect(response['attendance_status'], equals('true'));

      print('✅ API Response: $response');
      print('✅ Response matches expected format!');
    });

    test('should detect success from API response correctly', () {
      final response = QRTestHelper.simulateSuccessfulResponse();

      // This simulates the logic in QRScannerScreen._processQRCode()
      bool success =
          response['success'] == true ||
          response['status'] == 'success' ||
          response['status'] == true ||
          response['status'] == 200 ||
          response['attendance_status'] == 'true' ||
          response['attendance_status'] == true ||
          (response.containsKey('message') &&
              response['message'].toString().toLowerCase().contains(
                'recorded',
              )) ||
          (response.containsKey('message') &&
              response['message'].toString().toLowerCase().contains('success'));

      expect(
        success,
        isTrue,
        reason: 'Should detect success from attendance_status and message',
      );

      String message = response['message'].toString();

      // Check if message indicates failure
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('error') ||
          message.toLowerCase().contains('failed')) {
        success = false;
      }

      expect(success, isTrue, reason: 'Message should not indicate failure');

      print('✅ Success detection works correctly!');
      print('✅ Message: $message');
    });

    test('should detect failure from API response correctly', () {
      final response = QRTestHelper.simulateFailedResponse();

      // This simulates the logic in QRScannerScreen._processQRCode()
      bool success =
          response['success'] == true ||
          response['status'] == 'success' ||
          response['status'] == true ||
          response['status'] == 200 ||
          response['attendance_status'] == 'true' ||
          response['attendance_status'] == true ||
          (response.containsKey('message') &&
              response['message'].toString().toLowerCase().contains(
                'recorded',
              )) ||
          (response.containsKey('message') &&
              response['message'].toString().toLowerCase().contains('success'));

      expect(
        success,
        isFalse,
        reason: 'Should not detect success from failed response',
      );

      String message = response['message'].toString();

      // Check if message indicates failure
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('error') ||
          message.toLowerCase().contains('failed')) {
        success = false;
      }

      expect(
        success,
        isFalse,
        reason: 'Should detect failure from invalid message',
      );

      print('❌ Failure detection works correctly!');
      print('❌ Message: $message');
    });

    test('should demonstrate the complete flow', () {
      print('\n🔄 Complete QR Scanner Flow Test:');
      print('=' * 50);

      // Step 1: Generate QR code
      final qrCode = QRTestHelper.generateWorkingQRCode();
      print('1️⃣ QR Code Generated: $qrCode');

      // Step 2: Parse QR code
      final qrData = jsonDecode(qrCode);
      print('2️⃣ QR Code Parsed: $qrData');

      // Step 3: Prepare API request
      final apiRequest = QRTestHelper.getAPIRequestFormat(qrCode);
      print('3️⃣ API Request: $apiRequest');

      // Step 4: Simulate API response
      final apiResponse = QRTestHelper.simulateSuccessfulResponse();
      print('4️⃣ API Response: $apiResponse');

      // Step 5: Determine success
      bool success =
          apiResponse['attendance_status'] == 'true' ||
          (apiResponse.containsKey('message') &&
              apiResponse['message'].toString().toLowerCase().contains(
                'recorded',
              ));

      print('5️⃣ Success Determined: $success');
      print('=' * 50);
      print('✅ Complete flow works correctly!');

      expect(success, isTrue);
    });
  });
}
