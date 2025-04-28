import 'package:drugkit/logic/login/login_cubit.dart';
import 'package:drugkit/logic/verification/verification_cubit.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:drugkit/screens/welcome.dart';
import 'package:drugkit/screens/signup.dart';
import 'package:drugkit/screens/Signup_verification.dart';
import 'package:drugkit/screens/verification_done.dart';
import 'package:drugkit/screens/login.dart';
import 'package:drugkit/screens/forgetpassword.dart';
import 'package:drugkit/screens/verifyemail.dart';
import 'package:drugkit/screens/passwordreset.dart';
import 'package:drugkit/screens/setnewpassword.dart';
import 'package:drugkit/screens/setnewpass_done.dart';
import 'package:drugkit/screens/home.dart';
// import 'package:drugkit/screens/drug_categories.dart';
//import 'package:drugkit/screens/drugdetails.dart';
// import 'package:drugkit/screens/drug.dart';
//import 'package:drugkit/screens/prescriptionscan_loading.dart';
//import 'package:drugkit/screens/prescription_data.dart';
//import 'package:drugkit/screens/nearestpharmacy.dart ';
//import 'package:drugkit/screens/scanner.dart';
//import 'package:drugkit/screens/chatbot.dart';
import 'package:drugkit/Navigation/routes_names.dart ';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      //home: LoginScreen(),  // Change this to the desired initial screen
      initialRoute: '/welcome',
      routes: {
        RouteNames.welcome: (context) => const WelcomeScreen(),
        RouteNames.signup: (context) => const SignUpScreen(),
        // RouteNames.verifySignup: (context) => const VerificationCodeScreen(),
        RouteNames.signupDone: (context) => const SuccessScreen(),
        RouteNames.login: (context) => BlocProvider(
              create: (_) => LoginCubit(),
              child: const LoginScreen(),
            ),
        RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(),
        RouteNames.verifyEmail: (context) => const VerifyEmailScreen(),
        RouteNames.passwordResetDone: (context) => const PasswordResetScreen(),
        RouteNames.setNewPassword: (context) => const SetNewPasswordScreen(),
        RouteNames.resetDone: (context) => const SetNewPassDoneScreen(),
        RouteNames.home: (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == RouteNames.verifySignup) {
          final data = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => VerificationCubit(),
              child: VerificationCodeScreen(
                email: data['email']!,
                password: data['password']!,
              ),
            ),
          );
        }
        // باقي الراوتات هنا حسب استخدامك...
        return null;
      },
    );
  }
}
