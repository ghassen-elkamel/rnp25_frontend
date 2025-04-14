import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../values/colors.dart';
import '../../routes/app_pages.dart';

/// A utility class to manage the profile picture alert
class ProfileAlertManager {
  static final RxBool _alertShown = false.obs;

  /// Shows a non-dismissible alert if the user doesn't have a profile picture
  /// Returns true if alert was shown, false otherwise
  static bool showProfilePictureAlertIfNeeded(
      BuildContext context, String? profilePicturePath) {
    // Don't show alert if already shown or if we're in profile view
    if (_alertShown.value || Get.currentRoute == Routes.PROFILE) {
      return false;
    }

    // If user has a profile picture, don't show alert
    if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
      return false;
    }

    // Show non-dismissible alert
    _alertShown.value = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button from dismissing
          child: AlertDialog(
            title: Text(
              'profilePictureRequired'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 80,
                  color: primaryColor,
                ),
                SizedBox(height: 20),
                Text(
                  'profilePictureRequiredMessage'.tr,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _alertShown.value = false;
                    Get.back(); // Close dialog
                    Get.toNamed(Routes.PROFILE); // Navigate to profile
                  },
                  child: Text('addProfilePicture'.tr),
                ),
              ),
            ],
          ),
        );
      },
    );

    return true;
  }

  /// Reset the alert status when user logs out or changes
  static void resetAlert() {
    _alertShown.value = false;
  }
}
