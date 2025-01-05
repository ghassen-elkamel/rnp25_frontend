import 'package:eco_trans/app/data/enums/role_type.dart';

class Role {
  Role({
    this.code,
    required this.label,
  });

  final RolesType? code;
  final String label;

  factory Role.fromJson(Map<String, dynamic> json,) {
    RolesType? rolesType;

    try {
      rolesType = RolesType.values.byName(json["code"]);
    } catch (_) {
    }
    return Role(
      code: rolesType,
      label: json["label"] ,
    );
  }

}
