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
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0C1467)),
            onPressed: () {
              // Notifications action
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
              //  Search bar
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

              // 🧭 Categories Horizontal Scroll
              const CategoryScroll(),

              const SizedBox(height: 20),

              // ⭐ Features
              const Text(
                "Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1467),
                ),
              ),
              const SizedBox(height: 10),

              Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: const [
    FeatureIcon(
      image: 'assets/sypmptomchecker.png',
      label: "Symptoms Diagnoses",
      description: "Describe your symptoms\n and get AI-powered\n drug suggestions.",
    ),
    FeatureIcon(
      image: 'assets/pointer.png',
      label: "Nearest Pharmacy",
      description: "Find pharmacies near\nyou with available\nstock.",
    ),
  ],
),
const SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: const [
    FeatureIcon(
      image: 'assets/medicines_4278884.png',
      label: "Interaction Checker",
      description: "Check if your medications\nare safe to take \ntogether.",
    ),
    FeatureIcon(
      image: 'assets/document-scanner_11857562.png',
      label: "Prescription Scan",
      description: "Upload a prescription image \nand get instant drug \nidentification.",
    ),
  ],
),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: ""),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/scanner.png'), size: 35), label: ""),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/interaction checker.png'), size: 35), label: ""),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/chatbot.png'), size: 35), label: ""),
        ],
      ),
    );
  }
}

// 🔁 Category Scroll Widget with interaction
class CategoryScroll extends StatefulWidget {
  const CategoryScroll({super.key});

  @override
  State<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  int selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {'title': 'Pain Relief', 'image': 'assets/pain.jpeg'},
    {'title': 'Skin', 'image': 'assets/skin.png'},
    {'title': 'Heart', 'image': 'assets/heart.png'},
    {'title': 'Headache', 'image': 'assets/headache.jpeg'},
    {'title': 'Muscles', 'image': 'assets/muscles.jpeg'},
    {'title': 'Eye & Ear', 'image': 'assets/ear&nose.png'},
    {'title': 'Cold & Flu', 'image': 'assets/cold&flu.png'},
    {'title': 'Diabetes', 'image': 'assets/diabetes.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categories",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C1467),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: isSelected ? 90 : 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  categories[index]['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              categories[index]['title']!,
                              style: TextStyle(
                                fontSize: isSelected ? 14 : 15,

                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0C1467)),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔁 Feature Icon Widget
class FeatureIcon extends StatelessWidget {
  final String image;
  final String label;
  final String description;

  const FeatureIcon({
    super.key,
    required this.image,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C1467),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: const TextStyle(
            fontSize: 11,
            color: Color.fromARGB(255, 149, 143, 143),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
