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
  Future<void> signUp(context,
      {required String email,
      required String password,
      required String phoneNumber,
      required String name}) async {
    emit(SignUpLoading());
    print(email);
      print(password);
      print(phoneNumber);
      print(name);
    try {
      final response = await _dioHelper.postData(path: ApiUrl.signup, body: {
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "name": name
      });
      emit(SignUpSucces());
    } catch (e) {
      print(e.toString());
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(SignUpError("انتهى وقت الاتصال بالخادم. حاول مرة أخرى."));
            break;
          case DioExceptionType.sendTimeout:
            emit(SignUpError("انتهى وقت إرسال الطلب. حاول مرة أخرى."));
            break;
          case DioExceptionType.receiveTimeout:
            emit(SignUpError("انتهى وقت الاستجابة من الخادم. حاول مرة أخرى."));
            break;
          case DioExceptionType.cancel:
            emit(SignUpError("تم إلغاء الطلب."));
            break;
          case DioExceptionType.badResponse:
            final statusCode = e.response?.statusCode;
            if (statusCode == 400) {
              emit(SignUpError(e.response?.data));
            } else if (statusCode == 401) {
              // log(" Error: ${e.response?.data}");
              emit(SignUpError("${e.response?.data} حدث خطا ً"));
            } else if (statusCode == 404) {
              // log("Not Found: ${e.response?.data}");
              emit(SignUpError("${e.response?.data} غير موجود "));
            } else if (statusCode == 500) {
              //   log("Internal Server Error: ${e.response?.data}");
              emit(SignUpError("هناك خطأ في الخادم. يرجى المحاولة لاحقاً"));
            } else {
              //   log("Unknown error: ${e.response?.data}");
              emit(SignUpError("حدث خطأ غير معروف. حاول مرة أخرى."));
            }
            break;
          case DioExceptionType.connectionError:
          default: // Added default case for unexpected errors
            emit(SignUpError(" تحقق من اتصال الإنترنت الخاص بك."));
            break;
        }
      } else {
        //log("Unknown error: ${e.toString()}");
        emit(SignUpError("حدث خطأ غير معروف. حاول مرة أخرى.${e.toString()}"));
      }
    }
  }
}
