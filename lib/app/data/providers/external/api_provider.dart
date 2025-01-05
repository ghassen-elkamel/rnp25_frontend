import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../models/file_info.dart';
import '../../../core/utils/constant.dart';
import 'src/api_provider_helper.dart';
part 'src/api_provider_params.dart';
class ApiProvider {
  static ApiProvider? _instance;

  ApiProvider._internal();

  factory ApiProvider() {
    _instance ??= ApiProvider._internal();
    return _instance!;
  }

  Future<Map<String, dynamic>?> get(HttpParamsGetDelete params,
      {int attempt = 0}) async {
    dynamic responseJson;
    showLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    try {
      final response = await http
          .get(
            getUri(params),
            headers: getHeaders(params),
          )
          .timeout(timeoutDuration);
      responseJson = await verifyResponse(
          response: response,
          attempt: attempt,
          isRefresh: params.isRefresh,
          callback: () => get(params, attempt: attempt + 1));
    } catch (exception) {
      catchException(exception);
    }
    hideLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    return responseJson;
  }

  Future<Map<String, dynamic>?> post(HttpParamsPostPut params,
      {int attempt = 0}) async {
    dynamic responseJson;
    dynamic response;
    showLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    Uri uri = getUri(params);
    try {
      log(params.body.toString());
      List<FileInfo> files = [];
      files.addAll(params.files);
      if(params.file != null){
        files.add(params.file!);
      }

      if (params.isFormData || files.isNotEmpty) {

        var request = getFormDataRequest("POST", uri, body: params.body, files: files);
        var responseStream = await request.send();
        response = await http.Response.fromStream(responseStream);
      } else {
        response = await http
            .post(
              uri,
              body: params.encodeBody ? jsonEncode(params.body) : params.body,
              headers: getHeaders(params),
            )
            .timeout(timeoutDuration);
      }
      responseJson = await verifyResponse(
          response: response,
          attempt: attempt,
          isRefresh: params.isRefresh,
          callback: () => post(
                params,
                attempt: attempt + 1,
              ));
    } catch (exception) {
      catchException(exception);
    }
    hideLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    return responseJson;
  }

  Future<dynamic> delete(
    HttpParamsGetDelete params, {
    int attempt = 0,
  }) async {
    dynamic responseJson;
    showLoadingAlert(withLoadingAlert: params.withLoadingAlert);

    try {
      final response = await http
          .delete(
            getUri(params),
            headers: getHeaders(params),
          )
          .timeout(timeoutDuration);
      responseJson = await verifyResponse(
          response: response,
          attempt: attempt,
          isRefresh: params.isRefresh,
          callback: () => delete(params, attempt: attempt + 1));
    } catch (exception) {
      catchException(exception);
    }
    hideLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    return responseJson;
  }

  Future<Map<String, dynamic>?> patch(HttpParamsPostPut params,
      {int attempt = 0}) async {
    dynamic responseJson;
    dynamic response;
    showLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    Uri uri = getUri(params);
    try {
      if (params.isFormData) {
        var request = getFormDataRequest("PATCH", uri, body: params.body);
        var responseStream = await request.send();
        response = await http.Response.fromStream(responseStream);
      } else {
        response = await http
            .patch(
              uri,
              body: params.encodeBody ? jsonEncode(params.body) : params.body,
              headers: getHeaders(params),
            )
            .timeout(timeoutDuration);
      }
      responseJson = await verifyResponse(
          response: response,
          attempt: attempt,
          isRefresh: params.isRefresh,
          callback: () => patch(params, attempt: attempt + 1));
    } catch (exception) {
      catchException(exception);
    }
    hideLoadingAlert(withLoadingAlert: params.withLoadingAlert);
    return responseJson;
  }
}
