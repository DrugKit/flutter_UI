part of 'verification_cubit.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationResendSuccess extends VerificationState {} // ✅ اضفناها هنا

class VerificationError extends VerificationState {
  final String error;
  VerificationError(this.error);
}
