import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/text.dart';
import '../../../core/values/colors.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/phone_text_field.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/transfer_credit_controller.dart';

class TransferCreditView extends GetView<TransferCreditController> {
  const TransferCreditView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'walletTransfer'.tr,
      withCloseIcon: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText.xxl(
                        "sloganTransfer1".tr,
                        color: secondColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText.xxl(
                        "sloganTransfer2".tr,
                        color: secondColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  AtomPhoneTextField(
                    label: "phone".tr,
                    controller: controller.phoneNumber,
                    isRequired: true,
                    onCountryChanged: (countryCode) async {
                      controller.countryCode = countryCode;
                    },
                  ),
                  AtomTextField(
                    label: "amount".tr,
                    controller: controller.amount,
                    hintText: 'insertAmount'.tr,
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(height: 200),
                  AtomButton(
                    label: "submit".tr,
                    onPressed: controller.createTransaction,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
