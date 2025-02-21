import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/utils/alert.dart';
import 'package:rnp_front/app/data/models/entities/user-event.dart';
import 'package:rnp_front/app/data/services/user_event_service.dart';

class QrCodeScannerController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();
  UserEventService userEventService = UserEventService();
  GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  bool isScanned = false;
  Rx<String> qrText = Rx("");

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  void onQRViewCreated(QRViewController controller) {
    controller.pauseCamera();

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !isScanned) {
        controller.pauseCamera();
        qrText.value = scanData.code!;

        final response = await userEventService.verifyUuid(scanData.code!);
        if (response != null) {
          Get.back();
          UserEvent userEvent = response;
          Alert.showCustomDialog(
            title: "Success",
            content: Column(
              children: [
                CustomText.xxl("Welcome ${userEvent.user?.fullName}"),
              ],
            ),
            actions: [
              CupertinoButton(
                child: const Text("Ok"),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          );
        }
      }
    });
  }
}
