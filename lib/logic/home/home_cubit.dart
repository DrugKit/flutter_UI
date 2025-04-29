import 'package:bloc/bloc.dart';
import 'package:drugkit/models/category.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    try {
      final response = await DioHelper().getData(path: "Category");

      categories = (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      emit(HomeSuccess());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
