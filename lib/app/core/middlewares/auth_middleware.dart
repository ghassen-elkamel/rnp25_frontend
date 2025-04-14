import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/profile_alert_manager.dart';
import '../../data/services/user_form_service.dart';
import '../../routes/app_pages.dart';

/// Middleware to check if user has a profile picture
class ProfilePictureMiddleware extends GetMiddleware {
  final UserFormService _userFormService = UserFormService();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Skip check for profile page, login, and splash screens
    if (route == Routes.PROFILE ||
        route == Routes.LOGIN ||
        route == Routes.SPLASH_SCREEN ||
        route == Routes.SIGN_UP) {
      return null;
    }

    return null; // Don't redirect - we'll check in pages using the alert instead
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    if (page?.name == Routes.PROFILE) {
      // Reset the alert if we're navigating to profile page
      ProfileAlertManager.resetAlert();
    }
    return page;
  }
}
