part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
class LoginNeedsVerification extends LoginState {
  final String email;
  final String password;

  LoginNeedsVerification({required this.email, required this.password});
}
