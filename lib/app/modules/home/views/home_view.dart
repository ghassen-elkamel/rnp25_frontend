import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/values/colors.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 1,
      title: 'welcome'.tr,
      padding: EdgeInsets.zero,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
            child: QrImageView(
          data: controller.userEvent.value?.uuid.toString() ?? '',
          version: QrVersions.auto,
          backgroundColor: Colors.transparent,
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: secondColor,
          ),
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(35, 35),
          ),
          semanticsLabel: 'Ticket',
          gapless: true,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: secondColor,
          ),
          size: 300.0,
        ));
      }),
    );
  }
}
