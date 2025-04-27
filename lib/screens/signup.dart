import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isButtonPressed = false;
  bool _isPasswordVisible = false; // 👈 أضفنا ده عشان إظهار الباسورد

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C1467),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name',
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                            .hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 🔥 هنا تعديل الباسورد مع أيقونة إظهار/إخفاء
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter Phone Number',
                    border: outlineBorder,
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[0-9]{11}$').hasMatch(value.trim())) {
                      return 'Phone number must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // ✨ الزرار مع الانيميشن لما المستخدم يضغط عليه
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isButtonPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isButtonPressed = false;
                    });
                    _onSignUp();
                  },
                  onTapCancel: () {
                    setState(() {
                      _isButtonPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    width: _isButtonPressed
                        ? MediaQuery.of(context).size.width * 0.95
                        : double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C1467),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      // ✅ هنا البيانات جاهزة تتبعت للـ Backend
      print('Registering User...');
      print('Full Name: ${_fullNameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      print('Phone: ${_phoneController.text}');
    }
  }
}
