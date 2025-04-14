import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormUtils {
  /// Validates all required fields in a form and shows appropriate error messages
  ///
  /// This function checks if all required fields are filled, and if not:
  /// 1. Shows an error message above each unfilled field
  /// 2. Returns false to prevent navigation to the next page
  /// 3. Optionally shows a snackbar message
  static bool validateRequiredFields({
    required GlobalKey<FormState> formKey,
    bool showSnackbar = true,
    String snackbarTitle = 'Required Fields',
    String snackbarMessage = 'Please fill in all required fields',
  }) {
    // Trigger validation on all form fields
    bool isValid = formKey.currentState?.validate() ?? false;

    if (!isValid && showSnackbar) {
      Get.snackbar(
        snackbarTitle,
        snackbarMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );

      // Set form to autovalidate after first attempt
      formKey.currentState?.setState(() {});
    }

    return isValid;
  }

  /// Validates multiple individual fields and shows a custom error message
  /// Use this when form validation is not appropriate or not available
  static bool validateFields({
    required List<TextEditingController> controllers,
    required List<String> fieldNames,
    bool showSnackbar = true,
  }) {
    // Check if any required field is empty
    List<String> emptyFields = [];

    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty || controllers[i].text.trim().isEmpty) {
        emptyFields.add(fieldNames[i]);
      }
    }

    if (emptyFields.isNotEmpty && showSnackbar) {
      Get.snackbar(
        'Required Fields',
        'Please fill: ${emptyFields.join(", ")}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
      return false;
    }

    return emptyFields.isEmpty;
  }

  /// Validates a single field and shows a custom error message
  static bool validateField({
    required TextEditingController controller,
    required String fieldName,
    bool showSnackbar = true,
  }) {
    if (controller.text.isEmpty || controller.text.trim().isEmpty) {
      if (showSnackbar) {
        Get.snackbar(
          'Required Field',
          '$fieldName is required',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
        );
      }
      return false;
    }
    return true;
  }
}
