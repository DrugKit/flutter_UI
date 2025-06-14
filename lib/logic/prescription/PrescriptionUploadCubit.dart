// في ملف logic/prescription/PrescriptionUploadCubit.dart

import 'package:drugkit/logic/prescription/PrescriptionUploadState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drugkit/network/api_service.dart'; // تأكد إن هذا هو المسار الصحيح لـ DioHelper

class PrescriptionUploadCubit extends Cubit<PrescriptionUploadState> {
  PrescriptionUploadCubit() : super(PrescriptionUploadInitial());

  Future<void> uploadPrescription(XFile image) async {
    emit(PrescriptionUploadLoading());
    try {
      final formData = FormData.fromMap({
        'prescription': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      final response = await DioHelper().uploadImage(
        path: "Prescription/upload",
        formData: formData,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = response.data; // هنا بنحصل على البيانات اللي رجعت من الـ API

        // --- الجزء المعدل للتحقق من البيانات ---
        // الآن نتوقع أن responseData هي قائمة مباشرة (List)
        if (responseData is List) {
          // لو البيانات المستلمة هي قائمة، يبقى ده التنسيق اللي بنبحث عنه
          // يمكن تمرير هذه القائمة مباشرةً إلى PrescriptionUploadSuccess
          emit(PrescriptionUploadSuccess(responseData)); // هنا بنمرر الـ List مباشرةً
        } else {
          // لو البيانات ليست قائمة، يبقى فيه مشكلة في التنسيق
          emit(PrescriptionUploadError(
              "Invalid API response format. Expected a list of drugs. Received: ${responseData.runtimeType}"));
        }
      } else {
        // لو كان فيه مشكلة في الـ Status Code أو الـ response كان null
        String errorMessage = "Upload failed. Please try again.";
        if (response != null && response.data is Map && response.data.containsKey('message')) {
          errorMessage = response.data['message'];
        } else if (response != null && response.data is String) {
          errorMessage = response.data; // لو رجع String كرسالة خطأ
        }
        emit(PrescriptionUploadError(errorMessage));
      }
    } on DioError catch (e) {
      String errorMessage = "An error occurred during upload: ";
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data.containsKey('message')) {
          errorMessage += e.response!.data['message'];
        } else {
          errorMessage += e.response!.statusMessage ?? "Server error.";
        }
      } else {
        errorMessage += e.message ?? "Network error.";
      }
      emit(PrescriptionUploadError(errorMessage));
    } catch (e) {
      emit(PrescriptionUploadError("An unexpected error occurred: ${e.toString()}"));
    }
  }
   void resetState() {
    emit(PrescriptionUploadInitial());
  }
}