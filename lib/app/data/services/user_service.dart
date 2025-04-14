import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/role_type.dart';
import 'package:rnp_front/app/data/models/dto/create_subscription_form.dart';
import 'package:rnp_front/app/data/models/entities/subscription_form.dart';
import 'package:rnp_front/app/data/services/auth_service.dart';

import '../../core/utils/language_helper.dart';
import '../../data/models/file_info.dart';
import '../models/entities/user.dart';
import '../providers/external/api_provider.dart';
import 'dart:developer';
import 'dart:io';

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

  Future<Map<String, dynamic>?> signUp({
    required CreateSubscriptionFormDto createSubscriptionFormDto,
    required FileInfo receipt,
    bool withLoadingAlert = true,
  }) async {
    log("Starting signup process with receipt: ${receipt.fileName}");

    try {
      var response = await ApiProvider().post(
        HttpParamsPostPut(
          endpoint: "/v1/subscription-form",
          body: createSubscriptionFormDto.toJson(),
          withLoadingAlert: withLoadingAlert,
        ),
      );

      if (response != null) {
        log("Successfully created subscription form: ${response}");
        SubscriptionForm subscriptionForm = SubscriptionForm.fromJson(
          response,
        );

        log("Uploading receipt file: ${receipt.fileName}, size: ${receipt.bytes.length} bytes");

        // Try uploading the receipt directly
        final uploadResult = await uploadReceiptFile(
            subscriptionFormId: subscriptionForm.id,
            receipt: receipt,
            withLoadingAlert: withLoadingAlert);

        if (uploadResult) {
          // Get the updated subscription form
          var verifyResponse = await ApiProvider().get(
            HttpParamsGetDelete(
              endpoint: "/v1/subscription-form/${subscriptionForm.id}",
              withLoadingAlert: false,
            ),
          );

          if (verifyResponse != null) {
            log("Verified subscription form with updated receipt: ${verifyResponse}");
            return verifyResponse;
          }

          return response;
        } else {
          log("Receipt upload failed");
          return response; // Still return the created subscription form
        }
      }
    } catch (e) {
      log("Error during signup process: $e");
    }

    log("Failed to create subscription form or upload receipt");
    return null;
  }

  // Dedicated method for receipt file upload with detailed error handling
  Future<bool> uploadReceiptFile({
    required int subscriptionFormId,
    required FileInfo receipt,
    bool withLoadingAlert = true,
  }) async {
    try {
      log("Starting dedicated receipt upload for form #$subscriptionFormId");
      log("Receipt file details: name=${receipt.fileName}, size=${receipt.bytes.length} bytes");

      final response = await ApiProvider().post(
        HttpParamsPostPut(
          isFormData: true,
          endpoint: "/v1/subscription-form/receipt/$subscriptionFormId",
          body: {},
          files: [receipt],
          withLoadingAlert: withLoadingAlert,
        ),
      );

      log("Receipt upload response: $response");
      return response != null;
    } catch (e) {
      log("Receipt upload error: $e");
      return false;
    }
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

  Future<List<User>> findAllByRole({required List<RolesType> roles}) async {
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
    if (AuthService.isAdmin()) {
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

  activateUser(int? id) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users/activate/$id",
        body: {},
      ),
    );

    if (response != null) {
      return true;
    }
    return false;
  }

  blockUser(int? id) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/users/block/$id",
        body: {},
      ),
    );

    if (response != null) {
      return true;
    }
    return false;
  }
}
