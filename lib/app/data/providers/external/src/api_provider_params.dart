part of '../api_provider.dart';

class HttpParamsPostPut extends HttpParams {
  final Map<String, dynamic> body;

  HttpParamsPostPut({
    required super.endpoint,
    super.externalHost,
    super.externalPort,
    super.protocol,
    super.headers,
    super.queryParam,
    super.isUnderAPI,
    super.authorization,
    super.withLoadingAlert,
    required this.body,
    super.encodeBody,
    super.isFormData,
    super.files,
    super.file,
    super.transformData,
  });
}

class HttpParamsGetDelete extends HttpParams {
  HttpParamsGetDelete({
    required super.endpoint,
    super.externalHost,
    super.externalPort,
    super.protocol,
    super.headers,
    super.queryParam,
    super.isUnderAPI,
    super.authorization,
    super.withLoadingAlert,
    super.isRefresh,
    super.transformData,
  });
}

class HttpParams {
  final String endpoint;
  final String? externalHost;
  final String? protocol;
  final int? externalPort;
  final Map<String, String> headers;
  final Map<String, dynamic>? queryParam;
  final bool encodeBody;
  final bool isFormData;
  final List<FileInfo> files ;
  final FileInfo? file ;
  final String? authorization;
  final bool isUnderAPI;
  final bool withLoadingAlert;
  final bool isRefresh;
  final bool transformData;

  HttpParams({
    required this.endpoint,
    required this.externalHost,
    required this.externalPort,
    required this.protocol,
    this.headers = const {},
    required this.queryParam,
    this.isUnderAPI = true,
    this.authorization,
    this.withLoadingAlert = true,
    this.encodeBody = true,
    this.isFormData = false,
    this.files = const [],
    this.file,
    this.isRefresh = false,
    this.transformData = true,
  });
}
