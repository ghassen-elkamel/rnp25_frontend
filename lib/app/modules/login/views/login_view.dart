import 'package:eco_trans/app/core/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/phone_text_field.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/templates/auth_scaffold.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      isLogin: true,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.key,
          child: Column(
            children: [
              AtomPhoneTextField(
                onCountryChanged: (p0) {
                  controller.countryCode = p0;
                },
                controller: controller.phone,
                hintText: "phone".tr,
              ),
              Obx(() {
                return AtomTextField.simple(
                  controller: controller.password,
                  hintText: "password".tr,
                  isObscureText: controller.isObscureText.value,
                  suffix: InkWell(
                    onTap: () {
                      controller.isObscureText.value =
                          !controller.isObscureText.value;
                    },
                    child: Icon(
                      controller.isObscureText.isTrue
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: grey,
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 22,
              ),
              AtomButton(
                label: "login".tr,
                onPressed: () => controller.login(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
