import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Check your email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1467),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "we sent a reset link to\nexample@gmail.com\nenter 5 digit code that mentioned in the email",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return Container(
                  width: 46,  // Smaller size
                  height: 46, // Smaller size
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1467),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Verify Code",
                style: TextStyle(color: Colors.white
                , fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            const Text.rich(
              TextSpan(
                text: "Haven’t got the email yet? ",
                style: TextStyle(color: Colors.grey,
                fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "Resend email",
                    style: TextStyle(
                      color: Color(0xFF0C1467),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}