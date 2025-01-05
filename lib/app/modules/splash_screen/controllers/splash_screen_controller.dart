import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/models/entities/app_config.dart';
import '../../../data/services/app_config_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double?> opacity;
  AppService appService = AppService();

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    const duration = Duration(seconds: 2);
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );
    opacity = Tween<double>(begin: 0.0, end: 1.0,).animate(animationController);
    animationController.repeat(reverse: true);
    nextPage();
  }

  Future<void> nextPage() async {
    Future waiter = Future.delayed(const Duration(seconds: 2));
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
}
