import 'dart:io';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ForceUpdateController extends GetxController {

  late String playStoreUrl;
  late String appleStoreUrl;

  @override
  void onInit() {
    playStoreUrl = Get.arguments['playStoreUrl'] ?? "";
    appleStoreUrl = Get.arguments['appleStoreUrl'] ?? "";

    super.onInit();
  }



  launchUpdate() {
    Platform.isAndroid ? _updateOnAndroid() : _updateOnIOs();
  }

  _updateOnAndroid() async {
    if (await canLaunchUrlString(playStoreUrl)) {
      await launchUrlString(playStoreUrl, mode: LaunchMode.externalApplication);
    }
  }

  _updateOnIOs() async {
    if (await canLaunchUrlString(appleStoreUrl)) {
      await launchUrlString(appleStoreUrl, mode: LaunchMode.externalApplication);
    }
  }

}
