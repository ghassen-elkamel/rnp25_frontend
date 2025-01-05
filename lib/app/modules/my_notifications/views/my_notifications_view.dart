import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/empty_data.dart';
import '../../../global_widgets/atoms/list_view_builder.dart';
import '../../../global_widgets/atoms/spinner_progress_indicator.dart';
import '../../../global_widgets/molecules/notification_card.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/my_notifications_controller.dart';

class MyNotificationsView extends GetView<MyNotificationsController> {
  const MyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "myNotifications".tr,
      withCloseIcon: true,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: controller.getNotifications,
        child: Obx(() {
          if (controller.listNotification.isEmpty &&
              controller.isLoading.isFalse) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AtomEmptyData(label: 'listEmpty'.tr),
            );
          }
          return Column(
            children: [
              if (controller.listNotification.isNotEmpty)
                Expanded(
                  child: AtomListViewBuilder(
                    items: controller.listNotification,
                    itemBuilder: (context, index, item) {
                      if (index ==
                              controller.listNotification.value.length - 1 &&
                          controller.page.hasNextPage) {
                        return Column(
                          children: [
                            MoleculeNotificationCard(
                              notification: item,
                              viewNotification: controller.viewNotification,
                            ),
                            const Divider(
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: AtomButton(
                                label: "loadMore".tr,
                                onPressed: controller.loadMore,
                              ),
                            ),
                          ],
                        );
                      }
                      return MoleculeNotificationCard(
                        notification: item,
                        viewNotification: controller.viewNotification,
                      );
                    },
                  ),
                ),
              Obx(() {
                if (controller.isLoading.isTrue) {
                  return const AtomSpinnerProgressIndicator();
                }
                return const SizedBox();
              }),
            ],
          );
        }),
      ),
    );
  }
}
