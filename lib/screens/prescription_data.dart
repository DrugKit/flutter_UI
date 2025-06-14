import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// تأكد من المسارات الصحيحة للكيوبت والـ states
import 'package:drugkit/logic/prescription/PrescriptionUploadCubit.dart'; // تأكد من المسار
import 'package:drugkit/logic/prescription/PrescriptionUploadState.dart'; // تأكد من المسار
import 'package:drugkit/Navigation/routes_names.dart';

class PrescriptionResultScreen extends StatefulWidget {
  const PrescriptionResultScreen({super.key});

  @override
  State<PrescriptionResultScreen> createState() =>
      _PrescriptionResultScreenState();
}

class _PrescriptionResultScreenState extends State<PrescriptionResultScreen> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    final dynamic medicinesArguments =
        ModalRoute.of(context)!.settings.arguments;
    // التأكد من أن arguments هي List<dynamic> أو تحويلها
    final List<dynamic> prescriptionMedicines = (medicinesArguments is List)
        ? List<dynamic>.from(
            medicinesArguments) // تأكد من تحويلها لقائمة ديناميكية قابلة للتعديل
        : [];

    return BlocConsumer<PrescriptionUploadCubit, PrescriptionUploadState>(
      listener: (context, state) {
        if (state is PrescriptionUploadLoading && !_isDialogShowing) {
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
                      'Please wait while we process your prescription...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This may take up to a minute.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is PrescriptionUploadSuccess) {
          if (_isDialogShowing) {
            Navigator.of(context, rootNavigator: true)
                .pop(); // اقفل ديالوج التحميل
            _isDialogShowing = false;
          }
          // التعديل هنا: استخدام pushReplacementNamed بدلاً من pushNamedAndRemoveUntil
          Navigator.pushReplacementNamed(
            //
            context,
            RouteNames.prescriptionScan,
            arguments: state.data, // هنا الـ data الجديدة من السيرفر
          );
        } else if (state is PrescriptionUploadError) {
          if (_isDialogShowing) {
            Navigator.of(context, rootNavigator: true)
                .pop(); // اقفل ديالوج التحميل الأول
            _isDialogShowing = false; // Reset the flag
          }

          // إظهار ديالوج جديد برسالة الخطأ "حاول مرة أخرى"
          _isDialogShowing = true; // Set the flag for the new dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message), // رسالة الخطأ من الـ cubit
                actions: <Widget>[
                  TextButton(
                    child: const Text('Try Again'),
                    onPressed: () {
                      Navigator.of(dialogContext, rootNavigator: true)
                          .pop(); // إغلاق ديالوج الخطأ
                      _isDialogShowing = false; // Reset the flag
                      // هنا ممكن تضيف Logic لإعادة المحاولة لو حابب
                      // مثلاً: context.read<PrescriptionUploadCubit>().uploadPrescription(lastUploadedImage);
                      // ولكن هنا هنكتفي بإغلاق الديالوج
                    },
                  ),
                ],
              );
            },
          ).then((_) {
            // هذا الجزء يتم تنفيذه بعد إغلاق الديالوج
            _isDialogShowing = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const BackButton(color: Color(0xFF0C1467)),
            title: const Text(
              'prescription scan',
              style: TextStyle(
                color: Color(0xFF0C1467),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      context
                          .read<PrescriptionUploadCubit>()
                          .uploadPrescription(image);
                    }
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text(
                    "Upload Your Prescription",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C1467),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Medicines Found:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF0C1467),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap a medicine to view more info',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: prescriptionMedicines.isEmpty
                      ? const Center(
                          child: Text(
                            'No medicines found.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: prescriptionMedicines.length,
                          itemBuilder: (context, index) {
                            final item = prescriptionMedicines[index];
                            // تأكد أن item هي Map قبل محاولة الوصول لمفتاح 'name'
                            final name =
                                (item is Map && item.containsKey('name'))
                                    ? item['name']?.toString() ?? 'Unknown'
                                    : 'Unknown';

                            // استخراج باقي البيانات اللازمة لشاشة التفاصيل
                            final company =
                                (item is Map && item.containsKey('company'))
                                    ? item['company']?.toString() ?? 'N/A'
                                    : 'N/A';
                            final description =
                                (item is Map && item.containsKey('description'))
                                    ? item['description']?.toString() ??
                                        'No description available.'
                                    : 'No description available.';

                            // تصحيح استخراج sideEffects وتحويلها إلى String
                            final List<dynamic> rawSideEffects =
                                (item is Map && item.containsKey('sideEffects'))
                                    ? item['sideEffects'] as List<dynamic>
                                    : [];
                            final String sideEffectsString = rawSideEffects
                                .map((e) => e.toString())
                                .join(',');

                            // استخراج dosage_form و price
                            final dosageForm =
                                (item is Map && item.containsKey('dosage_form'))
                                    ? item['dosage_form']?.toString() ?? 'N/A'
                                    : 'N/A';
                            final price =
                                (item is Map && item.containsKey('price'))
                                    ? item['price']?.toString() ?? 'N/A'
                                    : 'N/A';

                            return ListTile(
                              title: Text('• $name'),
                              onTap: () {
                                // الانتقال لشاشة تفاصيل الدواء
                                Navigator.pushNamed(
                                  context,
                                  RouteNames
                                      .drugDetailsNoImage, // اسم الـ route الخاص بشاشة التفاصيل بدون صورة
                                  arguments: {
                                    'name': name,
                                    'company': company,
                                    'description': description,
                                    'sideEffects':
                                        sideEffectsString, // نرسلها كـ String مفصولة بفاصلة
                                    'price': price,
                                    'dosage_form': dosageForm,
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
