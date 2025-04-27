import 'package:drugkit/network/api_service.dart';
import 'package:flutter/material.dart';
//import 'package:drugkit/screens/welcome.dart'; 
import 'package:drugkit/screens/signup.dart';
import 'package:drugkit/screens/Signup_verification.dart'; 
import 'package:drugkit/screens/verification_done.dart';
//import 'package:drugkit/screens/login.dart'; 
//import 'package:drugkit/screens/forgetpassword.dart';
//import 'package:drugkit/screens/verifyemail.dart';
//import 'package:drugkit/screens/passwordreset.dart';
//import 'package:drugkit/screens/setnewpassword.dart';
//import 'package:drugkit/screens/setnewpass_done.dart';
// import 'package:drugkit/screens/home.dart'; 
// import 'package:drugkit/screens/drug_categories.dart';
 //import 'package:drugkit/screens/drugdetails.dart';
// import 'package:drugkit/screens/drug.dart';
//import 'package:drugkit/screens/prescriptionscan_loading.dart';
//import 'package:drugkit/screens/prescription_data.dart';
//import 'package:drugkit/screens/nearestpharmacy.dart ';
//import 'package:drugkit/screens/scanner.dart';
//import 'package:drugkit/screens/chatbot.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
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
    // home: CategoryDrugsScreen(categoryName: 'Heart'),  // Change this to the desired initial screen
     home: SignUpScreen(),  // Change this to the desired initial screen
      // home: const WelcomeScreen(), // Uncomment this line to use the WelcomeScreen as the initial screen


    );
  }
}
