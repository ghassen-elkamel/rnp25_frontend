import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:rnp_front/app/data/services/auth_service.dart';
import 'package:rnp_front/app/data/services/user_service.dart';

import '../../../core/utils/alert.dart';
import '../../../core/utils/file_picker.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/models/entities/subscription_form.dart';
import '../../../data/models/file_info.dart';
import '../../../data/services/user_form_service.dart';
import '../../../global_widgets/atoms/alert_dialog.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  UserFormService userFormService = UserFormService();
  AuthService authService = AuthService();
  final RxBool isLoading = true.obs;
  Rx<FileInfo?> selectedImage = Rx(null);
  UserService userService = UserService();
  Rx<SubscriptionForm?> user = Rx(null);
  RxBool onEdit = false.obs;
  RxString pathPicture = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  showDeleteDialog() async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return AtomAlertDialog(
          title: "attention".tr,
          subTitle: "areYouSureYouWantToDeleteYourAccount".tr,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: AtomButton(
                    label: "cancel".tr,
                    height: 40,
                    buttonColor: ButtonColor.greyLight,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Flexible(
                  child: AtomButton(
                    label: 'delete'.tr,
                    isSmall: true,
                    height: 40,
                    buttonColor: ButtonColor.red,
                    onPressed: () async {
                      deleteUser();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  deleteUser() async {
    bool isDeleted = await userService.deleteUser();
    if (isDeleted) {
      AuthService().logout();
    }
  }

  Future getImage(BuildContext context) async {
    selectedImage.value = await CustomFilePicker.showPicker(
      context: context,
    );
    if (selectedImage.value != null) {
      pathPicture.value = "${selectedImage.value?.fileName}";

      // Show confirmation dialog with preview
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Update Profile Photo".tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Do you want to use this photo as your profile picture?"
                    .tr),
                const SizedBox(height: 20),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MemoryImage(
                          Uint8List.fromList(selectedImage.value!.bytes)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  selectedImage.value = null;
                  pathPicture.value = "";
                },
                child: Text("Cancel".tr),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  updateImage();
                },
                child: Text("Update".tr),
              ),
            ],
          );
        },
      );
    }
  }

  updateImage() async {
    if (selectedImage.value != null && user.value != null) {
      isLoading.value = true;
      try {
        // Upload the image to the server using the UserService
        await userService.uploadProfilePicture(
          file: selectedImage.value!,
          withLoadingAlert: true,
        );

        // Refresh user data to get the updated profile picture
        await fetchUserData();

        // Show success message
        Get.snackbar(
          'success'.tr,
          'profilePhotoUpdatedSuccessfully'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        // Show error message
        Get.snackbar(
          'error'.tr,
          'failedToUpdateProfilePhoto'.tr + ': ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
        // Reset selectedImage and pathPicture
        selectedImage.value = null;
        pathPicture.value = "";
      }
    }
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      // Get user data from service
      final userData = await userFormService.getUserUUid();
      if (userData != null) {
        user.value = userData;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user data: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onEditProfilePressed() {
    // Navigate to edit profile screen
    //  Get.toNamed(Routes.EDIT_PROFILE);
  }

  void onLogoutPressed() {
    authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
