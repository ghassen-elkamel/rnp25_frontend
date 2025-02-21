import 'dart:async';

import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/user-event.dart';
import 'package:rnp_front/app/data/services/user_event_service.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  UserEventService userEventService = UserEventService();
  Rx<UserEvent?> userEvent =Rx<UserEvent?>(null);

  @override
  Future<void> onInit() async {
    isLoading.value = true;
getQrCode();
    isLoading.value = false;

    super.onInit();
  }

  getQrCode() async {
    final response = await userEventService.getUserUUid('2');
    if(response!=null){
      userEvent.value = response;
    }


  }

  @override
  void onClose() {
    super.onClose();
  }
}
