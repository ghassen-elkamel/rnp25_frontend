import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/position_type.dart';
import 'package:rnp_front/app/data/enums/zone.dart';
import 'package:rnp_front/app/data/models/dto/create_subscription_form.dart';
import 'package:rnp_front/app/data/models/entities/olm.dart';
import 'package:rnp_front/app/data/models/entities/subscription_option.dart';
import 'package:rnp_front/app/data/services/olm_service.dart';
import 'package:rnp_front/app/data/services/user_service.dart';

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
  Rx<ZoneType> selectedZoneType = ZoneType.A.obs;
  Rx<PositionType> selectedPositionType = PositionType.MEMBER.obs;
  RxDouble pageDirection = 0.0.obs;
  RxBool errorShake = false.obs;
  RxList<SubscriptionOption> subscriptionOptions = <SubscriptionOption>[].obs;
  TextEditingController otherPositionType = TextEditingController();
  Rx<SubscriptionOption?> selectedSubscriptionOption = Rx(null);
  Rx<FileInfo?> selectedImage = Rx(null);

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

  pickProfilePhoto() {}

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
    if (
        selectedOlm.value != null &&
        selectedSubscriptionOption.value != null) {
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
      );

      final response = await userService.signUp(
          createSubscriptionFormDto: createSubscriptionFormDto);
      if (response != null) {
        AuthService.goToHomePage();
      }
    }
  }
}
