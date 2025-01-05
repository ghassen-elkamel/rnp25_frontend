import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:eco_trans/app/core/utils/language_helper.dart';

import '../../../../core/utils/alert.dart';
import '../../../../core/utils/constant.dart';
import '../../../models/app_exception.dart';
import '../../../models/file_info.dart';
import '../../../services/auth_service.dart';
import '../api_provider.dart';

extension Helper on ApiProvider {
  Uri getUri(HttpParams params) {
    return Uri(
      scheme: params.protocol ?? protocol,
      host: params.externalHost ?? host,
      port: params.externalHost != null ? params.externalPort : port,
      path: "${params.isUnderAPI ? apiPrefix : ""}${params.endpoint}",
      queryParameters: params.queryParam,
    );
  }

  Future<Map<String, dynamic>?> verifyResponse({
    required http.Response response,
    required int attempt,
    required dynamic callback,
    required bool isRefresh,
    bool transformData = true,
  }) async {
    Map<String, dynamic>? data;
    try {
      data = json.decode(response.body.toString());
    } catch (_) {}

    log("[${response.statusCode}] \n${response.request} \n${response.body}");
    switch (response.statusCode) {
      case 401:
        if (data != null && data["message"] != null) {
          AuthService authService = AuthService();
          if (data["message"] is String &&
              data["message"].contains("jwt") &&
              !isRefresh) {
            bool refreshed = await authService.refreshToken();
            if (refreshed) {
              return await callback.call();
            }
          }

          Alert.showCustomDialog(
            title: data["message"].toString().tr,
            onClose: () {
              if (data!.containsKey('error') &&
                      data["error"] == 'Unauthorized' ||
                  data.containsKey('message') &&
                      data["message"] == 'Unauthorized') {
                authService.logout();
              }
            },
          );
        }
        return null;
      case 400:
        if (data != null) {
          if (data["errors"] != null) {
            Alert.showErrors(data);
          } else if (data["message"] != null) {
            String message = "";
            if (data["message"] is String) {
              message = data["message"].toString().tr;
            } else {
              message = data["message"].join("\n");
            }
            Alert.showCustomDialog(
              title: data.containsKey("error")
                  ? data["error"].toString().tr
                  : null,
              subTitle: message,
            );
          }
        }
        return null;
      case 403:
        if (data?["message"] != null) {
          Alert.showCustomDialog(title: data!["message"].toString().tr);
        }
        return null;

      case 404:
        if (data != null) {
          if (data["errors"] != null) {
            Alert.showErrors(data);
          } else if (data["message"] != null) {
            Alert.showCustomDialog(
              title: data["message"].toString().tr,
              subTitle: data.containsKey("error")
                  ? data["error"].toString().tr
                  : null,
            );
          }
        }
        return null;
      case 500:
        Alert.showCustomDialog(
          subTitle: "internal-server-error".tr,
        );
        break;
      case 502:
        if (data != null && data["message"] != null) {
          Alert.showCustomDialog(
            title: data["message"].toString().tr,
          );
        }
        break;
      default:
        if (data != null && data["errors"] != null) {
          Alert.showErrors(data);
          return null;
        }
        return data ?? {"response": response};
    }
    return null;
  }

  Map<String, String> getHeaders(HttpParams params) {
    String? token = AuthService.access?.token;

    return <String, String>{
      ...params.headers,
      'Content-Type': params.isFormData
          ? 'multipart/form-data'
          : !params.encodeBody
              ? 'application/x-www-form-urlencoded'
              : 'application/json',
      'Accept': 'application/json',
      if (token != null || params.authorization != null)
        'Authorization': "Bearer ${params.authorization ?? token.toString()}",
      if (LanguageHelper.language != null)
        'language': LanguageHelper.language.languageCode,
      if (AuthService.access?.branchId != null)
        'branchId': AuthService.access!.branchId.toString(),
      'timezone': DateTime.now().timeZoneOffset.inHours.toString(),
    };
  }

  Map<String, String> getImageHeaders() {
    String? token = AuthService.access?.token;
    return <String, String>{
      if (token != null) 'Authorization': "Bearer ${token.toString()}",
    };
  }

  http.MultipartRequest getFormDataRequest(
    String method,
    Uri uri, {
    required Map<String, dynamic> body,
    List<FileInfo> files = const [],
  }) {
    String? token = AuthService.access?.token;
    var request = http.MultipartRequest(method, uri);

    if (token != null) {
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    body.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    if (files.isNotEmpty) {
      for (FileInfo file in files) {
        http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'files',
          file.bytes,
          filename: file.fileName,
        );

        request.files.add(multipartFile);
      }
      return request;
    }
    throw Exception("MultipartRequest cannot be null");
  }

  void catchException(exception) {
    log(exception.toString());
    if (exception is UnauthorisedException) {
      log("*Exception: UnauthorisedException");
    } else if (exception is http.ClientException ||
        exception is SocketException ||
        exception is TimeoutException) {
      log("*Exception: ClientException SocketException TimeoutException");
      Alert.showCustomDialog(
          title: "failedServer".tr, image: "icons/offline_internet.png");
    } else {
      log("*Exception: Server");
    }
  }

  showLoadingAlert({required bool withLoadingAlert}) async {
    if (withLoadingAlert && !EasyLoading.isShow) {
      await EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
    }
  }

  hideLoadingAlert({required bool withLoadingAlert}) async {
    if (withLoadingAlert && EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
  }
}
