import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/logic/reset_password/reset_password_cubit.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();
  Future<void> verifyResetCode({
  required String email,
  required String resetCode,
}) async {
  emit(ForgetPasswordLoading());

  try {
    final response = await _dioHelper.postData(
      path: ApiUrl.verifyforget,
      body: {
        "email": email,
        "resetCode": resetCode,
      },
    );

    if (response.statusCode == 200) {
      emit(ResetCodeVerifiedSuccess());
    } else {
      emit(ForgetPasswordError("Invalid code. Please try again."));
    }
  } catch (e) {
    emit(ForgetPasswordError("Error: ${e.toString()}"));
  }
}


  // 1. Send Reset Code
  Future<void> sendResetCode({required String email}) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.foregt,
        body: {"email": email},
      );
      print('Send Reset Code Response: ${response.data}');
      emit(SendResetCodeSuccess());
    } catch (e) {
      print('Send Reset Code Error: $e');
      emit(ForgetPasswordError(_handleError(e)));
    }
  }

  // 3. Reset Password
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await _dioHelper.postData(
        path: ApiUrl.newpass,
        body: {
          "email": email,
          "resetCode": code,
          "newPassword": newPassword,
        },
      );
      print('Reset Password Response: ${response.data}');
      emit(ResetPasswordSuccess());
    } catch (e) {
      print('Reset Password Error: $e');
      emit(ForgetPasswordError(_handleError(e)));
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      final message = e.response?.data ?? 'Unexpected Error. Try again.';
      return message.toString();
    } else {
      return 'Unexpected Error: ${e.toString()}';
    }
  }
}
