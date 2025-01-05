import 'package:eco_trans/app/core/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/colors.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (_, __) {
                return Opacity(
                  opacity: controller.opacity.value ?? 0.0,
                  child: CircleAvatar(
                    backgroundColor: white,
                    radius: 80,
                    child: Image.asset(
                      'assets/images/logo-small.png',
                      width: 90,
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              const CustomText.xxl(
                "BY",
                color: white,
              ),
              Image.asset(
                'assets/images/my-partner.png',
                color: white,
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
