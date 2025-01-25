import 'package:rnp_front/app/modules/qr_code_scanner/views/scanner_error.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/qr_code_scanner_controller.dart';

class QrCodeScannerView extends GetView<QrCodeScannerController> {
  const QrCodeScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return AppScaffold(
      title: 'voucherScanner'.tr,
      centerTitle: true,
      withCloseIcon: true,
      body: MobileScanner(
        fit: BoxFit.contain,
        scanWindow: scanWindow,
        onDetect: controller.onDetect,
        controller: controller.scannerController,
        errorBuilder: (context, error, child) {
          return ScannerErrorWidget(error: error);
        },
      ),
    );
  }
}