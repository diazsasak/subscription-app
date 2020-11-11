import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewHelpers {
  static void showSnackbar({bool status, String message}) {
    Get.snackbar(
      null,
      message,
      colorText: status ? Colors.white : Colors.black,
      backgroundColor: status ? Colors.green : Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(8.0),
    );
  }
}
