import 'dart:async';

import 'package:drugkit/logic/drug_recommendation/drug_recommendation_cubit.dart';
import 'package:drugkit/logic/search/search_cubit.dart';
import 'package:drugkit/logic/searchdrugname/drug_details_cubit.dart';
import 'package:drugkit/screens/drugdetails.dart';
import 'package:drugkit/screens/drugdetails_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrugRecommendationScreen extends StatefulWidget {
  const DrugRecommendationScreen({super.key});

  @override
  State<DrugRecommendationScreen> createState() =>
      _DrugRecommendationScreenState();
}

class _DrugRecommendationScreenState extends State<DrugRecommendationScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String selectedDrugName = "";
  bool hasSearched = false;

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

  void _fetchRecommendations(String drugName) {
    selectedDrugName = drugName;
    hasSearched = true;
    BlocProvider.of<DrugRecommendationCubit>(context)
        .getRecommendationsByDrugName(drugName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrugRecommendationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Drug Recommendation',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0C1467)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔍 Search Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1467),
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
                      return const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: ListTile(title: Text("No drug found")),
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
                              _searchController.text = drug.name;
                              FocusScope.of(context).unfocus();
                              SearchCubit.get(context).clearResults();

                              setState(() {
                                hasSearched = true;
                                selectedDrugName = drug.name;
                              });

                              BlocProvider.of<DrugRecommendationCubit>(context)
                                  .getRecommendationsByDrugName(drug.name);
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
              const SizedBox(height: 10),
              Expanded(
                child: hasSearched
                    ? BlocBuilder<DrugRecommendationCubit,
                        DrugRecommendationState>(
                        builder: (context, state) {
                          if (state is DrugRecommendationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is DrugRecommendationSuccess) {
                            if (state.drugs.isEmpty) {
                              return const Center(
                                  child: Text("No alternatives found"));
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alternatives for: $selectedDrugName",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0C1467),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.7,
                                    children: state.drugs.map((drug) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => DrugDetailsScreen(
                                                drug: {
                                                  'name': drug.name,
                                                  'description':
                                                      drug.description ?? '',
                                                  'company': drug.company ?? '',
                                                  'form': drug.dosageForm ?? '',
                                                  'image':
                                                      'https://drugkit.runasp.net/${drug.imageUrl}' ??
                                                          '',
                                                  'price':
                                                      drug.price.toString(),
                                                  'sideEffects': drug
                                                          .sideEffects
                                                          ?.join(", ") ??
                                                      '',
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F5F5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: drug.imageUrl != null
                                                    ? Image.network(
                                                        "https://drugkit.runasp.net/${drug.imageUrl}",
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons.image),
                                                      )
                                                    : const Icon(Icons.image),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                drug.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                drug.dosageForm ?? '',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else if (state is DrugRecommendationError) {
                            return Center(child: Text(state.message));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/search_med.png", height: 140),
                          const SizedBox(height: 12),
                          const Text(
                            "Please enter a drug name to see alternatives.",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
