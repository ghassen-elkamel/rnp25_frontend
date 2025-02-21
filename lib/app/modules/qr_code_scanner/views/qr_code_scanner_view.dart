import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';

import '../../../core/utils/alert.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/qr_code_scanner_controller.dart';

class QrCodeScannerView extends GetView<QrCodeScannerController> {
  const QrCodeScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'scanQr'.tr,
        centerTitle: true,
        withMenu: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AtomButton(
                isSmall: true,
                label: 'scan',
                onPressed: () {
                  Alert.showCustomDialog(
                    title: "scanQR".tr,
                    content: SizedBox.square(
                      dimension: 300,
                      child: QRView(
                        key: controller.qrKey,
                        onQRViewCreated: controller.onQRViewCreated,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
