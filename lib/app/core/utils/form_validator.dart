import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FormValidator {
  static FormValidator? _instance;
  FormValidator._internal();

  factory FormValidator() {
    _instance ??= FormValidator._internal();
    return _instance!;
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "enter-valid-email".tr;
    } else if (!regExp.hasMatch(value)) {
      return "invalid-email".tr;
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    String pattern = r'^\+{0,1}[0-9}]{9,15}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "invalidInformation".tr;
    } else if (!regExp.hasMatch(value)) {
      return "invalidInformation".tr;
    }
    return null;
  }

  String? validateDouble(String? value, {bool isRequired = true}) {
    value = value?.replaceAll(" ", "");
    value = value?.replaceAll(",", ".");
    String pattern = r'^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$';
    RegExp regExp = RegExp(pattern);
    if (!isRequired && value!.isEmpty) {
      return null;
    }
    if (value!.isEmpty) {
      return "invalidInformation".tr;
    } else if (!regExp.hasMatch(value)) {
      return "invalidInformation".tr;
    }
    return null;
  }

  /// Validates all form fields and returns true if all required fields are filled
  /// This method forces each field to validate and show its error message
  bool validateAllFields(GlobalKey<FormState> formKey,
      {bool showSnackbar = true}) {
    // Force validation on all fields inside the form
    bool isValid = formKey.currentState?.validate() ?? false;

    if (!isValid && showSnackbar) {
      Get.snackbar(
        'Required Fields',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    }

    return isValid;
  }
}
