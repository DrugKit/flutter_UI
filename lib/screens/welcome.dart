
import 'package:flutter/material.dart';
import 'package:drugkit/Navigation/app_navigation.dart';
import 'package:drugkit/Navigation/routes_names.dart';
//import 'package:drugkit/screens/login.dart'; // تأكد أنك مستورد الشاشة الصحيحة

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Stack(
        children: [
          // Centered Logo and Title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoFigma.png',
                  width: 250,
                  height:250
                ),
              ],
            ),
          ),

          // Bottom Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                // Log In (Left Text Button)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: () {
                          AppNavigator.push(context, RouteNames.login);

                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0C1467),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Sign Up 
                Align(
                  alignment: Alignment.bottomRight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                    ),
                    child: Container(
                      width: 160,
                      height: 70,
                      color: const Color(0xFF0C1467),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          AppNavigator.push(context, RouteNames.signup);

                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
