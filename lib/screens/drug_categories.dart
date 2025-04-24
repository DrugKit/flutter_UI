import 'package:flutter/material.dart';

class Drug {
  final String name;
  final String type;
  final String imagePath;

  Drug({required this.name, required this.type, required this.imagePath});
}

class DrugsListScreen extends StatefulWidget {
  final String categoryTitle;

  DrugsListScreen({required this.categoryTitle});

  @override
  _DrugsListScreenState createState() => _DrugsListScreenState();
}

class _DrugsListScreenState extends State<DrugsListScreen> {
  final List<Drug> allDrugs = List.generate(
    24,
    (index) => Drug(
      name: ['Panadol', 'Mediator', 'Oplex-N'][index % 3],
      type: ['Tablets', 'Tablets', 'Syrup'][index % 3],
      imagePath: [
        'assets/panadol.png',
        'assets/mediator.png',
        'assets/oplex.png'
      ]
      [index % 3],
    ),
  );

  int currentPage = 1;
  final int drugsPerPage = 12;

  List<Drug> getPaginatedDrugs() {
    final startIndex = (currentPage - 1) * drugsPerPage;
    final endIndex = startIndex + drugsPerPage;
    return allDrugs.sublist(
        startIndex, endIndex > allDrugs.length ? allDrugs.length : endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final paginatedDrugs = getPaginatedDrugs();
    final totalPages = (allDrugs.length / drugsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // Hide default app bar space
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // 🔍 Search bar
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C6B), // Dark blue
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // 🩺 Category title
              Text(
                widget.categoryTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C6B),
                ),
              ),

              SizedBox(height: 16),

              // 🧩 Drug cards
              Expanded(
                child: GridView.builder(
                  itemCount: paginatedDrugs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final drug = paginatedDrugs[index];

                    return InkWell(
                      onTap: () {
                        // Navigate to details screen (to be implemented)
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                drug.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              drug.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              drug.type,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),

              // 🔢 Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  final pageNum = index + 1;
                  final isSelected = pageNum == currentPage;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage = pageNum;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF2C2C6B) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        '$pageNum',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      // 🏠 Bottom navigation bar if needed
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Color(0xFF2C2C6B),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/scanner.png'), size: 35),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/interaction checker.png'),
                  size: 35),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/chatbot.png'), size: 35),
              label: ""),
        ],
      ),
    );
  }
}
