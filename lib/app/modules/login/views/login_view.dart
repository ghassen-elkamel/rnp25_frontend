import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/values/colors.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/constant.dart';
import '../../../data/enums/button_type.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/icon_png.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/molecules/fixed_bottom_sheet.dart';
import '../../../global_widgets/templates/auth_scaffold.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return AuthScaffold(
        isLogin: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.key,
            child: Column(
              spacing: 20,
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
                    color: grey,
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

    return Scaffold(
      body: MoleculeFixedBottomSheet(
        height: Get.height * 0.7,
        title: "welcome".tr,
        backgroundImage: loginBackground,
        content: [
          Column(
            children: [
              CustomText.l("loginAccount".tr),
              const SizedBox(
                height: 10,
              ),
              CustomText.m(
                "loginMessage".tr,
                color: grey,
                textAlign: TextAlign.start,
                maxLines: 10,
              ),
              Form(
                key: controller.key,
                child: Column(
                  children: [
                    AtomTextField(
                      borderRadius: 30,
                      label: "email".tr,
                      controller: controller.email,
                      isRequired: true,
                    ),
                    Obx(() {
                      return AtomTextField(
                          borderRadius: 30,
                          label: "password".tr,
                          controller: controller.password,
                          isObscureText: controller.isObscureText.value,
                          suffix: InkWell(
                            onTap: () {
                              controller.isObscureText.value =
                                  !controller.isObscureText.value;
                            },
                            child: AtomIconPng(
                              backGroundColor: transparent,
                              icon: controller.isObscureText.value
                                  ? "assets/icons/eye-slash.png"
                                  : "assets/icons/eye.png",
                            ),
                          ));
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: CustomText.m(
                          'forgetPassword'.tr,
                          color: primaryColor,
                        ),
                      ),
                      onTap: () {
                        //       Get.toNamed(Routes.PHONE_VERIFICATION);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AtomButton(
                      isSmall: true,
                      buttonColor: ButtonColor.second,
                      label: "login".tr,
                      onPressed: controller.login,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Divider(endIndent: 30, indent: 30)),
                        CustomText.m("or".tr),
                        const Expanded(
                            child: Divider(endIndent: 30, indent: 30)),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                        onTap: () {
                          Get.offAllNamed(Routes.SIGN_UP);
                        },
                        child: CustomText.l('dontHaveAccount'.tr)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
