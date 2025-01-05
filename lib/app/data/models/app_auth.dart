import 'package:eco_trans/app/core/extensions/string/not_null_and_not_empty.dart';

class AppAuth {

  AppAuth({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    this.fcmToken,
  });

  final String countryCode;
  final String phoneNumber;
  final String password;
  final String? fcmToken;

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "password": password,
    if(fcmToken.isFilled)
    "fcmToken": fcmToken,
  };
}
