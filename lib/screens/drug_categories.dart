import 'package:drugkit/logic/category_details/cubit/getcategory_cubit.dart';
import 'package:flutter/material.dart';
import 'package:drugkit/screens/drugdetails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_pagination/number_pagination.dart';
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
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
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
                                builder: (_) => DrugDetailsScreen(drug: {
                                  'name': drug.name ?? '',
                                  'form': drug.dosageForm ?? '',
                                  'image':
                                      'https://drugkit.runasp.net/${drug.imageUrl}',
                                  'description': drug.description ??
                                      'No description provided.',
                                  'company': drug.company ?? 'Unknown',
                                  'price': drug.price?.toString() ?? 'N/A',
                                  'sideEffects':
                                      (drug.sideEffects ?? []).join(', '),
                                }),
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
                  return NumberPagination(
                    onPageChanged: _fetchPage,
                    totalPages: _totalPages,
                    currentPage: _currentPage,
                    selectedButtonColor: Colors.blue,
                    unSelectedButtonColor: Colors.grey.shade300,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1467),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          icon: Icon(Icons.search, color: Colors.white),
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
