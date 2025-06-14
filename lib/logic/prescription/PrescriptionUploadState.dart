import 'package:flutter/foundation.dart';

@immutable
abstract class PrescriptionUploadState {}

class PrescriptionUploadInitial extends PrescriptionUploadState {}

class PrescriptionUploadLoading extends PrescriptionUploadState {}

class PrescriptionUploadSuccess extends PrescriptionUploadState {
  final dynamic data; // ممكن تغيّرها لنوع موديل لو عندك موديل معين
  PrescriptionUploadSuccess(this.data);
}

class PrescriptionUploadError extends PrescriptionUploadState {
  final String message;
  PrescriptionUploadError(this.message);
}