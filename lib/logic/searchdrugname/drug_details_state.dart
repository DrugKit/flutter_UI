part of 'drug_details_cubit.dart';

abstract class DrugDetailsState {}

class DrugDetailsInitial extends DrugDetailsState {}

class DrugDetailsLoading extends DrugDetailsState {}

class DrugDetailsSuccess extends DrugDetailsState {
  final Map<String, String> drug;

  DrugDetailsSuccess(this.drug);
}

class DrugDetailsFailure extends DrugDetailsState {
  final String error;

  DrugDetailsFailure(this.error);
}
