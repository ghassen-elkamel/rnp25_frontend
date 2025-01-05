import 'package:eco_trans/app/core/extensions/double/currency_format.dart';
import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/core/values/colors.dart';
import 'package:eco_trans/app/data/enums/button_type.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';
import 'package:eco_trans/app/data/enums/payment_method.dart';
import 'package:eco_trans/app/global_widgets/atoms/button.dart';
import 'package:eco_trans/app/global_widgets/atoms/spinner_progress_indicator.dart';
import 'package:eco_trans/app/global_widgets/atoms/text_field.dart';
import 'package:eco_trans/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../data/enums/itinerary_steps.dart';

class WaitingDriverBottomSheet extends StatelessWidget {
  final HomeController controller;

  const WaitingDriverBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    controller.selectedCarType.value.icon,
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomText.l(
                        "nearToYou".tr,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.tripEstimation.value == null) {
                  return const AtomSpinnerProgressIndicator(
                    size: 32,
                  );
                }
                return Column(
                  children: [
                    CustomText.xl(
                      controller.tripEstimation.value!.amount.toCurrency,
                      color: red,
                    ),
                    CustomText.m(
                      "${controller.tripEstimation.value!.duration} ${"min".tr}",
                      color: grey,
                    ),
                  ],
                );
              })
            ],
          ),
          const SizedBox(height: 16),
          CustomText.l(
            "paymentMode".tr,
            color: grey,
          ),
          Row(
            children: paymentMethods.map(
                  (paymentMethod) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      controller.selectedPaymentMethod.value = paymentMethod;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          paymentMethod.icon(
                            controller.selectedPaymentMethod.value == paymentMethod,
                          ),
                          CustomText.m(paymentMethod.name.tr, color: controller.selectedPaymentMethod.value == paymentMethod ? primaryColor : grey,)
                        ],
                      ),
                    ),
                  );
                });
              },
            ).toList(),
          ),
          AtomTextField.simple(
            hintText: "discountCode".tr,
            suffix: SvgPicture.asset("assets/icons/money/ticket.svg"),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AtomButton(
                  buttonColor: ButtonColor.white,
                  label: "previous".tr,
                  onPressed: () {
                    controller.currentStep.value = ItinerarySteps.carType;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AtomButton(
                  label: "validate".tr,
                  onPressed: () {
                    controller.currentStep.value = ItinerarySteps.waitingDriver;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
