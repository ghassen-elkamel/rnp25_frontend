import 'package:rnp_front/app/core/extensions/string/not_null_and_not_empty.dart';

class AppAuth {
  AppAuth({

    required this.email,
    required this.password,
    this.fcmToken,
  });


  final String email;
  final String password;
  final String? fcmToken;

  Map<String, dynamic> toJson() => {

        "email": email,
        "password": password,
        if (fcmToken.isFilled) "fcmToken": fcmToken,
      };
}
