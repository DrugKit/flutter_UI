import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/logic/barcode/BarcodeScanCubit.dart';
import 'package:drugkit/logic/barcode/BarcodeScanState.dart';
import 'package:drugkit/Navigation/routes_names.dart'; // تأكد من المسار الصحيح لـ routes_names

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  // لا نحتاج _isDialogShowing هنا بنفس التعقيد، لأن BlocListener سيتولى ذلك
  // ولكن يمكننا الاحتفاظ بها إذا كنت تريد التأكد من عدم فتح ديالوجين في نفس الوقت.
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BarcodeScanCubit, BarcodeScanState>(
      listener: (context, state) {
        if (state is BarcodeScanLoading) {
          if (!_isDialogShowing) { // منع فتح أكثر من ديالوج تحميل
            _isDialogShowing = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Scanning barcode...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This may take a few moments.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } else if (state is BarcodeScanSuccess) {
          if (_isDialogShowing) {
            Navigator.of(context, rootNavigator: true).pop(); // اقفل ديالوج التحميل
            _isDialogShowing = false;
          }
          // **مهم: إعادة تعيين حالة الـ Cubit بعد النجاح**
          context.read<BarcodeScanCubit>().resetState();

          Navigator.pushNamed(
            context,
            RouteNames.barcodeScanResult, // RouteName لصفحة النتائج
            arguments: state.data, // تمرير قائمة الأدوية المستلمة من الـ API
          ).then((_) {
            // يتم استدعاء هذا الكود عند العودة من شاشة النتائج
            // التأكد من أن الـ Cubit في حالة Initial عند العودة
            // (هذا ليس ضروريًا إذا تم resetState قبل الانتقال، ولكنه طبقة دفاع إضافية)
            // context.read<BarcodeScanCubit>().resetState();
          });
        } else if (state is BarcodeScanError) {
          if (_isDialogShowing) {
            Navigator.of(context, rootNavigator: true).pop(); // اقفل ديالوج التحميل
            _isDialogShowing = false;
          }

          // **مهم: إعادة تعيين حالة الـ Cubit بعد الخطأ**
          context.read<BarcodeScanCubit>().resetState();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext, rootNavigator: true).pop(); // إغلاق ديالوج الخطأ
                    },
                  ),
                ],
              );
            },
          ).then((_) {
            _isDialogShowing = false; // Reset the flag after error dialog closes
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0C1467)),
            onPressed: () {
              // عند العودة، تأكد أن حالة الـ Cubit هي Initial
              context.read<BarcodeScanCubit>().resetState();
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Barcode Scanner',
            style: TextStyle(
              color: Color(0xFF0C1467),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/barcodeScreen.png', // تأكد من أن هذا المسار صحيح وموجود في pubspec.yaml
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      context.read<BarcodeScanCubit>().scanBarcode(image);
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scan with Camera'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF0C1467), // Dark blue
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      context.read<BarcodeScanCubit>().scanBarcode(image);
                    }
                  },
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Upload Barcode'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF1A237E), // Dark blue text
                    side: const BorderSide(
                        color: Color(0xFFBBDEFB),
                        width: 1.0), // Light blue border
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Supported formats: QR, EAN, PDF417',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}