import 'package:flutter/material.dart';
//import 'prescription_result_screen.dart';

class PrescriptionLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          "prescription scan",
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                // Future.delayed(Duration(seconds: 2), () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => PrescriptionResultScreen(),
                //     ),
                //   );
                // });
              },
              icon: Icon(Icons.upload_file),
              label: Text("Upload Your Prescription"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          CircularProgressIndicator(
            color: Colors.indigo,
            strokeWidth: 6,
          ),
        ],
      ),
    );
  }
}