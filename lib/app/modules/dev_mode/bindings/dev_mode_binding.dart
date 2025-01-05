import 'package:get/get.dart';

import '../controllers/dev_mode_controller.dart';

class DevModeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevModeController>(
      () => DevModeController(),
    );
  }
}
