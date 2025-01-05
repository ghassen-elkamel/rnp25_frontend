import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_trans/app/core/values/colors.dart';
import '../../../app/core/theme/text.dart';
import '../../../app/core/utils/alert.dart';

enum NotificationType {
  welcome,
  createdTransaction,
  newTransaction,
  transactionRequest,
  transactionAccepted,
  transactionDelivered,
  sendProposal,
  acceptProposal,
  cancelProposal,
  other,
}

extension TransactionTypeIcon on NotificationType? {
  void showNotification(RemoteMessage message) {
    switch (this) {
      case NotificationType.other:
      case NotificationType.createdTransaction:
      case NotificationType.newTransaction:
      case NotificationType.transactionRequest:
      case NotificationType.transactionAccepted:
      case NotificationType.transactionDelivered:
      case NotificationType.sendProposal:
      case NotificationType.acceptProposal:
      case NotificationType.cancelProposal:
        Alert.showCustomDialog(
          title: message.notification!.title,
          titleStyle: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          content: CustomText.m(
            message.notification!.body ?? "",
            textAlign: TextAlign.center,
          ),
        );
        break;

      case null:
      case NotificationType.welcome:
        Get.snackbar(
          message.notification?.title ?? "",
          message.notification?.body ?? "",
          icon: const Icon(Icons.notifications, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        break;
    }
  }
}
