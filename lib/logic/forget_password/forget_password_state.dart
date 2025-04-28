part of 'forget_password_cubit.dart';

@immutable
abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class SendResetCodeSuccess extends ForgetPasswordState {}

class VerifyCodeSuccess extends ForgetPasswordState {}

class ResetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String errorMessage;

  ForgetPasswordError(this.errorMessage);
}
class VerifyResetCodeSuccess extends ForgetPasswordState {}

class ResetCodeVerifiedSuccess extends ForgetPasswordState {}
