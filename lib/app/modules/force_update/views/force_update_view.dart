import 'package:flutter/material.dart';
import '../../../core/theme/text.dart';
import 'package:get/get.dart';
import '../../../global_widgets/atoms/button.dart';
import '../controllers/force_update_controller.dart';

class ForceUpdateView extends GetView<ForceUpdateController> {
  const ForceUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/images/big_logo.png"),
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomText.xxl(
                    "applicationRequiresUpdate".tr,
                  ),
                ),
                const SizedBox(height: 30),
                AtomButton(
                  label: "forceUpdateStore".tr,
                  onPressed: controller.launchUpdate,
                  isSmall: true,
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

}
