import 'package:flutter/material.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Map<String, String> drug;

  const DrugDetailsScreen({required this.drug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Drug details',
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                drug['image']!,
                height: 180,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, size: 100),
              ),
            ),
            SizedBox(height: 24),
            _buildSection("Name:", drug['name'] ?? ''),
            _buildSection("Form:", drug['form'] ?? ''),
            _buildSection("Price:", drug['price'] ?? 'N/A'),
            _buildSection("Company:", drug['company'] ?? ''),
            _buildSection("Description:", drug['description'] ?? ''),
            SizedBox(height: 12),
            Text("Side Effects:-", style: _titleStyle()),
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
      padding: EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          text: '$title\n',
          style: _titleStyle(),
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

  TextStyle _titleStyle() => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color(0xFF0C1467),
      );
}
