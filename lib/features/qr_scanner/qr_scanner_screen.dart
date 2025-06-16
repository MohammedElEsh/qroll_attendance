import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'qr_result_screen.dart';
import '../../services/student_service.dart';
import '../../utils/qr_test_helper.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  // Camera controller for QR scanning
  late final MobileScannerController _controller;

  // Student service for API calls
  final StudentService _studentService = StudentService();

  // State variables for scanner controls
  bool _isProcessing = false;
  bool _isTorchEnabled = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: true,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /// Handles app lifecycle changes to manage camera state
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller doesn't have camera permission, return
    if (_controller.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      _controller.start();
    } else if (state == AppLifecycleState.inactive) {
      _controller.stop();
    }
  }

  /// Processes detected QR codes and handles scanning state
  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    if (capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;

    if (barcode.rawValue == null) return;

    // Set processing flag to prevent multiple detections
    setState(() {
      _isProcessing = true;
    });

    try {
      // Pause camera to prevent further scanning
      await _controller.stop();

      final qrCode = barcode.rawValue!;

      // Now handle the QR code
      _processQRCode(qrCode);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      // Resume camera if there was an error
      _controller.start();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Processes the scanned QR code and marks attendance
  void _processQRCode(String qrCode) async {
    try {
      // Parse QR code data
      Map<String, dynamic> qrData;
      try {
        qrData = jsonDecode(qrCode);
      } catch (e) {
        throw Exception('Invalid QR code format');
      }

      // Validate required fields
      if (!qrData.containsKey('lecture_id') ||
          !qrData.containsKey('course_id') ||
          !qrData.containsKey('timestamp') ||
          !qrData.containsKey('signature')) {
        throw Exception('QR code missing required fields');
      }

      // Call the attendance API
      final response = await _studentService.scanAttendance(qrData);

      // Check if attendance was marked successfully
      bool success = false;
      String message = 'Attendance marked successfully!';

      if (response.statusCode == 200) {
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;

          // Check for different success indicators from API
          success =
              data['success'] == true ||
              data['status'] == 'success' ||
              data['status'] == true ||
              data['status'] == 200 ||
              data['attendance_status'] == 'true' ||
              data['attendance_status'] == true ||
              (data.containsKey('message') &&
                  data['message'].toString().toLowerCase().contains(
                    'recorded',
                  )) ||
              (data.containsKey('message') &&
                  data['message'].toString().toLowerCase().contains('success'));

          // Get the message from API response
          if (data.containsKey('message')) {
            message = data['message'].toString();
          }

          // If message indicates failure, mark as failed
          if (message.toLowerCase().contains('invalid') ||
              message.toLowerCase().contains('error') ||
              message.toLowerCase().contains('failed')) {
            success = false;
          }
        } else {
          success = true; // Assume success if 200 status and no data
        }
      } else {
        // Handle non-200 status codes
        success = false;
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('message')) {
            message = data['message'].toString();
          } else {
            message =
                'Failed to mark attendance (Status: ${response.statusCode})';
          }
        } else {
          message =
              'Failed to mark attendance (Status: ${response.statusCode})';
        }
      }

      // Navigate to result screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => QRResultScreen(
                  success: success,
                  message: message,
                  details: {
                    'qr_data': qrCode,
                    'lecture_id': qrData['lecture_id'],
                    'course_id': qrData['course_id'],
                    'timestamp': DateTime.now().toString(),
                    'api_response': response.data,
                    'status_code': response.statusCode,
                    'success_determined_by':
                        success
                            ? 'API response validation'
                            : 'Error in response',
                  },
                ),
          ),
        );
      }
    } catch (e) {
      // In case of error, resume the camera
      setState(() {
        _isProcessing = false;
      });
      _controller.start();

      // Determine error message based on error type
      String errorMessage = 'Error: ${e.toString()}';
      if (e.toString().contains('Invalid QR code format')) {
        errorMessage = 'QR Code format is invalid. Please try again.';
      } else if (e.toString().contains('QR code missing required fields')) {
        errorMessage = 'QR Code is missing required information.';
      } else if (e.toString().contains('Authentication token not found')) {
        errorMessage = 'Please login again to scan attendance.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection')) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Please try again.';
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                // Retry scanning
                _controller.start();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          // Test QR button for development
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              // Run QR tests first
              QRTestHelper.printTestResults();

              // Test with valid QR code
              final testQRCode = QRTestHelper.generateTestQRCode();
              _processQRCode(testQRCode);
            },
          ),
          // Camera flip button
          IconButton(
            icon: Icon(_isFrontCamera ? Icons.camera_rear : Icons.camera_front),
            onPressed: () {
              _controller.switchCamera();
              setState(() {
                _isFrontCamera = !_isFrontCamera;
              });
            },
          ),
          // Torch toggle button
          IconButton(
            icon: Icon(_isTorchEnabled ? Icons.flash_off : Icons.flash_on),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {
                _isTorchEnabled = !_isTorchEnabled;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // QR scanner view
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            scanWindow: Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              ),
              width: 250,
              height: 250,
            ),
          ),
          // Scanner overlay with guide
          QRScannerOverlay(
            scanAreaSize: 250,
            borderColor: Colors.indigo,
            borderRadius: 12,
            borderLength: 30,
            borderWidth: 10,
            overlayColor: Colors.black.withAlpha(150),
          ),
          // Loading indicator during processing
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom overlay widget for the QR scanner
/// Provides visual guidance for scanning area
class QRScannerOverlay extends StatelessWidget {
  final double scanAreaSize;
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final Color overlayColor;

  const QRScannerOverlay({
    super.key,
    this.scanAreaSize = 200,
    this.borderColor = Colors.green,
    this.borderWidth = 3.0,
    this.borderLength = 30,
    this.borderRadius = 10,
    this.overlayColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent overlay with cutout for scanning area
        ColorFiltered(
          colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: scanAreaSize,
                  width: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scanning area border
        Center(
          child: Container(
            width: scanAreaSize,
            height: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                // Top left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
