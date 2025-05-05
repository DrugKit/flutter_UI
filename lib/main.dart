import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:drugkit/logic/forget_password/forget_password_cubit.dart';
import 'package:drugkit/logic/login/login_cubit.dart';
import 'package:drugkit/logic/nearest_pharmacy/nearest_pharmacy_cubit.dart';
import 'package:drugkit/logic/prescription_history/prescription_history_cubit.dart';
import 'package:drugkit/logic/search/search_cubit.dart';
import 'package:drugkit/logic/verification/verification_cubit.dart';
import 'package:drugkit/models/prescription_history_model.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:drugkit/screens/chatbot_requests.dart';
import 'package:drugkit/screens/drug_details_no_image.dart';
import 'package:drugkit/screens/drug_recommend.dart';
import 'package:drugkit/screens/prescription_history.dart';
import 'package:drugkit/screens/view_prescription.dart';
import 'package:drugkit/storage/storage_service.dart';
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
import 'package:drugkit/screens/drug_categories.dart';
import 'package:drugkit/screens/drugdetails.dart';
// import 'package:drugkit/screens/drug.dart';
//import 'package:drugkit/screens/prescriptionscan_loading.dart';
import 'package:drugkit/screens/prescription_data.dart';
import 'package:drugkit/screens/nearestpharmacy.dart ';
import 'package:drugkit/screens/scanner.dart';
import 'package:drugkit/screens/chatbot.dart';
import 'package:drugkit/Navigation/routes_names.dart ';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // ⬅️ مهم جدًا لتهيئة Hive في التطبيقات Flutter
  await StorageData.init();
  // ⬅️ لازم ده الأول
  await DioHelper.init();
  DioHelper().updateToken(); // ⬅️ بعد init
  runApp(const DrugKitApp());
}

class DrugKitApp extends StatelessWidget {
  const DrugKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide debug banner
        title: 'DrugKit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: CategoryDrugsScreen(categoryName: "home")
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
          RouteNames.verifyEmail: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return BlocProvider(
              create: (_) => ForgetPasswordCubit(),
              child: VerifyEmailScreen(email: args['email']),
            );
          },
          RouteNames.passwordResetDone: (context) =>
              const PasswordResetScreen(),
          RouteNames.setNewPassword: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, String>;
            return SetNewPasswordScreen(
              email: args['email']!,
              resetCode: args['resetCode']!,
            );
          },
          RouteNames.resetDone: (context) => const SetNewPassDoneScreen(),
          RouteNames.home: (context) => const HomeScreen(),
          RouteNames.myRequests: (context) => const ChatbotRequestsScreen(),
          RouteNames.myPrescriptions: (context) => BlocProvider(
                create: (_) =>
                    PrescriptionHistoryCubit()..fetchPrescriptionHistory(),
                child: const PrescriptionHistoryScreen(),
              ),

          RouteNames.nearestPharmacy: (context) => BlocProvider(
                create: (_) => NearestPharmacyCubit(),
                child: const NearestPharmacyScreen(),
              ),
          RouteNames.drugRecommendation: (context) =>
              const DrugRecommendationScreen(),
          RouteNames.prescriptionScan: (context) => PrescriptionResultScreen(),
          RouteNames.chatBot: (context) => ChatBotScreen(),
          RouteNames.drugDetails: (context) {
            final drug = ModalRoute.of(context)!.settings.arguments
                as Map<String, String>;
            return DrugDetailsScreen(drug: drug);
          },
          RouteNames.drugDetailsNoImage: (context) {
  final drug = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  return DrugDetailsNoImageScreen(drug: drug);
          },

          // RouteNames.category: (context) => CategoryDrugsScreen(categoryName: 'Heart'), // هنعدل ده ديناميك بعدين
          // RouteNames.drugDetails: (context) {
          //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          //   return DrugDetailsScreen(
          //     // drugName: args['name'],
          //     // imageUrl: args['imageUrl'],
          //     // description: args['description'],
          //     // company: args['company'],
          //     // sideEffects: args['sideEffects'],
          //     // price: args['price'],
          //   );
          // },
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
          } else if (settings.name == RouteNames.category) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GetcategoryCubit(),
                child: CategoryDrugsScreen(
                  categoryName: args['name'],
                  categoryId: args['categoryId'],
                ),
              ),
            );
          } else if (settings.name == RouteNames.prescriptionDetails) {
            final prescription = settings.arguments as PrescriptionHistoryModel;
            return MaterialPageRoute(
              builder: (_) =>
                  PrescriptionDetailsScreen(prescription: prescription),
            );
          }

          // باقي الراوتات هنا حسب استخدامك...
          return null;
        },
      ),
    );
  }
}
