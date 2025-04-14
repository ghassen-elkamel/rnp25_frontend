import 'package:get/get.dart';
import 'package:rnp_front/app/data/models/entities/notification.dart';
import 'package:rnp_front/app/data/models/response/meta_data.dart';
import 'package:rnp_front/app/data/services/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  
  final RxList<Notifications> notifications = <Notifications>[].obs;
  final RxList<int> expandedNotifications = <int>[].obs;
  final RxBool isLoading = true.obs;
  
  final PageMetaData pageMetaData = PageMetaData(
    page: 1,
    take: 50,
  );

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final result = await _notificationService.getNotifications(pageMetaData);
      notifications.value = result.items;
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNotificationExpansion(int? id) {
    if (id == null) return;
    
    if (expandedNotifications.contains(id)) {
      expandedNotifications.remove(id);
    } else {
      expandedNotifications.add(id);
    }
  }

  Future<void> markAsRead(int? id) async {
    if (id == null) return;
    
    try {
      final notification = notifications.firstWhere((n) => n.id == id);
      if (!notification.viewed.value) {
        await _notificationService.viewNotification(idNotification: id);
        notification.viewed.value = true;
        notifications.refresh();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  List<Notifications> get unreadNotifications => 
    notifications.where((notification) => !notification.viewed.value).toList();

  List<Notifications> get readNotifications => 
    notifications.where((notification) => notification.viewed.value).toList();
}
