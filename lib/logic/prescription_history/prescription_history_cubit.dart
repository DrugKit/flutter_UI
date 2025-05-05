import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:drugkit/models/prescription_history_model.dart';
import 'package:drugkit/network/api_service.dart';

part 'prescription_history_state.dart';

class PrescriptionHistoryCubit extends Cubit<PrescriptionHistoryState> {
  PrescriptionHistoryCubit() : super(PrescriptionHistoryInitial());

  Future<void> fetchPrescriptionHistory() async {
    emit(PrescriptionHistoryLoading());

    try {
      DioHelper().updateToken(); // ⬅️ ضروري جداً هنا

      final response = await DioHelper().getData(
        path: 'Prescription/getHistory',
      );

      final List<dynamic> data = response.data;
      final prescriptions =
          data.map((e) => PrescriptionHistoryModel.fromJson(e)).toList();

      emit(PrescriptionHistorySuccess(prescriptions));
    } catch (e) {
      print("❌ Error fetching prescriptions: $e");
      emit(PrescriptionHistoryError("Failed to load prescription history."));
    }
  }
}
