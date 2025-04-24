import 'package:flutter/material.dart';

class PrescriptionResultScreen extends StatelessWidget {
  final List<Map<String, String>> medicines = [
    {
      'image': 'https://via.placeholder.com/150x100.png?text=Mediator',
      'description': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
    },
    {
      'image': 'https://via.placeholder.com/150x100.png?text=Lamictal',
      'description': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
    },
    {
      'image': 'https://via.placeholder.com/150x100.png?text=Optalidon',
      'description': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
    },
    {
      'image': 'https://via.placeholder.com/150x100.png?text=Medicine',
      'description': 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية الشاشة
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF0C1467)), // السهم كحلي
        title: Text(
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
               
              },
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text(
                "Upload Your Prescription",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1467),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: medicines.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عدد العناصر في كل صف
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final item = medicines[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Description:',
                          style: TextStyle(
                            color: Color(0xFF0C1467),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
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