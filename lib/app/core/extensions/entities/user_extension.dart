import '../../../data/models/entities/user.dart';

extension FullPhone on User? {
  String get fullPhoneNumber =>
      this?.countryCode == null || this?.phoneNumber == null
          ? ""
          : "${this!.countryCode} ${this!.phoneNumber}";
}
