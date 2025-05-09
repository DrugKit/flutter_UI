import 'dart:async';
import 'package:drugkit/Navigation/routes_names.dart';
import 'package:drugkit/logic/category/category_cubit.dart';
import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:drugkit/logic/search/search_cubit.dart';
import 'package:drugkit/logic/searchdrugname/drug_details_cubit.dart';
import 'package:drugkit/screens/drugdetails_loader.dart';
import 'package:drugkit/screens/user_profile.dart';
import 'package:drugkit/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryCubit()..getCategories()),
        BlocProvider(create: (_) => SearchCubit()),
      ],
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final Color primaryColor = const Color(0xFF0C1467);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _currentIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        SearchCubit.get(context).searchDrugByName(query);
      } else {
        SearchCubit.get(context).clearResults();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DrawerHeader(
              child: Icon(Icons.account_circle,
                  size: 60, color: Color(0xFF0C1467)),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF0C1467)),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF0C1467)),
              title: const Text("History"),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.myPrescriptions);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: Color(0xFF0C1467)),
              title: const Text("Requests"),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.myRequests);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF0C1467)),
              title: const Text("Log out"),
              onTap: () async {
                await StorageData.clearStorage(); // يمسح التوكن والبيانات
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.login, (route) => false);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Image.asset('assets/pilllogo.png', height: 30),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF0C1467)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(context),
                  decoration: const InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchSuccess) {
                    if (state.drugs.isEmpty) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          ListTile(title: Text("No drug found"))
                        ],
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.drugs.length,
                        itemBuilder: (context, index) {
                          final drug = state.drugs[index];
                          return ListTile(
                            title: Text(drug.name),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => DrugDetailsCubit()
                                      ..getDrugDetails(drug.name),
                                    child: DrugDetailsLoaderScreen(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  } else if (state is SearchError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              const CategoryScroll(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  FeatureIcon(
                    image: 'assets/sypmptomchecker.png',
                    label: "Symptoms Diagnoses",
                    description:
                        "Describe your symptoms\nand get AI-powered\ndrug suggestions.",
                  ),
                  FeatureIcon(
                    image: 'assets/pointer.png',
                    label: "Nearest Pharmacy",
                    description:
                        "Find pharmacies near\nyou with available\nstock.",
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
                    description:
                        "Check if your medications\nare safe to take\ntogether.",
                  ),
                  FeatureIcon(
                    image: 'assets/document-scanner_11857562.png',
                    label: "Prescription Scan",
                    description:
                        "Upload a prescription image\nand get instant drug\nidentification.",
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 1:
              Navigator.pushNamed(context, RouteNames.nearestPharmacy);
              break;
            case 2:
              Navigator.pushNamed(context, RouteNames.drugRecommendation);
              break;
            // Add more cases later if needed
          }
        },
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35), label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/nearestpharmacyIcon.png'),
                  size: 35),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/drugRecommendationIcon.png'),
                  size: 35),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/interaction.png'), size: 35),
              label: ""),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/chatbotIcon.png'), size: 35),
              label: ""),
        ],
      ),
    );
  }
}

// 🔥 CategoryScroll
class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategorySuccess) {
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    String fullImageUrl =
                        'https://drugkit.runasp.net/${category.imageUrl}'
                            .replaceAll('.svg', '.png');
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.category,
                          arguments: {
                            'categoryId': category.id,
                            'name': category.name,
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 80,
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  fullImageUrl,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is CategoryError) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

// 🔥 FeatureIcon
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
