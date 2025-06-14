import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:drugkit/logic/chatbot/chat_cubit.dart';
import 'package:drugkit/logic/forget_password/forget_password_cubit.dart';
import 'package:drugkit/logic/login/login_cubit.dart';
import 'package:drugkit/logic/nearest_pharmacy/nearest_pharmacy_cubit.dart';
import 'package:drugkit/logic/prescription/PrescriptionUploadCubit.dart';
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
import 'package:drugkit/screens/prescription_data.dart';
import 'package:drugkit/screens/nearestpharmacy.dart ';
import 'package:drugkit/screens/chatbot.dart';
import 'package:drugkit/Navigation/routes_names.dart ';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:drugkit/logic/barcode/BarcodeScanCubit.dart';
import 'package:drugkit/screens/barcode.dart';
import 'package:drugkit/screens/barcode_scan_result_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await StorageData.init();
  await DioHelper.init(); // تهيئة DioHelper هنا
  DioHelper().updateToken(); // تحديث التوكن بعد التهيئة
  runApp(const DrugKitApp());
}

class DrugKitApp extends StatelessWidget {
  const DrugKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(),
        ),
        BlocProvider<PrescriptionUploadCubit>(
          create: (context) => PrescriptionUploadCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<ForgetPasswordCubit>(
          create: (context) => ForgetPasswordCubit(),
        ),
        BlocProvider<VerificationCubit>(
          create: (context) => VerificationCubit(),
        ),
        BlocProvider<NearestPharmacyCubit>(
          create: (context) => NearestPharmacyCubit(),
        ),
        BlocProvider<PrescriptionHistoryCubit>(
          create: (context) => PrescriptionHistoryCubit(),
        ),
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        BlocProvider<GetcategoryCubit>(
          create: (context) => GetcategoryCubit(),
        ),
        // **هذا هو BarcodeScanCubit الذي يجب أن يكون هنا**
        BlocProvider<BarcodeScanCubit>(
          create: (context) => BarcodeScanCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DrugKit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RouteNames.welcome,
        routes: {
          RouteNames.barcodeScan: (context) => const BarcodeScannerScreen(),
          RouteNames.barcodeScanResult: (context) => BarcodeScanResultScreen(
                medicines: ModalRoute.of(context)!.settings.arguments as List<dynamic>,
              ),
          RouteNames.welcome: (context) => const WelcomeScreen(),
          RouteNames.signup: (context) => const SignUpScreen(),
          RouteNames.signupDone: (context) => const SuccessScreen(),
          // قم بإزالة BlocProvider من هنا إذا كان موجودًا
          RouteNames.login: (context) => const LoginScreen(), // لا تحتاج لـ BlocProvider هنا إذا كان موجودًا في MultiBlocProvider
          RouteNames.forgotPassword: (context) => const ForgotPasswordScreen(),
          RouteNames.verifyEmail: (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return VerifyEmailScreen(email: args['email']); // لا تحتاج لـ BlocProvider هنا
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
          RouteNames.prescriptionScan: (context) => const PrescriptionResultScreen(),
          RouteNames.chatBot: (context) => BlocProvider(
                create: (context) => ChatCubit(),
                child: SymptomCheckerScreen(),
              ),
          RouteNames.drugDetails: (context) {
            final drug = ModalRoute.of(context)!.settings.arguments
                as Map<String, String>;
            return DrugDetailsScreen(drug: drug);
          },
          RouteNames.drugDetailsNoImage: (context) {
            final drug = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            return DrugDetailsNoImageScreen(drug: drug);
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name == RouteNames.verifySignup) {
            final data = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => VerificationCodeScreen(
                email: data['email']!,
                password: data['password']!,
              ),
            );
          } else if (settings.name == RouteNames.category) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CategoryDrugsScreen(
                categoryName: args['name'],
                categoryId: args['categoryId'],
              ),
            );
          } else if (settings.name == RouteNames.prescriptionDetails) {
            final prescription = settings.arguments as PrescriptionHistoryModel;
            return MaterialPageRoute(
              builder: (_) =>
                  PrescriptionDetailsScreen(prescription: prescription),
            );
          }
          return null;
        },
      ),
    );
  }
}