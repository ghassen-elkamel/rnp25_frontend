import '../../data/enums/role_type.dart';

class AccessUser {
  AccessUser({
    this.userId,
    this.token,
    this.refreshToken,
    this.role,
    this.branchId,
    this.canSeeRate,
  });

  final String? token;
  final String? refreshToken;
  final bool? canSeeRate;
  final int? branchId;
  final int? userId;
  final RolesType? role;

  factory AccessUser.fromJson(Map<String, dynamic>? json) {
    RolesType? safeRole;
    try{
      if( json != null) {
        safeRole = RolesType.values.byName(json["role"]);
      }
    }catch(_){}

    return AccessUser(
      userId: json?["userId"],
      token: json?["accessToken"],
      refreshToken: json?["refreshToken"],
      branchId: json?["branchId"],
      canSeeRate: json?["canSeeRate"],
      role: safeRole,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        if(userId != null)
          "userId": userId,
        if(token != null)
          "accessToken": token,
        if(refreshToken != null)
          "refreshToken": refreshToken,
        if(branchId != null)
          "branchId": branchId,
        if(role != null)
          "role": role?.name,
        if(role != null)
          "canSeeRate": canSeeRate,
      };
}