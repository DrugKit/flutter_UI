import 'package:drugkit/logic/reset_password/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/logic/forget_password/forget_password_cubit.dart';
import 'package:drugkit/Navigation/app_navigation.dart';
import 'package:drugkit/Navigation/routes_names.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ForgetPasswordCubit.get(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordLoading) {
              _showLoadingDialog();
            } else if (state is ResetCodeVerifiedSuccess) {
              Navigator.pop(context); // Close loading
              AppNavigator.pushReplacement(
                context,
                RouteNames.setNewPassword,
                {
                  'email': widget.email,
                  'resetCode': _codeController.text.trim(),
                },
              );
            } else if (state is SendResetCodeSuccess) {
              Navigator.pop(context); // Close loading
              _showSnackBar('Reset email sent successfully.');
            } else if (state is ForgetPasswordError) {
              Navigator.pop(context); // Close loading
              _showErrorDialog(state.errorMessage);
            }
          },
          builder: (context, state) {
            return Padding(
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
                  Text(
                    "We sent a reset link to\n${widget.email}\nEnter 6 digit code mentioned in the email",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: "Enter 6-digit code",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_codeController.text.trim().length == 6) {
                        ForgetPasswordCubit.get(context).verifyResetCode(
                          email: widget.email,
                          resetCode: _codeController.text.trim(),
                        );
                      } else {
                        _showErrorDialog("Please enter a valid 6-digit code.");
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
                      "Verify Code",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Haven’t got the email yet? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ForgetPasswordCubit.get(context).sendResetCode(
                            email: widget.email,
                          );
                        },
                        child: const Text(
                          "Resend email",
                          style: TextStyle(
                            color: Color(0xFF0C1467),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
