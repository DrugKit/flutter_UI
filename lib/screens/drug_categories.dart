import 'package:flutter/material.dart';
import 'package:drugkit/screens/drugdetails.dart';

class CategoryDrugsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDrugsScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final drugs = List.generate(
      12,
      (index) => {
        'name': index % 2 == 0 ? 'Panadol' : 'Mediator',
        'form': index % 2 == 0 ? 'Tablets' : 'Syrup',
        'image': 'assets/panadol.png',
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 16),

            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFF0C1467),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Centered category title
            Center(
              child: Text(
                categoryName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1467),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Grid of drugs
            Expanded(
              child: GridView.builder(
                itemCount: drugs.length,
                padding: EdgeInsets.only(bottom: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final drug = drugs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DrugDetailsScreen(drug: drug),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              drug['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            drug['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            drug['form']!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Pagination
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor:
                            index == 0 ? Color(0xFF0C1467) : Colors.white,
                        foregroundColor:
                            index == 0 ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('${index + 1}'),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
