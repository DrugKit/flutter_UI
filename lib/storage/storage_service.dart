import 'dart:io';

import 'package:hive/hive.dart';

class StorageData {
  static const String _boxName = 'auth';
  static late Box _myBox;
  static const String token = "token";
  static const String tokenpass = "tokenpass";
  static const String pass = "pass";
  static const String pharmaid = "pharmaid";
  static const String paytype = "paytype";
  static const String email = "email";
  static const String role = "role";

  /// تهيئة Hive وفتح الصندوق
  static Future<void> init() async {
    _myBox = await Hive.openBox(_boxName);
  }

  /// تخزين التوكن
  static Future<void> storeStorage(
      {required String key, required String value}) async {
    try {
      await _myBox.put(key, value);
    } catch (e) {
      //print("Error storing token: $e");
    }
  }

  /// جلب التوكن
  static String? getStorage({required String key}) {
    try {
      return _myBox.get(key);
    } catch (e) {
      //print("Error retrieving token: $e");
      return null;
    }
  }

  /// حذف التوكن
  static Future<void> removeKeyStorage({required String key}) async {
    try {
      await _myBox.delete(key);
    } catch (e) {
      /*print("Error removing token: $e");*/
    }
  }

  /// حذف جميع البيانات
  static Future<void> clearStorage() async {
    try {
      await _myBox.clear();
    } catch (e) {
      /* print("Error clearing storage: $e");*/
    }
  }
  // static Future<void> deleteAllImages() async {
  //   var box = await Hive.openBox('images');
  //   for (String key in box.keys) {
  //     print(key);
  //     String? imagePath = box.get(key);

  //     if (imagePath != null) {
  //       File imageFile = File(imagePath);
  //       if (await imageFile.exists()) {
  //         await imageFile.delete();
  //       }
  //     }
  //   }

  //   await box.clear(); // ✅ حذف كل البيانات من Hive
  // }
}
