import 'package:get/get.dart';

import '../controllers/my_notifications_controller.dart';

class MyNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyNotificationsController>(
      () => MyNotificationsController(),
    );
  }
}
