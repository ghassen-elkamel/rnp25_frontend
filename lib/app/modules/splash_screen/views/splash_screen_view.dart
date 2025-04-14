import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/colors.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedBuilder(
          animation: controller.mainAnimationController,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  color: Colors.white,
                ),

                AnimatedBuilder(
                  animation: controller.mainAnimationController,
                  builder: (context, child) {
                    double circleSize = 300.0;

                    if (controller.currentAnimationStep.value == 2) {
                      final screenSize = Get.size.width > Get.size.height
                          ? Get.size.width * 2
                          : Get.size.height * 2;
                      circleSize = 300.0 +
                          (screenSize - 300.0) *
                              controller.circleFullScreenAnimation.value;
                    } else {
                      circleSize =
                          300.0 * controller.circleScaleAnimation.value;
                    }

                    return Center(
                      child: SlideTransition(
                        position: controller.circlePositionAnimation,
                        child: Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: primaryColor, // Using your primary color
                            borderRadius:
                                controller.currentAnimationStep.value == 2
                                    ? BorderRadius.circular(
                                        0) // Changed to 0 to make it a square
                                    : BorderRadius.circular(circleSize / 2),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Logo that fades in
                Center(
                  child: AnimatedBuilder(
                    animation: controller.mainAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.logoFadeInAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Image.asset(
                            'assets/icons/small_icon.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
