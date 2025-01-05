import 'package:eco_trans/app/global_widgets/atoms/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/colors.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/templates/auth_scaffold.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      isLogin: false,
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
              AtomTextField.simple(
                controller: controller.fullName,
                hintText: "fullName".tr,
                suffix: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
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
                height: 36,
              ),
              AtomButton(
                label: "register".tr,
                onPressed: () => controller.register(),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
