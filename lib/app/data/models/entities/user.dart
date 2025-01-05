import 'package:eco_trans/app/core/extensions/enum_formatter.dart';
import 'package:eco_trans/app/core/extensions/map/map_extension.dart';
import 'package:eco_trans/app/core/extensions/string/not_null_and_not_empty.dart';
import 'package:eco_trans/app/core/extensions/string/parse_double.dart';
import 'package:eco_trans/app/core/utils/transformer.dart';
import 'package:eco_trans/app/data/enums/role_type.dart';
import 'package:eco_trans/app/data/models/entities/branch.dart';
import 'package:eco_trans/app/data/models/entities/role.dart';

List<User> usersFromJson(dynamic str) =>
    List<User>.from(str["items"].map((x) => User.fromJson(x)));

class User {
  User({
    this.id,
    this.password,
    this.fullName,
    this.internalCode,
    this.branch,
    this.branchId,
    this.phoneNumber,
    this.countryCode,
    this.email,
    this.role,
    this.createdAt,
    this.pathPicture,
    this.language,
    this.credit,
    this.driver,
  });

  final int? id;
  final String? password;
  final String? internalCode;
  final String? fullName;
  final Branch? branch;
  final int? branchId;
  final String? phoneNumber;
  final String? countryCode;
  final String? email;
  final String? pathPicture;
  final RolesType? role;
  final DateTime? createdAt;
  final double? credit;
  late final String? language;
  final Driver? driver;

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
      branch: json.containsKeyNotNull("branch")
          ? Branch.fromJson(json["branch"])
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      language: json["language"],
      credit: json["credit"]
          .toString()
          .tryDouble,
      driver: Transformer(fromJson: Driver.fromJson, data: json["driver"]).tryTransformation()
    );
  }

  Map<String, dynamic> toJson() =>
      {
        if (id != null) "id": id,
        if (internalCode != null) "internalCode": internalCode,
        if (fullName != null) "fullName": fullName,
        if (email.isFilled) "email": email,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (countryCode != null) "countryCode": countryCode,
        if (password != null) "password": password,
        if (branchId != null) "branchId": branchId,
        if (role != null) "receivedRole": role?.name,
        if (language != null) "language": language,
        if (driver != null) "driver": driver?.toJson(),
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


enum DriverTripStatus {
  available,
  inProgress,
  notAvailable,
}

class Driver {
  final int? id;
  final String address;
  final String identificationPaper;
  final String drivingLicenseNumber;
  final String drivingLicenseType;
  final DateTime? drivingLicenseExpirationDate;
  final DriverTripStatus? status;
  final User? user;

  Driver({
    required this.id,
    required this.address,
    required this.identificationPaper,
    required this.drivingLicenseNumber,
    required this.drivingLicenseType,
    required this.drivingLicenseExpirationDate,
    this.status,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      if(id != null)'id': id,
      'address': address,
      'identificationPaper': identificationPaper,
      'drivingLicenseNumber': drivingLicenseNumber,
      'drivingLicenseType': drivingLicenseType,
      'drivingLicenseExpirationDate': drivingLicenseExpirationDate?.toIso8601String(),
      'status': status?.name
    };
  }

  // Create Driver object from JSON
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      address: json['address'],
      identificationPaper: json['identificationPaper'],
      drivingLicenseNumber: json['drivingLicenseNumber'] ,
      drivingLicenseType: json['drivingLicenseType'],
      user: Transformer(fromJson: User.fromJson, data: json["user"]).tryTransformation(),
      drivingLicenseExpirationDate: DateTime.tryParse(json['drivingLicenseExpirationDate']),
      status: DriverTripStatus.values.tryTransformation( json['status']),
    );
  }
}

