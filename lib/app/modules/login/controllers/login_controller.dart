import 'package:eco_trans/app/core/utils/config_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/app_auth.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  AuthService auth = AuthService();
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool toVerify = false.obs;
  String countryCode = '218';
  RxBool isObscureText = true.obs;

  Future<void> login() async {
    toVerify.value = true;
    if (key.currentState!.validate()) {
      AppAuth user = AppAuth(
        countryCode: countryCode,
        phoneNumber: phone.text,
        password: password.text,
        fcmToken: ConfigFirebase.currentToken,
      );
      bool response = await auth.customerAuth(auth: user);
      if (response) {
        AuthService.goToHomePage();
      }
    }
  }
}
