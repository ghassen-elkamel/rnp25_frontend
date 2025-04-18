import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';
import 'package:rnp_front/app/global_widgets/molecules/drawer.dart';

import '../../../core/utils/alert.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/qr_code_scanner_controller.dart';

class QrCodeScannerView extends GetView<QrCodeScannerController> {
  const QrCodeScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scanQr'.tr),
        centerTitle: true,
      ),
      drawer: const MoleculeDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'scanQrDesc'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AtomButton(
              isSmall: true,
              label: 'scan'.tr,
              onPressed: () {
                // Show scanner in a modal dialog
                _showScannerDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showScannerDialog(BuildContext context) {
    // Reset scanner state
    controller.resetScanner();

    final Size screenSize = MediaQuery.of(context).size;
    final double dialogWidth =
        screenSize.width < 600 ? screenSize.width * 0.9 : 500;
    final double scannerSize = dialogWidth - 40; // Leave some padding

    // Show scanner in dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('scanQr'.tr),
        content: SizedBox(
          width: dialogWidth,
          height: scannerSize + 60, // Add space for controls
          child: Column(
            children: [
              SizedBox(
                width: scannerSize,
                height: scannerSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    controller: controller.scannerController,
                    onDetect: controller.onQRCodeDetected,
                    // Use fit: BoxFit.cover for a nicer appearance
                    fit: BoxFit.cover,
                    placeholderBuilder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.1),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            'cameraError'.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.scannerController.toggleTorch();
                    },
                    icon: const Icon(Icons.flashlight_on),
                    tooltip: 'flashlight'.tr,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    tooltip: 'cancel'.tr,
                  ),
                  IconButton(
                    onPressed: () {
                      controller.scannerController.switchCamera();
                    },
                    icon: const Icon(Icons.cameraswitch),
                    tooltip: 'switchCamera'.tr,
                  ),
                ],
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
