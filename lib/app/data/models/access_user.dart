import '../../data/enums/role_type.dart';

class AccessUser {
  AccessUser({
    this.userId,
    this.token,
    this.refreshToken,
    this.role,
    this.companyId,
  });

  final String? token;
  final String? refreshToken;

  final int? companyId;
  final int? userId;
  final RolesType? role;

  factory AccessUser.fromJson(Map<String, dynamic>? json) {
    RolesType? safeRole;
    try {
      if (json != null) {
        safeRole = RolesType.values.byName(json["role"]);
      }
    } catch (_) {}

    return AccessUser(
      userId: json?["userId"],
      token: json?["accessToken"],
      refreshToken: json?["refreshToken"],
      companyId: json?["companyId"],
      role: safeRole,
    );
  }

  Map<String, dynamic> toJson() => {
        if (userId != null) "userId": userId,
        if (token != null) "accessToken": token,
        if (refreshToken != null) "refreshToken": refreshToken,
        if (companyId != null) "companyId": companyId,
        if (role != null) "role": role?.name,
      };
}
