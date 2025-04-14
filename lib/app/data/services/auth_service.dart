import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/utils/constant.dart';
import '../../core/utils/language_helper.dart';
import '../../data/enums/role_type.dart';
import '../../data/providers/storage_provider.dart';
import '../../routes/app_pages.dart';
import '../models/access_user.dart';
import '../models/app_auth.dart';
import '../models/entities/user.dart';
import '../providers/external/api_provider.dart';

class AuthService {
  static bool isAuthenticated = false;
  static bool haveManyCompanies = false;
  static int? selectedCompanyCode;
  static AccessUser? access;

  static bool isAppManager() {
    return access?.role == RolesType.appManager;
  }

  static bool isClient() {
    return access?.role == RolesType.client;
  }

  static bool isAdmin() {
    return access?.role == RolesType.admin;
  }

  static bool isSupervisor() {
    return access?.role == RolesType.supervisor;
  }

  static List<RolesType> getMyRolesFilter() {
    return [RolesType.supervisor, RolesType.client];
  }

  Future<bool> customerAuth({
    required AppAuth auth,
    bool withLoadingAlert = true,
  }) async {
    final response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/auth/login",
        body: auth.toJson(),
        withLoadingAlert: withLoadingAlert,
      ),
    );
    if (response != null && response["language"] != null) {
      LanguageHelper.setLanguage(response["language"]);
    }
    return saveToken(response);
  }

  bool saveToken(response) {
    isAuthenticated = response != null && response["accessToken"] != null;
    if (isAuthenticated) {
      StorageHelper storage = StorageHelper();
      access = AccessUser.fromJson(response);
      storage.saveItem(key: storageAccessUserKey, item: access?.toJson());
    }
    return isAuthenticated;
  }

  Future<bool> refreshToken() async {
    final response = await ApiProvider().get(HttpParamsGetDelete(
      endpoint: "/v1/auth/refresh",
      authorization: AuthService.access?.refreshToken,
      isRefresh: true,
    ));

    return saveToken(response);
  }

  logout() {
    StorageHelper storage = StorageHelper();
    storage.removeItem(key: storageAccessUserKey);

    access = AccessUser();
    isAuthenticated = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> isAppLoggedIn() async {
    StorageHelper storage = StorageHelper();
    access =
        AccessUser.fromJson(await storage.fetchItem(key: storageAccessUserKey));
    isAuthenticated = access?.token != null;
  }

  static Future<void> goToHomePage() async {
    StorageHelper storageHelper = StorageHelper();
    bool? onboardingCompleted =
        await storageHelper.fetchItem(key: 'onboarding_completed');

    if (!kIsWeb&&(onboardingCompleted == null || onboardingCompleted == false)) {
      Get.offAllNamed(Routes.GET_STARTED);
    } else {
      if (!AuthService.isAuthenticated) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      switch (access?.role) {
        case RolesType.appManager:
          Get.offAllNamed(Routes.COMPANY);
          break;
        case RolesType.admin:

            Get.offAllNamed(Routes.USERS);


          break;
        case RolesType.client:
          Get.offAllNamed(Routes.HOME);
          break;
        case RolesType.supervisor:
          Get.offAllNamed(Routes.QR_CODE_SCANNER);

          break;
        case null:
      }
    }
  }

  static bool isMe(int? id) {
    return id == access?.userId;
  }
  Future<User?> getMe() async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/users/me",
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
return User.fromJson(response);
    }
    return null;
  }
}
