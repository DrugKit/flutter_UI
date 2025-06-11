import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/network/api_service.dart'; // هنستخدم DioHelper.dio مباشرة
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:convert'; // هنحتاجه عشان نحول الـString لـJSON String

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  Future<void> sendSymptom(String message) async {
    emit(ChatLoading());
    print(
        'DEBUG: ChatCubit - [STEP 1] - Entering sendSymptom. Emitting ChatLoading.');
    print('DEBUG: ChatCubit - [INFO] - Message to send: "$message"');

    try {
      if (DioHelper.dio == null) {
        DioHelper.init(); // التأكد ان Dio قد تم تهيئته
      }
      DioHelper().updateToken(); // تحديث التوكن

      print(
          'DEBUG: ChatCubit - [STEP 2] - Attempting to update token (if available).');
      // ** التعديل هنا: إرسال الـString مباشرة، ولكن مع Content-Type: application/json **
      // Dio سيقوم بتحويل الـString لـJSON string (بإضافة علامات التنصيص والـescaping) تلقائيًا لو الـContent-Type JSON
      print(
          'DEBUG: ChatCubit - [STEP 3] - Sending POST request to Chat/start with RAW string: "$message" and Content-Type: application/json');

      final response = await DioHelper.dio!.post(
        'Chat/start', // الـpath زي ما هو
        data: jsonEncode(message), // <--- هنا تحويل الـString لـJSON String
        options: Options(
          contentType: Headers
              .jsonContentType, // <--- تحديد Content-Type بشكل صريح لـapplication/json
          // الـAuthorization header بيجي من dio?.options.headers في DioHelper.init() و updateToken()
        ),
      );

      print('DEBUG: ChatCubit - [STEP 4] - Received response from API.');
      print(
          'DEBUG: ChatCubit - [INFO] - Response Status Code: ${response.statusCode}');
      print('DEBUG: ChatCubit - [INFO] - Raw Response Data: ${response.data}');

      if (response.statusCode == 200) {
        String botMessage = '';
        if (response.data is Map<String, dynamic>) {
          botMessage = (response.data['message'] ?? '') +
              '\n' +
              (response.data['advice'] ?? '');
          print(
              'DEBUG: ChatCubit - [INFO] - Parsed Bot Message: "$botMessage"');
        } else if (response.data != null) {
          botMessage = response.data.toString();
          print(
              'DEBUG: ChatCubit - [INFO] - Non-Map Response Data: "$botMessage"');
        } else {
          botMessage = 'No specific message received from the bot.';
          print('DEBUG: ChatCubit - [INFO] - Response data is null.');
        }

        emit(ChatSuccess(botMessage));
        print(
            'DEBUG: ChatCubit - [STEP 5] - API call successful. Emitting ChatSuccess.');
      } else {
        print('DEBUG: ChatCubit - [STEP 5] - API returned non-200 status.');
        print(
            'DEBUG: ChatCubit - [ERROR] - Server Status: ${response.statusCode}, Raw Data: ${response.data}');
        emit(ChatError(
            'Server responded with status ${response.statusCode}. Details: ${response.data.toString()}'));
      }
    } on DioException catch (e) {
      print('DEBUG: ChatCubit - [STEP 4/ERROR] - Caught DioException.');
      if (e.response != null) {
        print('DEBUG: ChatCubit - [ERROR] - DioException with response:');
        print('DEBUG:   Status Code: ${e.response?.statusCode}');
        print('DEBUG:   Response Data: ${e.response?.data}');
        print('DEBUG:   Error Message: ${e.message}');
        emit(ChatError(
            'API Error: Status ${e.response?.statusCode}. Details: ${e.response?.data?.toString() ?? 'No details.'}'));
      } else {
        print(
            'DEBUG: ChatCubit - [ERROR] - DioException without response (likely connection/network issue):');
        print('DEBUG:   Error Type: ${e.type}');
        print('DEBUG:   Error Message: ${e.message}');
        emit(ChatError(
            'Connection failed: Please check your internet or server availability.'));
      }
    } catch (e) {
      print(
          'DEBUG: ChatCubit - [STEP 4/ERROR] - Caught a general unexpected error.');
      print('DEBUG: ChatCubit - [ERROR] - Unexpected error: $e');
      emit(ChatError('An unknown error occurred. Please try again.'));
    }
  }
}
