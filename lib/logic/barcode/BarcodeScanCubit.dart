import 'dart:io';
import 'package:drugkit/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:drugkit/logic/barcode/BarcodeScanState.dart';
// تأكد أن ApiService موجود ويستخدم DioHelper
// import 'package:drugkit/network/api_service.dart';

class BarcodeScanCubit extends Cubit<BarcodeScanState> {
  BarcodeScanCubit() : super(BarcodeScanInitial());

  Future<void> scanBarcode(XFile imageFile) async {
    emit(BarcodeScanLoading());
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await DioHelper().uploadImage(
        path: 'Drug/BarCodeScan',
        formData: formData,
      );

      if (response != null && response.statusCode == 200) {
        if (response.data is List) {
          emit(BarcodeScanSuccess(List<dynamic>.from(response.data)));
        } else if (response.data is Map) {
          // إذا كان الـ API يرجع خريطة واحدة للدواء (وليست قائمة)
          emit(BarcodeScanSuccess([response.data]));
        } else {
          // إذا لم تكن الاستجابة قائمة أو خريطة، هذا هو المشكلة!
          emit(const BarcodeScanError(
              'Invalid API response format. Expected a list or map.'));
        }
      } else {
        // التعامل مع استجابات الأخطاء الأخرى من الـ API
        String errorMessage = 'Failed to scan barcode.';
        if (response != null) {
          if (response.data is Map && response.data.containsKey('message')) {
            errorMessage = response.data['message'];
          } else if (response.data is String) {
            errorMessage = response.data; // استخدم النص مباشرة كرسالة خطأ
          } else {
            errorMessage =
                'Server error: ${response.statusCode} ${response.statusMessage ?? ''}';
          }
        }
        emit(BarcodeScanError(errorMessage));
      }
    } on DioException catch (e) {
      String errorMessage = 'An unknown error occurred.';
      if (e.response != null) {
        if (e.response!.data is Map &&
            e.response!.data.containsKey('message')) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        } else {
          errorMessage =
              'Server error: ${e.response!.statusCode} ${e.response!.statusMessage ?? ''}';
        }
      } else {
        errorMessage =
            'Network error: ${e.message ?? 'No internet connection'}';
      }
      emit(BarcodeScanError(errorMessage));
    } catch (e) {
      emit(BarcodeScanError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  // **تم إضافة هذه الدالة لإعادة تعيين الحالة**
  void resetState() {
    emit(BarcodeScanInitial());
  }
}
