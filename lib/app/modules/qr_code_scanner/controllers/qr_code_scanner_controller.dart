import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/utils/alert.dart';
import 'package:rnp_front/app/core/utils/constant.dart';
import 'package:rnp_front/app/data/models/entities/user-event.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';
import 'package:rnp_front/app/data/services/user_form_service.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';

import '../../../data/models/entities/subscription_form.dart';
import '../../../data/providers/external/api_provider.dart';
import '../../../global_widgets/atoms/safe_image_network.dart';

class QrCodeScannerController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();
  UserFormService userEventService = UserFormService();
  bool isScanning = false;
  bool isScanned = false;
  final RxBool hasPermission = true.obs;
  final RxBool isScanComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  void resetScanner() {
    isScanned = false;
    isScanComplete.value = false;
  }

  Future<void> onQRCodeDetected(BarcodeCapture capture) async {
    if (isScanned) return; // Prevent multiple scans

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
      try {
        isScanned = true;
        isScanComplete.value = true;

        scannerController.stop(); // Stop scanning

        final qrCode = barcodes[0].rawValue!;
        final response = await userEventService.verifyUuid(qrCode);

        if (response != null) {
          Get.back(); // Close scanner view
          SubscriptionSuccessDialog.show(response);
        } else {
          // Display error message when scan returns null
          Get.back(); // Close scanner view
          Alert.showCustomDialog(
            title: "scanError".tr,
            subTitle: "qrCodeInvalid".tr,
            onClose: () {
              Get.back();
              resetScanner();
            },
          );
        }
      } catch (e) {
        isScanned = false;
        isScanComplete.value = false;
        print("Error processing QR code: $e");

        // Show error dialog
        Get.back(); // Close scanner view
        Alert.showCustomDialog(
          title: "scanError".tr,
          subTitle: "errorProcessingQR".tr,
          onClose: () {
            Get.back();
            resetScanner();
          },
        );
      }
    }
  }
}

class SubscriptionSuccessDialog {
  static void show(SubscriptionForm subscriptionForm) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final screenSize = MediaQuery.of(Get.context!).size;
    final isSmallScreen = screenSize.width < 600;
    final double dialogWidth = isSmallScreen ? screenSize.width * 0.9 : 500;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: dialogWidth,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'subscriptionDetails'.tr,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // User info with profile picture
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture
                  Container(
                    width: 100,
                    height: 100,
                    child: ClipOval(
                      child: subscriptionForm.user.pathPicture != null
                          ? AtomSafeImageNetwork(
                              height: 100,
                              width: 100,
                              radius: 100,
                              path: subscriptionForm.user.pathPicture,
                              headers: ApiProvider().getImageHeaders(),
                              host: hostUploadPhotoProfile,
                              isCircular: true,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // User details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(
                            'name'.tr, subscriptionForm.user.fullName ?? 'N/A'),
                        _buildInfoItem(
                            'phone'.tr, subscriptionForm.user.fullPhoneNumber),
                        if (subscriptionForm.user.email != null)
                          _buildInfoItem(
                              'email'.tr, subscriptionForm.user.email!),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Subscription info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'subscriptionInformation'.tr,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoItem('olm'.tr, subscriptionForm.olm.name),
                            _buildInfoItem(
                                'position'.tr, subscriptionForm.positionTitle),
                            _buildInfoItem(
                                'type'.tr, subscriptionForm.positionType),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoItem(
                                'option'.tr,
                                subscriptionForm
                                    .subscriptionOption.subscriptionType),
                            _buildInfoItem('fee'.tr,
                                '${subscriptionForm.subscriptionOption.price} TND'),
                            _buildInfoItem('id'.tr, '#${subscriptionForm.id}'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Display roommates if available
                  if (subscriptionForm.roommates != null &&
                      subscriptionForm.roommates!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'roommates'.tr,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoItem(
                            'roommates'.tr, subscriptionForm.roommates!),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AtomButton(
                    label: 'ok'.tr,
                    onPressed: () => Get.back(),
                    isSmall: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
