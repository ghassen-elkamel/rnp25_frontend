import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/enums/notification_type.dart';
import '../../core/theme/text.dart';
import '../../core/utils/date.dart';
import '../../data/models/entities/notification.dart';

class MoleculeNotificationCard extends StatelessWidget {
  const MoleculeNotificationCard({
    required this.notification,
    required this.viewNotification,
    super.key,
  });

  final Notifications notification;
  final Function viewNotification;

  String getTimeDifference(DateTime inputDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(inputDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${"seconds".tr}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${"minutes".tr}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${"hours".tr}';
    } else if (difference.inDays == 1) {
      return 'yesterday'.tr;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${"days".tr}';
    } else {
      return UtilsDate.formatDDMMYYYY(inputDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          viewNotification(notification);
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: notification.viewed.value ? Colors.grey[200] : Colors.white,
            boxShadow: [
              if (notification.viewed.isFalse)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.l(
                  notification.key == NotificationType.welcome
                      ? 'youHaveAuthenticated'.tr
                      : notification.body?.tr ?? "",
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !notification.viewed.value
                                ? Colors.red
                                : Colors.green,
                          ),
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                        ),
                        CustomText.m(
                          getTimeDifference(notification.createdAt!),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
