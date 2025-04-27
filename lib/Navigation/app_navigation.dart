import 'package:flutter/material.dart';

class AppNavigator {
  /// ينقلك لشاشة جديدة (مع إمكانية الرجوع)
  static void push(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// ينقلك لشاشة جديدة (ويمسح الشاشة القديمة - مفيش رجوع)
  static void pushReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  /// ينقلك لشاشة جديدة ويمسح كل الشاشات اللي قبليها (مثلا بعد login)
  static void pushAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  /// يرجع خطوة واحدة للخلف
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
