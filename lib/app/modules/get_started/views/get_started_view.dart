import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/button_type.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';
import '../../../routes/app_pages.dart';
import '../../../core/values/colors.dart'; // Import colors
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreenView();
  }
}

class WelcomeScreenView extends GetView<GetStartedController> {
  const WelcomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4D03F), // Yellow background
      body: Stack(
        children: [
          // App Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/small_icon.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                Text(
                  'welcome'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Get Started button
          Positioned(
            bottom: Get.height * 0.15,
            left: Get.width * 0.1,
            right: Get.width * 0.1,
            child: AtomButton(

              height: 60,
              onPressed: () {
                Get.toNamed(Routes.ONBOARDING);
              },
              label: 'getStarted'.tr,
              buttonColor: ButtonColor.black, // Changed to greyLight
            ),
          ),

          // Sign in text
          Positioned(
            bottom: Get.height * 0.04,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Do you have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: controller.onSignInPressed,
                  child: Text(
                    'signIn'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
