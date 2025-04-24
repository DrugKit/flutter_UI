import 'package:flutter/material.dart';
import 'package:drugkit/screens/drug_categories.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Drug drug;

  const DrugDetailsScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drug.name),
        backgroundColor: const Color(0xFF0C1467),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ صورة الدواء
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                drug.imagePath,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),

            // 📋 تفاصيل الدواء
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drug.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C1467),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Dosage type: ${drug.type}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: ${drug.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    drug.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Side Effects:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    drug.sideEffects,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
