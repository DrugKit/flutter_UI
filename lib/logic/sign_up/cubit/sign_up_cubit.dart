import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  void resetToInitial() {
    emit(SignUpInitial());
  }

  final DioHelper _dioHelper = DioHelper();

  Future<void> signUp(
    context, {
    required String email,
    required String password,
    required String phoneNumber,
    required String name,
  }) async {
    emit(SignUpLoading());
    print(email);
    print(password);
    print(phoneNumber);
    print(name);

    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.signup,
        body: {
          "email": email,
          "password": password,
          "phoneNumber": phoneNumber,
          "name": name,
        },
      );

      emit(SignUpSucces());
    } catch (e) {
      print(e.toString());
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(SignUpError("Connection timeout. Please try again."));
            break;
          case DioExceptionType.sendTimeout:
            emit(SignUpError("Request sending timeout. Please try again."));
            break;
          case DioExceptionType.receiveTimeout:
            emit(SignUpError("Server response timeout. Please try again."));
            break;
          case DioExceptionType.cancel:
            emit(SignUpError("Request was cancelled."));
            break;
          case DioExceptionType.badResponse:
            final statusCode = e.response?.statusCode;
            if (statusCode == 400) {
              emit(SignUpError(e.response?.data.toString() ?? "Bad request."));
            } else if (statusCode == 401) {
              emit(SignUpError("Unauthorized. Please check your credentials."));
            } else if (statusCode == 404) {
              emit(SignUpError("Resource not found."));
            } else if (statusCode == 500) {
              emit(SignUpError(
                  "Internal server error. Please try again later."));
            } else {
              emit(SignUpError("Unexpected error. Please try again."));
            }
            break;
          case DioExceptionType.connectionError:
          default:
            emit(SignUpError("Check your internet connection and try again."));
            break;
        }
      } else {
        emit(SignUpError("Unexpected error: ${e.toString()}"));
      }
    }
  }
}
