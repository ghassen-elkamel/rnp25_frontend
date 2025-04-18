import 'dart:convert';

import 'package:rnp_front/app/data/models/entities/olm.dart';
import 'package:rnp_front/app/data/models/entities/subscription_option.dart';
import 'package:rnp_front/app/data/models/entities/user.dart';

class SubscriptionForm {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String positionType;
  final String positionTitle;
  final String? pathPicture;
  final String? pathReceipt;
  final String? uuid;
  final String? roommates;
  final User user;
  final Olm olm;
  final SubscriptionOption subscriptionOption;

  SubscriptionForm({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    required this.positionType,
    required this.positionTitle,
    this.pathPicture,
    this.pathReceipt,
    this.uuid,
    this.roommates,
    required this.user,
    required this.olm,
    required this.subscriptionOption,
  });

  factory SubscriptionForm.fromJson(Map<String, dynamic> json) {
    return SubscriptionForm(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      positionType: json['positionType'],
      positionTitle: json['positionTitle'],
      pathReceipt: json['pathReciept'] ?? json['pathReceipt'],
      uuid: json['uuid'],
      roommates: json['roommates'],
      user: json['user'] == null ? User() : User.fromJson(json['user']),
      pathPicture: json['pathPicture'],
      olm: Olm.fromJson(json['olm']),
      subscriptionOption:
          SubscriptionOption.fromJson(json['subscriptionOption']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'positionType': positionType,
      'positionTitle': positionTitle,
      'pathReciept': pathReceipt,
      'pathPicture': pathPicture,
      'uuid': uuid,
      'roommates': roommates,
      'user': user.toJson(),
      'olm': olm.toJson(),
      'subscriptionOption': subscriptionOption.toJson(),
    };
  }
}
