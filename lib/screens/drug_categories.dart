import 'dart:async';

import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:drugkit/logic/search/search_cubit.dart';
import 'package:drugkit/logic/searchdrugname/drug_details_cubit.dart';
import 'package:drugkit/screens/drugdetails_loader.dart';
import 'package:flutter/material.dart';
import 'package:drugkit/screens/drugdetails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDrugsScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId; // ✅ إضافة المتغير

  const CategoryDrugsScreen({
    required this.categoryName,
    required this.categoryId, // ✅ استقبال المتغير
  });

  @override
  State<CategoryDrugsScreen> createState() => _CategoryDrugsScreenState();
}

class _CategoryDrugsScreenState extends State<CategoryDrugsScreen> {
  int _currentPage = 1;
  late int _totalPages;

  @override
  void initState() {
    super.initState();
    context.read<GetcategoryCubit>().getCategoryDrugs(
          categoryId: widget.categoryId, // ✅ استخدام id المرسل من navigation
          pageNumber: _currentPage,
        );
  }

  void _fetchPage(int page) {
    setState(() {
      _currentPage = page;
    });
    context.read<GetcategoryCubit>().getCategoryDrugs(
          categoryId: widget.categoryId, // ✅ استخدام نفس الـ id هنا
          pageNumber: page,
        );
  }

  final Color primaryColor = const Color(0xFF0C1467);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
      backgroundColor: Colors.white,
      appBar:
          AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
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
            const SizedBox(height: 20),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchSuccess) {
                  if (state.drugs.isEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        ListTile(title: Text("No drug found")),
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
            // const SizedBox(height: 16),
            Center(
              child: Text(widget.categoryName,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C1467))),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<GetcategoryCubit, GetcategoryState>(
                builder: (context, state) {
                  if (state is GetcategoryLoading) {
                    return _buildShimmerGrid();
                  } else if (state is GetcategorySuccess) {
                    final cubit = context.read<GetcategoryCubit>();
                    final drugs = cubit.getCategoryModel.result ?? [];

                    return GridView.builder(
                      itemCount: drugs.length,
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                builder: (_) => BlocProvider(
                                  create: (_) => DrugDetailsCubit()
                                    ..getDrugDetails(drug.name ?? ''),
                                  child: DrugDetailsLoaderScreen(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    'https://drugkit.runasp.net/${drug.imageUrl}',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, _, __) =>
                                        const Icon(Icons.image, size: 48),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  drug.name ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  drug.dosageForm ?? '',
                                  style: const TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetcategoryError) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            BlocBuilder<GetcategoryCubit, GetcategoryState>(
              builder: (context, state) {
                if (state is GetcategorySuccess) {
                  _totalPages = ((context
                                  .read<GetcategoryCubit>()
                                  .getCategoryModel
                                  .categoryCount ??
                              1) /
                          9)
                      .ceil();
                  return NumberPaginator(
                    numberPages: _totalPages,
                    initialPage: _currentPage - 1, // تبدأ من 0
                    onPageChange: (int index) {
                      _fetchPage(index + 1); // عشان index يبدأ من 0
                    },
                    config: NumberPaginatorUIConfig(
                      buttonSelectedBackgroundColor: Color(0xFF0C1467),
                      buttonUnselectedBackgroundColor: Colors.grey.shade300,
                      buttonShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xEDF1F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Color(0xFF0C1467)),
          icon: Icon(Icons.search, color: Color(0xFF0C1467)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      itemCount: 9,
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
