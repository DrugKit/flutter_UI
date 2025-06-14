import 'package:equatable/equatable.dart';

abstract class InbodyState extends Equatable {
  const InbodyState();

  @override
  List<Object> get props => [];
}

// Initial state before anything happens
class InbodyInitial extends InbodyState {}

// State while the file is uploading and being analyzed
class InbodyLoading extends InbodyState {}

// State on successful analysis, holding the PDF URL
class InbodySuccess extends InbodyState {
  final String pdfUrl;

  const InbodySuccess(this.pdfUrl);

  @override
  List<Object> get props => [pdfUrl];
}

// State when an error occurs, holding the error message
class InbodyError extends InbodyState {
  final String message;

  const InbodyError(this.message);

  @override
  List<Object> get props => [message];
}