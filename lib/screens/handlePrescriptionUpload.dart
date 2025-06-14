import 'package:flutter/material.dart';

class PrescriptionResultScreen extends StatelessWidget {
  const PrescriptionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استلام الوسيطات والتحقق بأمان من أنها قائمة
    final dynamic medicinesArguments =
        ModalRoute.of(context)!.settings.arguments;
    final List<dynamic> prescriptionMedicines = (medicinesArguments is List)
        ? medicinesArguments
        : []; // لو مش قائمة، خليها قائمة فاضية

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        leading: const BackButton(color: Color(0xFF0C1467)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // هنا ممكن تضيف إجراء لإعادة الرفع لو حبيت
                // يفضل إنك تخلي دالة الرفع (handlePrescriptionUpload) متاحة بشكل عام أو تمررها
                // Navigator.pop(context); // للرجوع للشاشة اللي فيها زر الرفع
              },
              icon: const Icon(Icons.upload_file, color: Color(0xFF0C1467)),
              label: const Text(
                'Upload Your Prescription',
                style: TextStyle(color: Color(0xFF0C1467)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5FF),
                elevation: 0,
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
                        // 2. التحقق بأمان من أن العنصر خريطة (Map) ويحتوي على مفتاح 'name'
                        final name = (item is Map && item.containsKey('name'))
                            ? item['name']?.toString() ?? 'Unknown'
                            : 'Unknown';
                        return ListTile(
                          title: Text('• $name'),
                          onTap: () {
                            // هنا ممكن تضيف توجيه لشاشة تفاصيل الدواء
                            // تأكد أنك تمرر اسم الدواء أو أي معرف آخر تحتاجه
                            // مثلاً:
                            // if (item is Map && item.containsKey('name')) {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (_) => BlocProvider(
                            //         create: (_) => DrugDetailsCubit()
                            //           ..getDrugDetails(item['name']),
                            //         child: DrugDetailsLoaderScreen(),
                            //       ),
                            //     ),
                            //   );
                            // }
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
