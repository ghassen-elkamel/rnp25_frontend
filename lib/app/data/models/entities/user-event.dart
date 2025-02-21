import 'package:rnp_front/app/data/models/entities/event.dart';
import 'package:rnp_front/app/data/models/entities/user.dart';

class UserEvent {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic createdBy;
  final String uuid;
  final User user;
  final Event event;

  UserEvent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.uuid,
    required this.user,
    required this.event,
  });

  factory UserEvent.fromJson(Map<String, dynamic> json) => UserEvent(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        uuid: json["uuid"],
        user: User.fromJson(json["user"]),
        event: Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "uuid": uuid,
        "user": user.toJson(),
        "event": event.toJson(),
      };
}
