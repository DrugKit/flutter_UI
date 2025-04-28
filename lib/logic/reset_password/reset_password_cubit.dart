import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/network/api_endpoints.dart';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  final DioHelper _dioHelper = DioHelper();

  
  Future<void> resetPassword({
  required String email,
  required String resetCode,
  required String newPassword,
}) async {
  emit(ResetPasswordLoading());
  
  try {
    final response = await _dioHelper.postData(
      path: ApiUrl.newpass,
      body: {
        "email": email,
        "resetCode": resetCode,
        "newPassword": newPassword,
      },
    );

    if (response.statusCode == 200) {
      emit(ResetPasswordSuccess());
    } else {
      emit(ResetPasswordError("Failed to reset password. Try again."));
    }
  } catch (e) {
    emit(ResetPasswordError("Error: ${e.toString()}"));
  }
}


}
