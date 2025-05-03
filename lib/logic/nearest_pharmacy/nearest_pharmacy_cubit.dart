import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/models/NearestPharmacyModel.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:drugkit/network/api_endpoints.dart';

part 'nearest_pharmacy_state.dart';

class NearestPharmacyCubit extends Cubit<NearestPharmacyState> {
  NearestPharmacyCubit() : super(NearestPharmacyInitial());

  Future<void> fetchNearestPharmacies(double lat, double lon) async {
    emit(NearestPharmacyLoading());

    try {
      final response = await DioHelper().getData(
        path: "Pharmacy/nearest",
        queryParams: {
          "latitude": lat,
          "longitude": lon,
        },
      );

      final List<dynamic> jsonList = response.data;
      final pharmacies = jsonList
          .map((e) => NearestPharmacyModel.fromJson(e))
          .toList();

      emit(NearestPharmacySuccess(pharmacies));
    } catch (e) {
      emit(NearestPharmacyError("Failed to load pharmacies"));
    }
  }
}
