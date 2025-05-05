part of 'prescription_history_cubit.dart';

@immutable
abstract class PrescriptionHistoryState {}

class PrescriptionHistoryInitial extends PrescriptionHistoryState {}

class PrescriptionHistoryLoading extends PrescriptionHistoryState {}

class PrescriptionHistorySuccess extends PrescriptionHistoryState {
  final List<PrescriptionHistoryModel> prescriptions;

  PrescriptionHistorySuccess(this.prescriptions);
}

class PrescriptionHistoryError extends PrescriptionHistoryState {
  final String message;

  PrescriptionHistoryError(this.message);
}
