import 'package:flutter/material.dart';
//import 'prescription_result_screen.dart';

class PrescriptionLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: BackButton(color: const Color(0xFF0C1467)), 
        title: Text(
          "prescription scan",
          style: TextStyle(
            color: const Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar أبيض
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الزر فوق
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Future.delayed(Duration(seconds: 2), () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => PrescriptionResultScreen()),
                    //   );
                    // });
                  },
                  icon: Icon(Icons.upload_file, color: Colors.white),
                  label: Text(
                    "Upload Your Prescription",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C1467),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // loader
          Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
              strokeWidth: 5,
            ),
          ),
        ],
      ),
    );
  }
}