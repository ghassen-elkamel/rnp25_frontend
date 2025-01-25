import 'package:rnp_front/app/data/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/role_type.dart';

import '../../core/utils/language_helper.dart';
import '../../data/models/file_info.dart';
import '../models/entities/user.dart';
import '../providers/external/api_provider.dart';

class UserService {
  Future<User?> create({
    required User user,
    bool withLoadingAlert = true,
  }) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/users",
        body: user.toJson(),
        withLoadingAlert: withLoadingAlert,
      ),
    );
    if (response != null) {
      return User.fromJson(response, Get.locale?.languageCode);
    }
    return null;
  }
  Future<User?> createByAmin({
    required User user,
    bool withLoadingAlert = true,
  }) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/users/admin",
        body: user.toJson(),
        withLoadingAlert: withLoadingAlert,
      ),
    );
    if (response != null) {
      return User.fromJson(response, Get.locale?.languageCode);
    }
    return null;
  }

  Future<User?> findMe([int? userId]) async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/users/me",
        withLoadingAlert: false,
        queryParam: {
          if (userId != null) 'userId': userId.toString(),
        },
      ),
    );
    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  Future<User?> update({required User user}) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users",
        body: user.toJson(),
      ),
    );

    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  Future<bool> deleteUser([
    int? id,
  ]) async {
    var response = await ApiProvider().delete(
      HttpParamsGetDelete(
        endpoint: "/v1/users${id == null ? "" : "/$id"}",
      ),
    );
    return response != null;
  }

  Future<void> uploadProfilePicture(
      {required FileInfo file, bool withLoadingAlert = true}) async {
    await ApiProvider().post(
      HttpParamsPostPut(
          isFormData: true,
          endpoint: "/v1/users/profile/photo",
          body: {},
          files: [file],
          withLoadingAlert: withLoadingAlert),
    );
  }

  Future<List<User>> findAllByRole(
      {required List<RolesType> roles }) async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/users",
        queryParam: {"roles": roles.map((e) => e.name).join(",")},
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
      return usersFromJson(response);
    }
    return [];
  }

  Future<User?> setLanguage({required String language}) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users/language",
        queryParam: {'language': language},
        body: {},
      ),
    );

    if (response != null) {
      User? user = User.fromJson(response, Get.locale?.languageCode);
      await LanguageHelper.setLanguage(user.language);
      return user;
    }
    return null;
  }

  Future<User?> updateCanSeeRateValue(
      {required bool? canSeeRate, required int? id}) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users/can-see-rate/$id",
        queryParam: {'canSeeRate': canSeeRate.toString()},
        body: {},
      ),
    );

    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  Future<User?> createOrUpdate({required User user}) async {
    if (user.id != null) {
      return await update(user: user);
    }
    if(AuthService.isAdmin()) {
      return await createByAmin(user: user);
    }
    return await create(user: user);

  }

  Future<bool> updatePassword({int? id, required String newPassword}) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users/password/$id",
        body: {'newPassword': newPassword},
      ),
    );

    if (response != null) {
      return true;
    }
    return false;
  }
}
