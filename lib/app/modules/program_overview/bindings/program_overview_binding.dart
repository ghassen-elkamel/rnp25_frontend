import 'package:get/get.dart';

import '../controllers/program_overview_controller.dart';

class ProgramOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgramOverviewController>(
      () => ProgramOverviewController(),
    );
  }
}
