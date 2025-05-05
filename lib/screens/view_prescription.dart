import 'package:flutter/material.dart';
import 'package:drugkit/models/prescription_history_model.dart';
import 'package:drugkit/Navigation/routes_names.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  final PrescriptionHistoryModel prescription;

  const PrescriptionDetailsScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          "Prescription ${prescription.id}",
          style: const TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (prescription.imgUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://drugkit.runasp.net/Images${prescription.imgUrl}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Medicines Found:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1467),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tap a medicine to view more info",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: prescription.prescriptionDrugs.length,
                itemBuilder: (context, index) {
                  final drug = prescription.prescriptionDrugs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("• ${drug.name}"),
                    onTap: () {
                      // Navigate to drug details if needed
                      Navigator.pushNamed(
                        context,
                        RouteNames.drugDetailsNoImage,
                        arguments: {
                          'name': drug.name,
                          'price': drug.price.toString(),
                          'company': drug.company,
                          'description': drug.description,
                          'sideEffects': drug.sideEffects.join(','),
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
  }
}
