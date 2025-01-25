import 'package:rnp_front/app/data/services/user_service.dart';
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
  TextEditingController email = TextEditingController();
  RxBool toVerify = false.obs;
  String countryCode = '216';
  RxBool isObscureText = true.obs;


  Future<void> register() async {
    toVerify.value = true;
    if (key.currentState!.validate()) {
      User? user = User(
        phoneNumber: phone.text,
        countryCode: countryCode,
        fullName: fullName.text,
        password: password.text,
        email: email.text,
      );
      user = await userService.create(user: user);
      if (user != null) {
        AuthService.goToHomePage();
      }
    }
  }
}
