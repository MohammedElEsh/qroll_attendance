/// Result screen displayed after scanning a QR code.
/// Shows success/failure status and provides options to return to dashboard or scan again.
library;
import 'package:flutter/material.dart';
import '../../screens/dashboard_screen.dart';
import 'qr_scanner_screen.dart';

class QRResultScreen extends StatelessWidget {
  /// Whether the QR code scan was successful
  final bool success;

  /// Message to display about the scan result
  final String message;

  /// Additional details about the scan (optional)
  final Map<String, dynamic>? details;

  const QRResultScreen({
    super.key,
    required this.success,
    required this.message,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success/failure status icon
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),

              // Result status message
              Text(
                message,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Additional scan details section
              if (details != null && details!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...details!.entries.map((entry) {
                        if (entry.value is Map) {
                          return Container(); // Skip complex objects
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_formatKey(entry.key)}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(entry.value?.toString() ?? 'N/A'),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Return to dashboard button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Scan again button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const QRScannerScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code_scanner, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Scan Again',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats a snake_case key into Title Case for display
  String _formatKey(String key) {
    // Convert snake_case to Title Case
    return key
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }
}
