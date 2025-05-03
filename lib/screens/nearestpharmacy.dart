import 'package:flutter/material.dart';

class NearestPharmacyScreen extends StatelessWidget {
  const NearestPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pharmacies = [
      {'name': 'El shefaa', 'distance': '500m Away', 'phone': '01234567879'},
      {'name': 'El Ezaby', 'distance': '400m Away', 'phone': '01234567879'},
      {'name': 'El Hayah', 'distance': '600m Away', 'phone': '01234567879'},
      {'name': 'Dr Doaa', 'distance': '500m Away', 'phone': '01234567879'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: BackButton(),
        title: const Text(
          'Nearest Pharmacy',
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0C1467),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your current location....",
                    style: TextStyle(color: Colors.white),
                  ),
                  Image.asset('assets/locationIcon.png',
                      color: Colors.white, height: 24, width: 24),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: pharmacies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/location.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pharmacy['name']!,
                          style: const TextStyle(
                            color: Color(0xFF0C1467),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pharmacy['distance']!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phone: ${pharmacy['phone']}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
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
