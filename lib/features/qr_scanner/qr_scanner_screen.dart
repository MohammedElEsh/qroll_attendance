import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_result_screen.dart';
// import 'package:dio/dio.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  // Camera controller for QR scanning
  late final MobileScannerController _controller;

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
      // TODO: Here you would implement the actual API call to process the QR code
      // For now, we just show a success result

      // Navigate to the result screen with mock success data
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => QRResultScreen(
                  success: true,
                  message: 'Attendance marked successfully!',
                  details: {
                    'qr_data': qrCode,
                    'timestamp': DateTime.now().toString(),
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

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing QR code: $e'),
            backgroundColor: Colors.red,
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
