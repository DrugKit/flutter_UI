// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Text(
//                   "Welcome Back",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.indigo,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     suffixIcon: Icon(Icons.visibility_off),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(value: true, onChanged: (_) {}),
//                         const Text("Remember me"),
//                       ],
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: Colors.indigo),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo,
//                     minimumSize: const Size.fromHeight(50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Sign in"),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text("Sign in with"),
//                 const SizedBox(height: 10),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.g_mobiledata, size: 36, color: Colors.red),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't have an account?"),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text("Sign up"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C1467),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Shrouk800@gmail.com",
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
                    labelText: "Password",
                    suffixIcon: const Icon(Icons.visibility_off),
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (_) {},
                          activeColor: const Color(0xFF0C1467),
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFF0C1467)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                      "Sign in",
                      style: TextStyle(fontSize: 16
                      , color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Sign in with"),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // Handle Google Sign In
                  },
                  child: Image.asset(
                    'assets/google.png', // Add your actual image in assets
                    height: 45,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF0C1467),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}