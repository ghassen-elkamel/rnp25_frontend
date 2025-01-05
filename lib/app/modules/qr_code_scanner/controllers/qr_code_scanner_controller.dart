import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../routes/app_pages.dart';

class QrCodeScannerController extends GetxController {

  final MobileScannerController scannerController = MobileScannerController();

  onDetect(BarcodeCapture barcodes) {
    scannerController.stop();

    if(barcodes.barcodes.firstOrNull?.displayValue != null) {
      Get.toNamed(
        Routes.WAITING_VOUCHER,
        parameters: {
          "code": barcodes.barcodes.first.displayValue!,
        },
      );
    }
  }
}
