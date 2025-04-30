import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/network/api_endpoints.dart';

part 'drug_details_state.dart';

class DrugDetailsCubit extends Cubit<DrugDetailsState> {
  DrugDetailsCubit() : super(DrugDetailsInitial());

  Future<void> getDrugDetails(String drugName) async {
    emit(DrugDetailsLoading());
    try {
      final response = await DioHelper().getData(
        path: "Drug/GetDrugsDetailsByName",
        queryParams: {'drugName': drugName},
      );

      final data = response.data[0]; // Assuming response is a List

      emit(DrugDetailsSuccess({
        'id': data['id'].toString(),
        'name': data['name'] ?? '',
        'description': data['description'] ?? '',
        'company': data['company'] ?? '',
        'price': data['price'].toString(),
        'form': data['dosage_form'] ?? '',
        'barcode': data['barcode'] ?? '',
        'image': 'https://drugkit.runasp.net/${data['imageUrl']}' ?? '',
        'sideEffects': (data['sideEffects'] as List).join(','),
      }));
    } catch (e) {
      emit(DrugDetailsFailure(e.toString()));
    }
  }
}
