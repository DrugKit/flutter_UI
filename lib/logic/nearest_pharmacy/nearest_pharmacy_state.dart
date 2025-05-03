part of 'nearest_pharmacy_cubit.dart';

abstract class NearestPharmacyState {}

class NearestPharmacyInitial extends NearestPharmacyState {}

class NearestPharmacyLoading extends NearestPharmacyState {}

class NearestPharmacySuccess extends NearestPharmacyState {
  final List<NearestPharmacyModel> pharmacies;

  NearestPharmacySuccess(this.pharmacies);
}

class NearestPharmacyError extends NearestPharmacyState {
  final String message;

  NearestPharmacyError(this.message);
}
