// lib/logic/barcode/BarcodeScanState.dart
import 'package:equatable/equatable.dart'; // ستحتاج لإضافة equatable في pubspec.yaml

abstract class BarcodeScanState extends Equatable {
  const BarcodeScanState();

  @override
  List<Object?> get props => [];
}

class BarcodeScanInitial extends BarcodeScanState {}

class BarcodeScanLoading extends BarcodeScanState {}

class BarcodeScanSuccess extends BarcodeScanState {
  final List<dynamic> data; // قائمة الأدوية التي تم العثور عليها

  const BarcodeScanSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class BarcodeScanError extends BarcodeScanState {
  final String message;

  const BarcodeScanError(this.message);

  @override
  List<Object?> get props => [message];
}