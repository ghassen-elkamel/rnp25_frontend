import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/core/values/colors.dart';
import 'package:eco_trans/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/itinerary_steps.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/dashed_line.dart';

class LocationsBottomSheet extends StatelessWidget {
  final HomeController controller;

  const LocationsBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset("assets/icons/map/ic_current.png", width: 30),
                  const Expanded(child: DashedLine()),
                  Image.asset(
                    "assets/icons/map/ic_pin.png",
                    width: 21,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.m(
                      "startLocation".tr,
                      color: grey,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomText.l(
                            controller.currentPosition.value ==
                                    controller.startPosition.value
                                ? "myCurrentLocation".tr
                                : controller.startLocationLabel.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            controller.isSelectStartLocation = true;
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/icons/map/ic_map.png",
                            width: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: divider,
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomText.m(
                      "targetLocation".tr,
                      color: grey,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomText.l(
                            controller.currentPosition.value ==
                                    controller.targetPosition.value
                                ? "myCurrentLocation".tr
                                : controller.targetLocationLabel.value,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            controller.isSelectStartLocation = false;
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/icons/map/ic_map.png",
                            width: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AtomButton(
            label: "next".tr,
            onPressed: () {
              controller.currentStep.value = ItinerarySteps.carType;
            },
          ),
        )
      ],
    );
  }
}
