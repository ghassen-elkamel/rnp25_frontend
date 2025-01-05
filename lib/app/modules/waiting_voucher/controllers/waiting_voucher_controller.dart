import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../core/utils/alert.dart';
import '../../../core/values/colors.dart';
import '../../../data/models/entities/voucher.dart';
import '../../../data/services/voucher_service.dart';

class WaitingVoucherController extends GetxController {
  VoucherService voucherService = VoucherService();
  String codeQr = "";
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    codeQr = Get.parameters['code'] ?? "";
    verifyVoucher();
    super.onInit();
  }

  verifyVoucher() async {
    isLoading.value = true;
    Voucher voucher = Voucher.fromString(codeQr);
    Voucher? result = await voucherService.verifyVoucher(voucher: voucher);
    Get.back();

    isLoading.value = false;
    if (result?.id != null) {
      Get.back();
      EasyLoading.instance
        ..backgroundColor = primaryColor
        ..radius = 10.0
        ..textColor = white;
      EasyLoading.showToast('chargedSuccessfullyWithVoucher'.tr);
    } else {
      Alert.showCustomDialog(
        title: "This code is used or infected".tr,
        onClose: () {
          Get.back();
          Get.back();
        },
      );
    }
  }
}
