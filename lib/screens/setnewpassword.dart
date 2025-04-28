import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/Navigation/app_navigation.dart';
import 'package:drugkit/Navigation/routes_names.dart';
import 'package:drugkit/logic/reset_password/reset_password_cubit.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String resetCode;

  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.resetCode,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordLoading) {
            _showLoadingDialog();
          } else if (state is ResetPasswordSuccess) {
            Navigator.pop(context); // قفل اللودينج
            AppNavigator.pushReplacement(context, RouteNames.resetDone);
          } else if (state is ResetPasswordError) {
            Navigator.pop(context); // قفل اللودينج
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Set New Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C1467),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildPasswordField(_passwordController, "New Password"),
                    const SizedBox(height: 15),
                    _buildPasswordField(
                        _confirmPasswordController, "Confirm Password"),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text ==
                              _confirmPasswordController.text) {
                            ResetPasswordCubit.get(context).resetPassword(
                              email: widget.email,
                              resetCode: widget.resetCode,
                              newPassword: _passwordController.text.trim(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Passwords do not match.")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C1467),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
          return "Password must be at least 6 characters.";
        }
        return null;
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
