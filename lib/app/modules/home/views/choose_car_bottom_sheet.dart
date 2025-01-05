import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/core/values/colors.dart';
import 'package:eco_trans/app/data/enums/button_type.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';
import 'package:eco_trans/app/global_widgets/atoms/button.dart';
import 'package:eco_trans/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/itinerary_steps.dart';

class ChooseCarBottomSheet extends StatelessWidget {
  final HomeController controller;

  const ChooseCarBottomSheet({
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
          CustomText.l(
            "chooseCarType".tr,
            color: grey,
          ),
          const SizedBox(height: 16),
          ...carTypes.map(
            (type) {
              return InkWell(
                onTap: () => controller.selectedCarType.value = type,
                child: Row(
                  children: [
                    type.icon,
                    const SizedBox(width: 20),
                    CustomText.l(type.name.tr.toUpperCase()),
                    const Spacer(),
                    Obx(
                      () {
                        if (controller.selectedCarType.value != type) {
                          return const SizedBox();
                        }
                        return const Icon(
                          Icons.check,
                          color: green,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ).expand(
            (element) {
              return [
                element,
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(
                    color: divider,
                    height: 1,
                  ),
                ),
              ];
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AtomButton(
                  buttonColor: ButtonColor.white,
                  label: "previous".tr,
                  onPressed: () {
                    controller.currentStep.value = ItinerarySteps.locations;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AtomButton(
                  label: "next".tr,
                  onPressed: () {
                    controller.currentStep.value = ItinerarySteps.payment;
                    controller.getTripEstimation();
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
