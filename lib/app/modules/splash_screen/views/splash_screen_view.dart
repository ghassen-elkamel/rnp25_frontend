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
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (_, __) {
          return Opacity(
            opacity: controller.opacity.value ?? 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Image.asset(
                'assets/images/logo-small.png',
              ),
            ),
          );
        },
      ),
    );
  }
}
