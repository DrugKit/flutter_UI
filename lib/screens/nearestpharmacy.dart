import 'package:flutter/material.dart';

class NearestPharmacyScreen extends StatelessWidget {
  const NearestPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pharmacies = [
      {'name': 'El shefaa', 'distance': '500m Away'},
      {'name': 'El Ezaby', 'distance': '400m Away'},
      {'name': 'El Hayah', 'distance': '600m Away'},
      {'name': 'Dr Doaa', 'distance': '500m Away'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: BackButton(),
        title: Text(
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
            // Current location button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF0C1467),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Your current location....",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.my_location, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Grid of pharmacies
            Expanded(
              child: GridView.builder(
                itemCount: pharmacies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/location.png', // replace with actual map or static image
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          pharmacy['name']!,
                          style: TextStyle(
                            color: Color(0xFF0C1467),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          pharmacy['distance']!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
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
