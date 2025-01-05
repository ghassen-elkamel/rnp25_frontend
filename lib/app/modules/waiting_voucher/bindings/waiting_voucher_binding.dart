import 'package:get/get.dart';
import '../controllers/waiting_voucher_controller.dart';

class WaitingVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingVoucherController>(
      () => WaitingVoucherController(),
    );
  }
}
