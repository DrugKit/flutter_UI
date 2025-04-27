import 'package:dio/dio.dart';
import 'package:drugkit/storage/storage_service.dart';
import 'api_endpoints.dart';

class DioHelper {
  static Dio? dio;
  static String? _token;
  /* static Map<String, dynamic> headers = {
    */ /*"Accept": "application/json",
    "Content-Type": "application/json",*/ /*
    "Authorization": 'Bearer $token',
  };*/

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      receiveDataWhenStatusError: true,
      responseType: ResponseType.json,
    ));
    // تحميل التوكن مرة واحدة عند تشغيل التطبيق
    _token = StorageData.getStorage(key: StorageData.token);
    if (_token != null && _token!.isNotEmpty) {
      dio?.options.headers["Authorization"] = "Bearer $_token";
    }
  }

  void updateToken() {
    _token = StorageData.getStorage(key: StorageData.token);
    dio?.options.headers["Authorization"] =
        _token != null ? "Bearer $_token" : null;
  }

  ///Get Data
  Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParams,
  }) async {
    // if (_token == null) updateToken();
    final response = await dio!.get(path, queryParameters: queryParams);
    return response;
  }

  /// Post Data
  Future<Response> postData({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    //if (_token == null) updateToken(); // تحديث التوكن مرة واحدة فقط إذا كان غير محمل
    final response = await dio!.post(
      path,
      data: body,
      queryParameters: queryParams,
    );
    return response;
  }

  /// Put Data
  Future<Response> putData({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    //if (_token == null) updateToken(); // تحديث التوكن عند الحاجة فقط
    final response =
        await dio!.put(path, data: body, queryParameters: queryParams);
    return response;
  }

  /// delete Data
  Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    // if (_token == null) updateToken(); // تحديث التوكن عند الحاجة فقط
    final response =
        await dio!.delete(path, data: body, queryParameters: queryParams);
    return response;
  }

  /// upload image
  Future<Response?> uploadImage({
    required String path,
    required FormData formData,
  }) async {
    final response = await dio!.post(
      path,
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
    return response;
  }

  String? getToken() {
    return StorageData.getStorage(key: StorageData.token);
  }
}
