
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF0C1467);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Image.asset('assets/pilllogo.png', height: 30),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF0C1467)),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1467),
                ),
              ),
              const SizedBox(height: 9),
              // Categories Grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
                children: const [
                  CategoryCard(title: 'Pain Relief', image: 'assets/pain.jpeg'),
                  CategoryCard(title: 'Skin', image: 'assets/skin.png'),
                  CategoryCard(title: 'Heart', image: 'assets/heart.png'),
                  CategoryCard(
                      title: 'Headache', image: 'assets/headache.jpeg'),
                  CategoryCard(title: 'Muscles', image: 'assets/muscles.jpeg'),
                  CategoryCard(
                      title: 'Eye & Ear', image: 'assets/ear&nose.png'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1467),
                ),
              ),
              const SizedBox(height: 10),
              // Features using images instead of icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  FeatureIcon(
                      image: 'assets/sypmptomchecker.png',
                      label: "symptoms diagnoses"),
                  FeatureIcon(
                      image: 'assets/pointer.png', label: "Nearest Pharmacy"),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  FeatureIcon(
                      image: 'assets/medicines_4278884.png',
                      label: "Interaction Checker"),
                  FeatureIcon(
                      image: 'assets/document-scanner_11857562.png',
                      label: "Prescription Scan"),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0C1467),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type:BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size:30), label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/scanner.png'), size:30), label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/interaction checker.png'), size:30),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/chatbot.png'), size:30), label: ""),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;

  const CategoryCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset(image)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class FeatureIcon extends StatelessWidget {
  final String image;
  final String label;

  const FeatureIcon({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
