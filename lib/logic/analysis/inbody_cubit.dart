import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'inbody_state.dart';

class InbodyCubit extends Cubit<InbodyState> {
  InbodyCubit() : super(InbodyInitial());

  // We create a new, separate Dio instance here.
  // This is intentional because the InBody analysis API is an external service
  // that does NOT require the app's authentication token.
  // Using your app's global DioHelper would incorrectly send the token.
  final Dio _dio = Dio();

  // Method to upload the selected report
  Future<void> uploadInbodyReport(PlatformFile file) async {
    emit(InbodyLoading());
    try {
      String fileName = file.name;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path!, filename: fileName),
      });

      // POST request to the full API endpoint URL.
      // No authentication token is sent with this request.
      final response = await _dio.post(
        'https://ruuue-clinical-report-analyzer.hf.space/analyze_report/',
        data: formData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        // Case 1: Success - API returns a pdf_url
        if (responseData.containsKey('pdf_url')) {
          emit(InbodySuccess(responseData['pdf_url']));
        }
        // Case 2: Handled Error - API returns a message for invalid files
        else if (responseData.containsKey('gemini_response') &&
                   responseData['gemini_response'].toString().trim().toLowerCase().startsWith('please')) {
          emit(InbodyError(responseData['gemini_response']));
        }
        // Case 3: Unexpected successful response
        else {
          emit(const InbodyError('An unexpected response was received from the server.'));
        }
      } else {
        // Handle server errors (e.g., 500 Internal Server Error)
        emit(InbodyError('Server Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      // Handle network-related errors
      emit(InbodyError('Network Error: ${e.message}'));
    } catch (e) {
      // Handle any other exceptions
      emit(InbodyError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Method to reset the state to initial, ready for the next upload
  void resetState() {
    emit(InbodyInitial());
  }
}