import 'package:get/get.dart';

import '../controllers/cars_controller.dart';

class CarsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarsController>(
      () => CarsController(),
    );
  }
}
