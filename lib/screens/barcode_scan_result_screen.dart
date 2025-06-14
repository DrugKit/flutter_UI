// lib/screens/barcode/barcode_scan_result_screen.dart
import 'package:drugkit/screens/drugdetails.dart';
import 'package:flutter/material.dart';
import 'package:drugkit/Navigation/routes_names.dart'; // تأكد من المسار الصحيح
// استيراد شاشة تفاصيل الدواء إذا لم تكن مستوردة من قبل في مكان ما بالـ routes.dart
// import 'package:drugkit/screens/drug_details_screen.dart'; // مسار افتراضي، تأكد من المسار الصحيح

class BarcodeScanResultScreen extends StatelessWidget {
  final List<dynamic> medicines; // قائمة الأدوية المستلمة

  const BarcodeScanResultScreen({super.key, required this.medicines});

  // دالة مساعدة لتحويل البيانات من تنسيق الـ API إلى التنسيق المطلوب بواسطة DrugDetailsScreen
  Map<String, String> _prepareDrugDataForDetailsScreen(
      Map<String, dynamic> apiDrug) {
    // تحويل السعر إلى String مع إضافة " EGP" (أو أي عملة أخرى)
    final String priceString = apiDrug['price'] != null
        ? apiDrug['price'].toStringAsFixed(2) + ' EGP'
        : 'N/A';

    // تحويل قائمة Side Effects إلى سلسلة نصية مفصولة بفواصل
    // تأكد أن apiDrug['sideEffects'] ليس null وهو من نوع List
    final String sideEffectsString = (apiDrug['sideEffects'] is List)
        ? (apiDrug['sideEffects'] as List).map((e) => e.toString()).join(',')
        : apiDrug['sideEffects']?.toString() ??
            ''; // في حالة كانت ليست قائمة أو null

    // التأكد من أن imageUrl هي String وليست null
    final String imageUrl = apiDrug['imageUrl']?.toString() ?? '';
    // إذا كانت imageUrl مسارًا نسبيًا، فستحتاج إلى إضافة Base URL هنا.
    // مثال:
    // final String fullImageUrl = "https://your_base_api_url.com/" + imageUrl;

    return {
      'name': apiDrug['name']?.toString() ?? 'Unknown',
      'form': apiDrug['dosage_form']?.toString() ??
          'N/A', // استخدام dosage_form بدلاً من form
      'price': priceString, // استخدام السعر المحول
      'company': apiDrug['company']?.toString() ?? 'N/A',
      'description':
          apiDrug['description']?.toString() ?? 'No description available.',
      'sideEffects': sideEffectsString, // استخدام الـ sideEffects المحولة
      'image':
          "https://drugkit.runasp.net/$imageUrl", // استخدام imageUrl بدلاً من image (إذا لم تعدل DrugDetailsScreen فستحتاج إلى استخدام 'image' هنا)
      // إذا كانت شاشة التفاصيل تتوقع مفتاح 'image' وليس 'imageUrl'، اتركها كما هي.
      // إذا كانت DrugDetailsScreen تتوقع 'image' فعلاً، قم بتمرير imageUrl لها كـ 'image'
      // 'image': apiDrug['imageUrl']?.toString() ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Color(0xFF0C1467)),
        title: const Text(
          'Barcode Scan Results',
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
              child: medicines.isEmpty
                  ? const Center(
                      child: Text(
                        'No medicines found for this barcode.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final item = medicines[index] as Map<String,
                            dynamic>; // تأكد أن item هي Map<String, dynamic>

                        // استخدم الدالة المساعدة لتحويل البيانات
                        final Map<String, String> drugForDetails =
                            _prepareDrugDataForDetailsScreen(item);

                        return ListTile(
                          title: Text('• ${drugForDetails['name']}'),
                          onTap: () {
                            // الانتقال لشاشة تفاصيل الدواء باستخدام Navigator.push
                            // بما أنك لا تريد تعديل DrugDetailsScreen، سنستخدم Navigator.push
                            // ونمرر الكائن Map<String, String> مباشرةً
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DrugDetailsScreen(drug: drugForDetails),
                              ),
                            );

                            // إذا كنت مصرًا على استخدام Navigator.pushNamed
                            // (RouteNames.drugDetailsNoImage)، يجب أن يكون الـ Route
                            // معرفًا في Navigation/routes_names.dart بحيث يستقبل Map<String, String>
                            // ويقوم ببناء DrugDetailsScreen منه.
                            // مثال لكيفية تعريف الـ route في ملف routes_names.dart (إذا لم يكن كذلك):
                            /*
                            class Routes {
                              static const String drugDetailsNoImage = '/drugDetailsNoImage';
                            }

                            class AppRouter {
                              static Route<dynamic> generateRoute(RouteSettings settings) {
                                switch (settings.name) {
                                  case Routes.drugDetailsNoImage:
                                    final drug = settings.arguments as Map<String, String>;
                                    return MaterialPageRoute(builder: (_) => DrugDetailsScreen(drug: drug));
                                  // ... other routes
                                  default:
                                    return MaterialPageRoute(builder: (_) => Text('Error: Unknown route'));
                                }
                              }
                            }
                            */
                            // في هذه الحالة ستستخدم:
                            // Navigator.pushNamed(
                            //   context,
                            //   RouteNames.drugDetailsNoImage,
                            //   arguments: drugForDetails,
                            // );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// تأكد من استيراد DrugDetailsScreen في هذا الملف
