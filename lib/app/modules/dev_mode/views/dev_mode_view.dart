import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/routes/app_pages.dart';
import '../../../core/theme/text.dart';
import '../controllers/dev_mode_controller.dart';

class DevModeView extends GetView<DevModeController> {
  const DevModeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
             Image.asset("assets/images/big_logo.png", width: double.infinity, height: MediaQuery.of(context).size.height * 0.3,fit: BoxFit.cover),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.xxl(
                    "inDev".tr,
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                      "assets/images/gear.gif"
                  ),
                  IconButton(onPressed: () => Get.offAllNamed(Routes.SPLASH_SCREEN), icon: const Icon(Icons.refresh, size: 100,color: greyLight,))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}