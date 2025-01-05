import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/enums/notification_type.dart';

class ConfigFirebase {
  static String currentToken = "";

  static init() async {
    await Firebase.initializeApp();
    await getPermission();
    getToken();
    messageListener();
  }

  static getToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      currentToken = token ?? "";
      log("FCM Token : $token");
    });
  }

  static Future<void> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  static void messageListener() {
    FirebaseMessaging.onMessage.listen(listen);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  static listen(RemoteMessage message) async {
    log("Notification Message: ${message.toMap()}");

    NotificationType? notificationType;
    if (message.notification != null && message.data.containsKey("key")) {
      notificationType = NotificationType.values.byName(message.data["key"]);
    } else {
      notificationType = NotificationType.other;
    }

    notificationType.showNotification(message);
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    final dynamic data = message.data;
  }
  if (message.notification!.title!.isNotEmpty) {
    final dynamic notification = message.notification;
  }
}
