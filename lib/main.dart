
import 'package:flutter/material.dart';
//import 'package:drugkit/screens/welcome.dart'; 
//import 'package:drugkit/screens/signup.dart';
//import 'package:drugkit/screens/Signup_verification.dart'; 
//import 'package:drugkit/screens/verification_done.dart';
//import 'package:drugkit/screens/login.dart'; 
//import 'package:drugkit/screens/forgetpassword.dart';
//import 'package:drugkit/screens/verifyemail.dart';
//import 'package:drugkit/screens/passwordreset.dart';
//import 'package:drugkit/screens/setnewpassword.dart';
//import 'package:drugkit/screens/setnewpass_done.dart';
import 'package:drugkit/screens/home.dart'; 


void main() {
  runApp(const DrugKitApp());
}

class DrugKitApp extends StatelessWidget {
  const DrugKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'DrugKit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
 
    );
  }
}
