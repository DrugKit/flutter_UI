import 'package:bloc/bloc.dart';
import 'package:drugkit/models/getgategorydrugs.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:meta/meta.dart';

part 'getcategory_state.dart';

class GetcategoryCubit extends Cubit<GetcategoryState> {
  GetcategoryCubit() : super(GetcategoryInitial());
  final DioHelper _dioHelper = DioHelper();
  GetCategoryModel getCategoryModel = GetCategoryModel();
  Future<void> getCategoryDrugs(
      {required int categoryId, required int pageNumber}) async {
    emit(GetcategoryLoading());
    try {
      final response = await _dioHelper.getData(
          path:
              '${ApiUrl.getcategorydrugs}$categoryId?pageNumber=$pageNumber&pageSize=9');
      getCategoryModel = GetCategoryModel.fromJson(response.data);
      emit(GetcategorySuccess());
    } catch (e) {
      emit(GetcategoryError("Failed to load categories: ${e.toString()}"));
    }
  }
}
