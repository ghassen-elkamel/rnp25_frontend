import 'package:eco_trans/app/data/services/user_service.dart';
import 'package:get/get.dart';

import '../../../data/models/entities/user.dart';
import '../../../data/services/auth_service.dart';
import 'package:flutter/material.dart';
class SignUpController extends GetxController {
  UserService userService = UserService();
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController phone = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool toVerify = false.obs;
  String countryCode = '218';
  RxBool isObscureText = true.obs;

  Future<void> register() async {
    toVerify.value = true;
    if (key.currentState!.validate()) {
      User? user = User(
        phoneNumber: phone.text,
        countryCode: countryCode,
        fullName: fullName.text,
        password: password.text,
      );
      user = await userService.create(user: user);
      if (user != null) {
        AuthService.goToHomePage();
      }
    }
  }
}
