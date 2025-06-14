import 'dart:async';
import 'package:drugkit/Navigation/routes_names.dart';
import 'package:drugkit/logic/analysis/inbody_cubit.dart';
import 'package:drugkit/logic/analysis/inbody_state.dart';
import 'package:drugkit/logic/category/category_cubit.dart';
import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:drugkit/logic/prescription/PrescriptionUploadCubit.dart';
import 'package:drugkit/logic/prescription/PrescriptionUploadState.dart';
import 'package:drugkit/logic/search/search_cubit.dart';
import 'package:drugkit/logic/searchdrugname/drug_details_cubit.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:drugkit/screens/drugdetails_loader.dart';
import 'package:drugkit/screens/handlePrescriptionUpload.dart';
import 'package:drugkit/screens/prescriptionscan_loading.dart';
import 'package:drugkit/screens/user_profile.dart';
import 'package:drugkit/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

// استيراد BarcodeScanCubit
import 'package:drugkit/logic/barcode/BarcodeScanCubit.dart';
import 'package:drugkit/logic/barcode/BarcodeScanState.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryCubit()..getCategories()),
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(create: (_) => PrescriptionUploadCubit()),
        BlocProvider(create: (_) => InbodyCubit()), // Add InbodyCubit here
        // BarcodeScanCubit should be provided at a higher level (e.g., main.dart)
        // or specifically in the BarcodeScannerScreen to avoid unnecessary re-creations.
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _currentIndex = 0;
  bool _isPrescriptionDialogShowing = false;
  bool _isInbodyDialogShowing = false; // New flag for InBody Dialog

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

  // Helper function to show loading dialog (used for both prescription and InBody)
  void _showLoadingDialog(
      BuildContext context, String message, String subMessage,
      {bool isDismissible = false, bool forInbody = false}) {
    if ((forInbody && !_isInbodyDialogShowing) ||
        (!forInbody && !_isPrescriptionDialogShowing)) {
      if (forInbody) {
        _isInbodyDialogShowing = true;
      } else {
        _isPrescriptionDialogShowing = true;
      }

      showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (dialogContext) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ).then((_) {
        if (forInbody) {
          _isInbodyDialogShowing = false;
        } else {
          _isPrescriptionDialogShowing = false;
        }
      });
    }
  }

  // Helper function to show error dialog (used for both prescription and InBody)
  void _showErrorDialog(BuildContext context, String message,
      {bool forInbody = false}) {
    if ((forInbody && !_isInbodyDialogShowing) ||
        (!forInbody && !_isPrescriptionDialogShowing)) {
      if (forInbody) {
        _isInbodyDialogShowing = true;
      } else {
        _isPrescriptionDialogShowing = true;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  if (forInbody) {
                    _isInbodyDialogShowing = false;
                  } else {
                    _isPrescriptionDialogShowing = false;
                  }
                },
              ),
            ],
          );
        },
      ).then((_) {
        if (forInbody) {
          _isInbodyDialogShowing = false;
        } else {
          _isPrescriptionDialogShowing = false;
        }
      });
    }
  }

  // Helper function to show InBody success dialog
  void _showInbodySuccessDialog(BuildContext context, String pdfUrl) {
    if (!_isInbodyDialogShowing) {
      _isInbodyDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Report Ready!'),
            content: const Text(
                'Your InBody analysis is complete. Click below to view your report.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Download Report'),
                onPressed: () async {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  _isInbodyDialogShowing = false;
                  await _launchUrl(
                      'https://ruuue-clinical-report-analyzer.hf.space' +
                          pdfUrl); // Launch the PDF URL
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  _isInbodyDialogShowing = false;
                },
              ),
            ],
          );
        },
      ).then((_) {
        _isInbodyDialogShowing = false;
      });
    }
  }

  // Helper function to hide any dialog
  void _hideDialog(BuildContext context, {bool forInbody = false}) {
    if ((forInbody && _isInbodyDialogShowing) ||
        (!forInbody && _isPrescriptionDialogShowing)) {
      Navigator.of(context, rootNavigator: true).pop();
      if (forInbody) {
        _isInbodyDialogShowing = false;
      } else {
        _isPrescriptionDialogShowing = false;
      }
    }
  }

  // Function to launch URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // You can show a SnackBar or another dialog here if the URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for PrescriptionUploadCubit
        BlocListener<PrescriptionUploadCubit, PrescriptionUploadState>(
          listener: (context, state) {
            if (state is PrescriptionUploadLoading) {
              _showLoadingDialog(
                  context,
                  'Please wait while we process your prescription...',
                  'This may take up to a minute.');
            } else if (state is PrescriptionUploadSuccess) {
              _hideDialog(context);
              context.read<PrescriptionUploadCubit>().resetState();
              Navigator.pushNamed(
                context,
                RouteNames.prescriptionScan,
                arguments: state.data,
              );
            } else if (state is PrescriptionUploadError) {
              _hideDialog(context);
              context.read<PrescriptionUploadCubit>().resetState();
              _showErrorDialog(context, state.message);
            }
          },
        ),
        // Listener for InbodyCubit
        BlocListener<InbodyCubit, InbodyState>(
          listener: (context, state) {
            if (state is InbodyLoading) {
              _showLoadingDialog(
                context,
                'Analyzing your InBody report...',
                'This may take a moment.',
                forInbody: true,
              );
            } else if (state is InbodySuccess) {
              _hideDialog(context, forInbody: true);
              context
                  .read<InbodyCubit>()
                  .resetState(); // Reset state after success
              _showInbodySuccessDialog(context, state.pdfUrl);
            } else if (state is InbodyError) {
              _hideDialog(context, forInbody: true);
              context
                  .read<InbodyCubit>()
                  .resetState(); // Reset state after error
              _showErrorDialog(context, state.message, forInbody: true);
            }
          },
        ),
      ],
      child: Scaffold(
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
                  await StorageData.clearStorage();
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.login, (route) => false);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Image.asset('assets/pilllogo.png', height: 30),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xEDF1F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _onSearchChanged(context),
                    decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Color(0xFF0C1467)),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Color(0xFF0C1467)),
                    ),
                    style: const TextStyle(color: Color(0xFF0C1467)),
                  ),
                ),
                const SizedBox(height: 5),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, searchState) {
                    if (searchState is SearchSuccess) {
                      if (searchState.drugs.isEmpty) {
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
                          itemCount: searchState.drugs.length,
                          itemBuilder: (context, index) {
                            final drug = searchState.drugs[index];
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
                    } else if (searchState is SearchError) {
                      return Center(child: Text(searchState.errorMessage));
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
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // First column
                      Column(
                        children: [
                          FeatureIcon(
                            image: 'assets/document-scanner_11857562.png',
                            label: "Prescription Reader",
                            description: const Text(
                              "Upload a prescription image\nand get instant drug\nidentification.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                context
                                    .read<PrescriptionUploadCubit>()
                                    .uploadPrescription(image);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FeatureIcon(
                            image: 'assets/barcode_9113724.png',
                            label: "Barcode Scanner",
                            description: const Text(
                              "Scan a drug’s barcode to view\nfull details, usage, and safety\ninformation.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteNames.barcodeScan);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Second column
                      Column(
                        children: [
                          FeatureIcon(
                            image: 'assets/NEPH.png',
                            label: "Nearest Pharmacy",
                            description: const Text(
                              "Find the closest\npharmacy to your\ncurrent location.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteNames.nearestPharmacy);
                            },
                          ),
                          const SizedBox(height: 20),
                          FeatureIcon(
                            image: 'assets/sypmptomchecker.png',
                            label: "Symptoms Diagnoses",
                            description: Text(
                              "Describe your symptoms\nand get AI-powered\ndrug suggestions.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.chatBot);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Third column (scroll to reveal)
                      Column(
                        children: [
                          FeatureIcon(
                            image: 'assets/me.png',
                            label: "InBody Insights",
                            description: const Text(
                              "Upload your InBody result\nand get personalized\nhealth insights.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () async {
                              // Pick file (image or PDF)
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'pdf',
                                  'jpg',
                                  'jpeg',
                                  'png'
                                ],
                              );

                              if (result != null &&
                                  result.files.single.path != null) {
                                PlatformFile file = result.files.single;
                                // Trigger InBody upload
                                context
                                    .read<InbodyCubit>()
                                    .uploadInbodyReport(file);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FeatureIcon(
                            image: 'assets/thumbs-up.png',
                            label: "Drug Recommendation",
                            description: const Text(
                              "Find safe and\neffective alternatives\nto your medications.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B6B),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteNames.drugRecommendation);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
              case 0: // Home
                break;
              case 1: // Nearest Pharmacy
                Navigator.pushNamed(context, RouteNames.nearestPharmacy);
                break;
              case 2: // Drug Recommendation
                Navigator.pushNamed(context, RouteNames.drugRecommendation);
                break;
              case 3: // Barcode Scanner (في BottomNavigationBar)
                Navigator.pushNamed(context, RouteNames.barcodeScan);
                break;
              case 4: // ChatBot
                Navigator.pushNamed(context, RouteNames.chatBot);
                break;
            }
          },
          backgroundColor: const Color(0xFF0C1467),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 35), label: ""),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/nearestPharmacy.png'),
                    size: 35),
                label: ""),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/drugRecommendationIcon.png'),
                    size: 35),
                label: ""),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/barcodeicon.png'), size: 35),
                label: ""),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/chatbotIcon.png'), size: 35),
                label: ""),
          ],
        ),
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
                                color: Color(0xFF0C1467),
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

class FeatureIcon extends StatelessWidget {
  final String image;
  final String label;
  final Widget description;
  final VoidCallback? onTap;

  const FeatureIcon({
    super.key,
    required this.image,
    required this.label,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
          description,
        ],
      ),
    );
  }
}
