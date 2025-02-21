import 'package:get/get.dart';

import '../controllers/forms_list_controller.dart';

class FormsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormsListController>(
      () => FormsListController(),
    );
  }
}
