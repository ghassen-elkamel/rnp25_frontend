import 'package:get/get.dart';
import '../../../data/models/response/meta_data.dart';
import '../../../data/models/response/paginated.dart';
import '../../../data/models/entities/notification.dart';
import '../../../data/services/notification_service.dart';

class MyNotificationsController extends GetxController {
  final NotificationService notificationService = NotificationService();
  RxList<Notifications> listNotification = <Notifications>[].obs;
  RxBool isLoading = true.obs;
  PageMetaData page = PageMetaData(
    page: 1,
    take: 10,
    hasNextPage: true,
  );

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  Future<void> getNotifications() async {
    isLoading.value = true;

    Paginated<Notifications> paginated =
        await notificationService.getNotifications(page);
    page = paginated.meta ?? page;
    listNotification.addAll([...paginated.items]);
    isLoading.value = false;
  }

  void viewNotification(Notifications notification) async {
    Notifications? response = await notificationService.viewNotification(
      idNotification: notification.id,
    );
    if (response?.id != null) {
      notification.viewed.value = true;
    }
  }

  loadMore() {
    page = page.nextPage();
    getNotifications();
  }
}
