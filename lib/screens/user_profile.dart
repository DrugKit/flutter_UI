import 'package:drugkit/storage/storage_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = StorageData.getStorage(key: 'name') ?? 'N/A';
    final email = StorageData.getStorage(key: 'email') ?? 'N/A';
    final phone = StorageData.getStorage(key: 'phone') ?? 'N/A';
    const primaryColor = Color(0xFF0C1467);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage('assets/profile.png'), // ضع صورة افتراضية هنا
            ),
            const SizedBox(height: 24),
            _buildLabelField(label: 'Name:', value: name),
            const SizedBox(height: 12),
            _buildLabelField(label: 'Email:', value: email),
            const SizedBox(height: 12),
            _buildLabelField(label: 'Phone:', value: phone),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: handle edit
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
