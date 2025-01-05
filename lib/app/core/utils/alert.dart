import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/data/enums/button_type.dart';
import 'package:eco_trans/app/global_widgets/atoms/button.dart';
import 'package:eco_trans/app/global_widgets/atoms/circular_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/core/values/colors.dart';
import '../../global_widgets/atoms/alert_dialog.dart';

class Alert {
  static Future<dynamic> showCustomDialog({
    IconData? icon,
    String? image,
    String? title,
    Widget? customTitle,
    TextStyle? titleStyle,
    String? subTitle,
    double maxWidth = 500,
    TextAlign? subTitleAlign,
    Widget? content,
    bool withCloseBtn = true,
    List<Widget> actions = const [],
    Function()? onClose,
  }) async {
    if (Get.context != null) {
      var result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return AtomAlertDialog(
            icon: icon,
            image: image,
            title: title,
            customTitle: customTitle,
            titleStyle: titleStyle,
            subTitle: subTitle,
            content: content,
            actions: actions,
            maxWidth: maxWidth,
            onClose: onClose,
            subTitleAlign: subTitleAlign,
            withCloseBtn: withCloseBtn,
          );
        },
      );
      return result;
    }
  }

  static void showCustomSnackBar({
    required String title,
    required String message,
    void Function()? onTapMessage,
    Widget? icon,
    int duration = 2,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomText.l(
                title.tr,
              ),
            ),
            AtomCircularIcon(
              onTap: () => Get.closeCurrentSnackbar(),
              icon: Icons.close,
            )
          ],
        ),
        messageText: InkWell(
          onTap: onTapMessage,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.m(
              message.tr,
              color: onTapMessage != null ? darkBlue : black,
            ),
          ),
        ),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 85,
        ),
        padding: const EdgeInsets.only(
          top: 13,
          bottom: 16,
          left: 20.55,
          right: 13,
        ),
        backgroundColor: white.withOpacity(0.95),
        duration: Duration(seconds: duration),
        borderRadius: 10,
        icon: icon,
        boxShadows: const [BoxShadow(color: greyLight, blurRadius: 1)],
      ),
    );
  }

  static void showErrors(Map<String, dynamic> data) {
    showCustomDialog(
      title: data["message"] ?? "",
      subTitle: data["errors"] ?? "",
      subTitleAlign: TextAlign.start,
    );
  }

  static void verifyRequest(
      {String? question,
      required String action,
      required void Function() onConfirm}) {
    showCustomDialog(
      title: "${question ?? "doYouWant".tr} $action ${'interrogationMark'.tr}",
      content: const SizedBox(
        height: 16,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AtomButton(
                label: "cancel".tr,
                buttonColor: ButtonColor.white,
                onPressed: () => Get.back(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AtomButton(
                label: "confirm".tr,
                onPressed: onConfirm,
              ),
            ),
          ],
        )
      ],
    );
  }

  static void bottomSheet(Widget child) {
    Get.bottomSheet(
      DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: white
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(100),
                color: greyDark,
              ),
              width: 57,
              height: 6,
            ),
            const SizedBox(height: 16),
            Center(child: child),
          ],
        ),
      ),
      enableDrag: true,
    );
  }
}
