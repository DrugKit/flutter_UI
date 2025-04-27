import 'package:flutter/material.dart';
import 'package:drugkit/Navigation/app_navigation.dart';
import 'package:drugkit/Navigation/routes_names.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set a new password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1467),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Create a new password, Ensure it differs\nfrom the previous ones for security",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter new password",
                suffixIcon: const Icon(Icons.visibility_off),
                border: outlineBorder,
                enabledBorder: outlineBorder,
                focusedBorder: outlineBorder,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                hintText: "Re-enter new password",
                suffixIcon: const Icon(Icons.visibility_off),
                border: outlineBorder,
                enabledBorder: outlineBorder,
                focusedBorder: outlineBorder,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  AppNavigator.pushReplacement(context, RouteNames.resetDone);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C1467),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Password",
                  style: TextStyle(fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}