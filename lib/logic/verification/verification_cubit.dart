import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());

  static VerificationCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();

  Future<void> verifyCode({
    required String email,
    required String password,
    required String code,
  }) async {
    emit(VerificationLoading());
    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.verify,
        body: {
          "email": email,
          "password": password,
          "verificationCode": code,
        },
      );
      emit(VerificationSuccess());
    } catch (e) {
      emit(VerificationError(_handleError(e)));
    }
  }

  Future<void> resendCode({required String email}) async {
    emit(VerificationLoading());
    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.resend,
        body: {
          "email": email,
        },
      );
      emit(VerificationResendSuccess()); // ✅
    } catch (e) {
      emit(VerificationError(_handleError(e)));
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
          if (statusCode == 400) {
            return e.response?.data.toString() ?? "Bad request.";
          } else if (statusCode == 401) {
            return "Unauthorized. Please check your credentials.";
          } else if (statusCode == 404) {
            return "Resource not found.";
          } else if (statusCode == 500) {
            return "Internal server error. Please try later.";
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
