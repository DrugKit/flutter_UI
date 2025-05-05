import 'package:bloc/bloc.dart';
import 'package:drugkit/models/recommended_drug_model.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter/foundation.dart';

part 'drug_recommendation_state.dart';

class DrugRecommendationCubit extends Cubit<DrugRecommendationState> {
  DrugRecommendationCubit() : super(DrugRecommendationInitial());

  Future<void> getRecommendationsByDrugName(String drugName) async {
    emit(DrugRecommendationLoading());

    try {
      // ✅ تحديث التوكن قبل أي request
      DioHelper().updateToken();
      print("TOKEN IS: ${DioHelper().getToken()}");

      final response = await DioHelper().getData(
        path: "Drug/GetDrugsRecomendationByDrugName",
        queryParams: {"drugName": drugName},
      );

      final List<dynamic> data = response.data;
      final drugs =
          data.map((json) => DrugRecommendationModel.fromJson(json)).toList();

      emit(DrugRecommendationSuccess(drugs));
    } catch (e) {
      if (kDebugMode) {
        print("Recommendation Error: $e");
      }
      emit(DrugRecommendationError("Failed to load recommendations."));
    }
  }
}
