import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/atoms/spinner_progress_indicator.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/text.dart';
import '../../../core/values/colors.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/waiting_voucher_controller.dart';

class WaitingVoucherView extends GetView<WaitingVoucherController> {
  const WaitingVoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'waiting'.tr,
      withCloseIcon: true,
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CustomText.l(
                    'dontCloseApp'.tr,
                    color: secondColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const AtomSpinnerProgressIndicator(),
            ],
          );
        }
        return Center(
          child: InkWell(
            onTap: () => Get.toNamed(Routes.QR_CODE_SCANNER),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomText.l(
                    "somethingWentWrongPleaseScanAgain".tr,
                  ),
                  const SizedBox(height: 16),
                  CustomText.m("retry".tr),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
