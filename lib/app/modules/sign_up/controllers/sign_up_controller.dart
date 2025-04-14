import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/position_type.dart';
import 'package:rnp_front/app/data/enums/zone.dart';
import 'package:rnp_front/app/data/models/dto/create_subscription_form.dart';
import 'package:rnp_front/app/data/models/entities/olm.dart';
import 'package:rnp_front/app/data/models/entities/subscription_option.dart';
import 'package:rnp_front/app/data/services/olm_service.dart';
import 'package:rnp_front/app/data/services/user_service.dart';

import '../../../core/utils/file_picker.dart';
import '../../../data/enums/room_type.dart';
import '../../../data/models/file_info.dart';
import '../../../data/services/auth_service.dart';

class SignUpController extends GetxController {
  UserService userService = UserService();
  OlmsService olmsService = OlmsService();
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController phone = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subscriptionType = TextEditingController();
  Rx<Olm?> selectedOlm = Rx(null);
  TextEditingController positionType = TextEditingController();
  RxBool toVerify = false.obs;
  String countryCode = '216';
  RxBool isObscureText = true.obs;
  RxInt currentStep = 0.obs;
  Rx<File> profilePhoto = File('').obs;
  RxBool isLoading = false.obs;
  RxList<Olm> olms = <Olm>[].obs;
  RxList<Olm> selectedZoneOlms = <Olm>[].obs;
  Rx<ZoneType?> selectedZoneType = Rx(null);
  Rx<PositionType> selectedPositionType = PositionType.MEMBER.obs;
  RxDouble pageDirection = 0.0.obs;
  RxBool errorShake = false.obs;
  RxList<SubscriptionOption> subscriptionOptions = <SubscriptionOption>[].obs;
  TextEditingController otherPositionType = TextEditingController();
  Rx<SubscriptionOption?> selectedSubscriptionOption = Rx(null);
  Rx<FileInfo?> selectedImage = Rx(null);
  TextEditingController roommatesController = TextEditingController();
  Rx<RoomType> selectedRoomType = RoomType.DOUBLE.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    super.onInit();
    await getAllOlms();
    await getAllSubscriptionOptions();
    isLoading.value = false;
  }

  void nextStep() {
    if (currentStep.value < 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  getAllOlms() async {
    final response = await olmsService.getAllOlms();
    olms.assignAll(response);
  }

  getAllSubscriptionOptions() async {
    final response = await olmsService.getAllSubscriptionOptions();
    subscriptionOptions.assignAll(response);
  }

  Future<void> register() async {
    toVerify.value = true;
    if (selectedOlm.value != null &&
        selectedSubscriptionOption.value != null &&
        selectedRoomType.value != null &&
        selectedPositionType.value != null &&
        selectedImage.value != null) {
      // Create a copy of the original file to avoid modifying the selected file
      final receiptFile = FileInfo(
        fileName: selectedImage.value!.fileName,
        path: selectedImage.value!.path,
        length: selectedImage.value!.bytes.length,
        bytes: selectedImage.value!.bytes,
      );

      // Determine file extension based on file content or path
      String fileExtension = '.jpg';
      if (receiptFile.fileName.contains('.')) {
        fileExtension = receiptFile.fileName.split('.').last;
        fileExtension = '.$fileExtension';
      } else if (receiptFile.path != null && receiptFile.path!.contains('.')) {
        fileExtension = receiptFile.path!.split('.').last;
        fileExtension = '.$fileExtension';
      }

      // Create a properly formatted filename (use a sequential number to avoid timestamp clashes)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomPart =
          (10000 + DateTime.now().microsecond % 10000).toString();
      receiptFile.fileName = 'receipt-$timestamp-$randomPart$fileExtension';

      try {
        isLoading.value = true;

        CreateSubscriptionFormDto createSubscriptionFormDto =
            CreateSubscriptionFormDto(
          createUserDto: CreateUserDto(
            fullName: fullName.text,
            email: email.text,
            phoneNumber: phone.text,
            countryCode: countryCode,
            password: password.text,
          ),
          positionType: selectedPositionType.value.name,
          positionTitle: otherPositionType.text,
          subscriptionTypeId: selectedSubscriptionOption.value!.id,
          olmId: selectedOlm.value!.id,
          roommates: roommatesController.text,
          roomType: selectedRoomType.value,
        );

        final response = await userService.signUp(
            createSubscriptionFormDto: createSubscriptionFormDto,
            receipt: receiptFile);

        if (response != null) {
          Get.showSnackbar(
            GetSnackBar(
              message: "success".tr,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          AuthService().logout();
        } else {
          Get.showSnackbar(
            GetSnackBar(
              message: "error".tr,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          AuthService.goToHomePage();
        }
      } catch (e) {
        print("Error in registration: $e");
        Get.showSnackbar(
          GetSnackBar(
            message: "Registration error: ${e.toString()}",
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
