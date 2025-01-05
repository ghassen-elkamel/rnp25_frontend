import 'package:get/get.dart';

import '../controllers/transfer_credit_controller.dart';

class TransferCreditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferCreditController>(
      () => TransferCreditController(),
    );
  }
}
