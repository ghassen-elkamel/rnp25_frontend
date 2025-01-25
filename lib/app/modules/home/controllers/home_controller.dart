import 'dart:async';

import 'package:rnp_front/app/core/utils/image.dart';
import 'package:rnp_front/app/data/enums/car_type.dart';
import 'package:rnp_front/app/data/enums/itinerary_steps.dart';
import 'package:rnp_front/app/data/enums/payment_method.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/alert.dart';
import '../../../data/providers/google_map/entity/prediction.dart';
import '../../../data/providers/google_map/google_maps_provider.dart';

class HomeController extends GetxController {





  RxBool isLoading = false.obs;


  @override
  Future<void> onInit() async {
    isLoading.value = true;

    isLoading.value = false;

    super.onInit();
  }


  @override
  void onClose() {

    super.onClose();
  }

}



