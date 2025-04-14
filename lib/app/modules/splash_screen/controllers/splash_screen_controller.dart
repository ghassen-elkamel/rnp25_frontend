import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/models/entities/app_config.dart';
import '../../../data/services/app_config_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Main animation controller
  late AnimationController mainAnimationController;

  // Logo animations
  late Animation<double> logoFadeInAnimation;

  // Circle animations
  late Animation<double> circleScaleAnimation;
  late Animation<Offset> circlePositionAnimation;
  late Animation<double> circleFullScreenAnimation;

  // Animation state tracking
  var currentAnimationStep = 0.obs;
  AppService appService = AppService();

  @override
  void onInit() {
    super.onInit();

    // Setup main animation controller with shorter duration
    mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // STEP 1: Yellow circle moves from top to center
    circleScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutQuint),
      ),
    );

    // Animation for the circle position (from top to center)
    circlePositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutQuint),
      ),
    );

    // STEP 2: Logo fade in
    logoFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.25, 0.4, curve: Curves.easeIn),
      ),
    );

    // STEP 3: Circle expands to fill screen
    circleFullScreenAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: mainAnimationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOutQuart),
      ),
    );

    // Setup listener to track animation progress
    mainAnimationController.addListener(() {
      if (mainAnimationController.value < 0.25) {
        currentAnimationStep.value = 0; // Circle moves to center
      } else if (mainAnimationController.value < 0.4) {
        currentAnimationStep.value = 1; // Logo appears
      } else {
        currentAnimationStep.value = 2; // Circle fills screen
      }

      // When animation completes, navigate to next screen
      if (mainAnimationController.value == 1.0) {
        nextPage();
      }
    });

    // Start animation sequence
    mainAnimationController.forward();
  }

  Future<void> nextPage() async {
    Future waiter = Future.delayed(const Duration(milliseconds: 500));
    List result = await Future.wait([
      waiter,
      appService.getVersion(),
    ]);

    AppConfig? appConfig = result[1];
    if (appConfig?.isDev ?? true) {
      Get.offAllNamed(Routes.DEV_MODE);
    } else {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (appConfig?.needUpdate(packageInfo.version) ?? false) {
        Get.offAllNamed(Routes.FORCE_UPDATE, arguments: {
          "playStoreUrl": appConfig?.playStoreUrl,
          "appleStoreUrl": appConfig?.appleStoreUrl
        });
      } else {
        AuthService.goToHomePage();
      }
    }
  }

  @override
  void onClose() {
    mainAnimationController.dispose();
    super.onClose();
  }
}
