import 'package:get/get.dart';
import '../../enums/notification_type.dart';

List<Notifications> notificationsFromJson(dynamic str) => List<Notifications>.from(str["items"].map((x) => Notifications.fromJson(x)));

class Notifications {
  Notifications({
    this.id,
    this.title,
    this.body,
    this.key,
    this.sender,
    this.receiver,
    this.createdAt,
    required this.viewed,
  });

  final int? id;
  final String? title;
  final String? body;
  final NotificationType? key;
  final String? sender;
  final String? receiver;
  final DateTime? createdAt;
  final Rx<bool> viewed;

  factory Notifications.fromJson(Map<String, dynamic>? json) {
    Rx<bool> v = Rx(json?["isViewed"] ?? true);
    NotificationType? key;
    try {
      key = NotificationType.values.byName(json?["key"]);
    } catch (_) {}
    return Notifications(
      id: json?["id"],
      title: json?["title"],
      body: json?["body"],
      key: key,
      sender: json?["sender"],
      receiver: json?["receiver"],
      viewed: v,
      createdAt: DateTime.tryParse(json!["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "key": key,
        "sender": sender,
        "receiver": receiver,
        "isViewed": viewed,
      };
}
