import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/global_widgets/atoms/phone_text_field.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/constant.dart';
import '../../../core/values/colors.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/molecules/fixed_bottom_sheet.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MoleculeFixedBottomSheet(
        height: Get.height * 0.7,
        title: "welcome".tr,
        backgroundImage: loginBackground,
        content: [
          Form(
            key: controller.key,
            child: Column(
              children: [
                AtomTextField.simple(
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "emailIsRequired".tr;
                    }
                    if (!GetUtils.isEmail(p0)) {
                      return "emailIsInvalid".tr;
                    }
                    return null;
                  },
                  controller: controller.email,
                  hintText: "email".tr,
                  suffix: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),
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
                InkWell(
                  onTap: () => Get.offAllNamed(Routes.LOGIN),
                  child: CustomText.m(
                    "login".tr,
                    color: grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
