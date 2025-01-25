import 'package:rnp_front/app/core/extensions/string/not_null_and_not_empty.dart';
import 'package:rnp_front/app/core/extensions/string/parse_double.dart';
import 'package:rnp_front/app/core/utils/transformer.dart';
import 'package:rnp_front/app/data/enums/role_type.dart';
import 'package:rnp_front/app/data/models/entities/role.dart';

List<User> usersFromJson(dynamic str) =>
    List<User>.from(str["items"].map((x) => User.fromJson(x)));

class User {
  User({
    this.id,
    this.password,
    this.fullName,
    this.internalCode,
    this.phoneNumber,
    this.countryCode,
    this.email,
    this.role,
    this.createdAt,
    this.pathPicture,
    this.language,
    this.credit,
  });

  final int? id;
  final String? password;
  final String? internalCode;
  final String? fullName;

  final String? phoneNumber;
  final String? countryCode;
  final String? email;
  final String? pathPicture;
  final RolesType? role;
  final DateTime? createdAt;
  final double? credit;
  late final String? language;

  factory User.fromJson(Map<String, dynamic> json, [String? languageCode]) {
    Role? tryRole = Transformer(fromJson: Role.fromJson, data: json['role'])
        .tryTransformation();
    return User(
      id: json["id"],
      internalCode: json["internalCode"],
      password: json["password"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      countryCode: json["countryCode"],
      pathPicture: json["pathPicture"],
      email: json["email"],
      role: tryRole?.code,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      language: json["language"],
      credit: json["credit"].toString().tryDouble,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (internalCode != null) "internalCode": internalCode,
        if (fullName != null) "fullName": fullName,
        if (email.isFilled) "email": email,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (countryCode != null) "countryCode": countryCode,
        if (password != null) "password": password,
        if (role != null) "receivedRole": role?.name,
        if (language != null) "language": language,
      };

  User clone(User user) {
    return User(
      id: user.id ?? id,
      fullName: user.fullName,
      email: user.email,
      language: user.language ?? language,
    );
  }

  @override
  String toString() {
    String result = "";

    return '$result$fullName';
  }

  String fullData() {
    return '$fullName$countryCode$phoneNumber';
  }

  String get fullPhoneNumber {
    return '+ $countryCode $phoneNumber';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

extension ClientRole on User? {
  bool get isClient {
    return this?.role == RolesType.client;
  }
}
