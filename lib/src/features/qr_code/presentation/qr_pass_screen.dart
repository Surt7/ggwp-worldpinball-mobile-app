import 'package:flutter/material.dart';

/// Screen / Modal displaying the player's QR Pass in large size for machine scanners.
/// Tapping anywhere on the screen dismisses it.
class QrPassScreen extends StatelessWidget {
  const QrPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate responsive size (75% of screen width) for easy optical scanning
    final qrSize = MediaQuery.of(context).size.width * 0.75;

    return GestureDetector(
      // 2. Tapping anywhere on the screen closes the pass
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SCAN PLAYER PASS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hold near the pinball scanner',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 36),

                  // 3. Large QR Code Container with rounded corners
                  Container(
                    width: qrSize,
                    height: qrSize,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.qr_code_2,
                      size: qrSize - 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 4. Visual hint to dismiss
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tap anywhere to close',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}