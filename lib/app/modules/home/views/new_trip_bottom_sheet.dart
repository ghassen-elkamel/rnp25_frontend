import 'package:eco_trans/app/data/enums/itinerary_steps.dart';
import 'package:eco_trans/app/modules/home/controllers/home_controller.dart';
import 'package:eco_trans/app/modules/home/views/choose_car_bottom_sheet.dart';
import 'package:eco_trans/app/modules/home/views/locations_bottom_sheet.dart';
import 'package:eco_trans/app/modules/home/views/payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTripBottomSheet extends StatelessWidget {
  final HomeController controller;

  const NewTripBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          switch (controller.currentStep.value) {
            case ItinerarySteps.locations:
              return LocationsBottomSheet(controller: controller);
            case ItinerarySteps.carType:
              return ChooseCarBottomSheet(controller: controller);
            case ItinerarySteps.payment:
              return PaymentBottomSheet(controller: controller);
            case ItinerarySteps.waitingDriver:
              return ChooseCarBottomSheet(controller: controller);
            case ItinerarySteps.offer:
              return ChooseCarBottomSheet(controller: controller);
            case ItinerarySteps.driverComing:
              return ChooseCarBottomSheet(controller: controller);
            case ItinerarySteps.tripInProgress:
              return ChooseCarBottomSheet(controller: controller);
          }
        },),
      ],
    );
  }
}
