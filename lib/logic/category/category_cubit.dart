import 'package:bloc/bloc.dart';
import 'package:drugkit/models/category.dart';
import 'package:drugkit/models/category.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  static CategoryCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();

  List<CategoryModel> categories = [];

  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final response = await _dioHelper.getData(path: 'Category');
      final List<dynamic> data = response.data;
      categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      emit(CategorySuccess(categories));
    } catch (e) {
      emit(CategoryError("Failed to load categories: ${e.toString()}"));
    }
  }
}
