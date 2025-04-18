import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/global_widgets/atoms/safe_image_network.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('notifications'.tr),
        centerTitle: false,
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildNotificationsList()),
    );
  }

  Widget _buildNotificationsList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread notifications section
            _buildSectionHeader(
                'unread'.tr, controller.unreadNotifications.length),
            const SizedBox(height: 8),
            ...controller.unreadNotifications
                .map((notification) =>
                    _buildNotificationItem(notification, isUnread: true))
                .toList(),

            const SizedBox(height: 24),

            // Read notifications section
            _buildSectionHeader('read'.tr, controller.readNotifications.length),
            const SizedBox(height: 8),
            ...controller.readNotifications
                .map((notification) =>
                    _buildNotificationItem(notification, isUnread: false))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        CustomText(
          title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(width: 8),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: title == 'Unread'
                  ? const Color(0xFFF8DC3D)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: title == 'Unread' ? Colors.black : Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationItem(notification, {required bool isUnread}) {
    return Obx(() {
      bool isExpanded =
          controller.expandedNotifications.contains(notification.id);

      return GestureDetector(
        onTap: () {
          controller.toggleNotificationExpansion(notification.id);
          if (isUnread) {
            controller.markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? Colors.white : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: isUnread
                ? Border(
                    left: BorderSide(color: const Color(0xFFF8DC3D), width: 5))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isUnread ? 0.2 : 0.1),
                spreadRadius: isUnread ? 2 : 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 5, right: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8DC3D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      notification.body ??
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s',
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isUnread ? FontWeight.bold : FontWeight.normal,
                        color: isUnread ? Colors.black87 : Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _getTimeAgo(notification.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isUnread ? FontWeight.bold : FontWeight.normal,
                          color: isUnread ? Colors.black54 : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: isUnread ? Colors.black54 : Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'justNow'.tr;

    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'singleDay'.tr : 'multipleDays'.tr} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'singleHour'.tr : 'multipleHours'.tr} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'singleMinute'.tr : 'multipleMinutes'.tr} ago';
    } else {
      return 'justNow'.tr;
    }
  }
}
