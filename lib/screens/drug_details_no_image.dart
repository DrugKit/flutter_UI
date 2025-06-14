import 'package:flutter/material.dart';

class DrugDetailsNoImageScreen extends StatelessWidget {
  final Map<String, String> drug;

  const DrugDetailsNoImageScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Drug details',
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("Name:", drug['name'] ?? ''),
            // _buildSection("Price:", drug['price'] ?? 'N/A'), // <--- قم بإزالة هذا السطر أو التعليق عليه
            _buildSection("Company:", drug['company'] ?? ''),
            _buildSection("Description:", drug['description'] ?? ''),
            const SizedBox(height: 12),
            const Text("Side Effects:-", style: _titleStyle),
            ...(drug['sideEffects']?.split(',') ?? []).map(
              (e) => Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 4),
                child: Text("• ${e.trim()}",
                    style: TextStyle(color: Colors.grey[700])),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          text: '$title\n',
          style: _titleStyle,
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }

  static const TextStyle _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Color(0xFF0C1467),
  );
}