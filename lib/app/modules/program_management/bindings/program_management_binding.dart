import 'package:get/get.dart';

import '../controllers/program_management_controller.dart';

class ProgramManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgramManagementController>(
      () => ProgramManagementController(),
    );
  }
}
