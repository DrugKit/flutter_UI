import 'package:flutter/material.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(167, 222, 221, 221),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Barcode illustration in center
            Center(
              child: Image.asset(
                'assets/barcode-scan.png', 
                width: 200,
                height: 200,
              ),
            ),

            // Scan button at bottom
            Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  // Later: trigger scanner
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.qr_code_scanner,
                      size: 28, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
