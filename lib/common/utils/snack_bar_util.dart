import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SnackbarUtil {

  static void showMessage(BuildContext context, String message) {
    showSnackbar(context, message);
  }

  static void showError(BuildContext context, dynamic e) {
    if (e is DioError && e.response != null) {
      showSnackbar(context, '${e.response?.data["message"] ?? e.response?.statusMessage ?? "알수 없는 에러가 발생하였습니다."}');
    } else {
      showSnackbar(context, "시스템 장애가 발생하였습니다.");
    }
  }

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

}