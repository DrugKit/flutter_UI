// import 'package:flutter/material.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.arrow_back, color: Colors.black),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Forgot Password",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0C1467),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Image.asset(
//                   'assets/forgetPasswordLogo.png', 
//                   height: 100,
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Please enter your email to reset password",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     hintText: "Enter your email",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0C1467),
//                     minimumSize: const Size.fromHeight(50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     "Reset Password",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 26,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C1467),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'assets/forgetPasswordLogo.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Please enter your email to reset password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: outlineBorder,
                  enabledBorder: outlineBorder,
                  focusedBorder: outlineBorder,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C1467),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}