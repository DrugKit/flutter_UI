import 'package:bloc/bloc.dart';
import 'package:drugkit/models/drug.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();

  List<DrugModel> drugs = [];

  Future<void> searchDrugByName(String prefix) async {
    if (prefix.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await _dioHelper.getData(
        path: "Drug/AutoComplete",
        queryParams: {"prefix": prefix},
      );

      if (response.statusCode == 200) {
        drugs = List<DrugModel>.from(
          (response.data as List).map((e) => DrugModel.fromJson(e)),
        );
        drugs = drugs.take(5).toList(); // نجيب أول 5 فقط
        emit(SearchSuccess(drugs));
      } else {
        emit(SearchSuccess([]));
      }
    } catch (e) {
      emit(SearchSuccess([]));
    }
  }

  // 🧹 Clear results method
  void clearResults() {
    drugs.clear();
    emit(SearchInitial()); // ⬅️ كده هنعرف إنها الحالة المبدئية
  }
}
