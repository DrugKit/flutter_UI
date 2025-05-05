import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:drugkit/storage/storage_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    print('Starting login...');

    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.login,
        body: {
          "email": email,
          "password": password,
        },
      );
      print('Login Response: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data["token"];
        if (token != null) {
          await StorageData.storeStorage(key: StorageData.token, value: token);
          DioHelper().updateToken(); // ⬅️ ده اللي ناقص
        }
        emit(LoginSuccess());
      } else {
        emit(LoginError("Login failed. Please check your credentials."));
      }
    } catch (e) {
      print('Login Error: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 400 &&
            e.response?.data.toString().contains("Email not confirmed") ==
                true) {
          emit(LoginNeedsVerification(email: email, password: password));
        } else {
          emit(LoginError(_handleError(e)));
        }
      } else {
        emit(LoginError("Unexpected error: ${e.toString()}"));
      }
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please try again.";
        case DioExceptionType.sendTimeout:
          return "Request sending timeout. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Server response timeout. Please try again.";
        case DioExceptionType.cancel:
          return "Request was cancelled.";
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          if (statusCode == 400 || statusCode == 401) {
            return "Invalid email or password.";
          } else if (statusCode == 404) {
            return "Resource not found.";
          } else if (statusCode == 500) {
            return "Internal server error. Please try again later.";
          } else {
            return "Unexpected error. Please try again.";
          }
        case DioExceptionType.connectionError:
        default:
          return "Check your internet connection and try again.";
      }
    } else {
      return "Unexpected error: ${e.toString()}";
    }
  }
}
