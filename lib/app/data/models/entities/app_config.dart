import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig({
    required this.code,
    required this.playStoreUrl,
    required this.appleStoreUrl,
    required this.minVersionAndroid,
    required this.minVersionIOS,
    required this.isDev,
    required this.creationDate,
  }): version = kIsWeb ? "" : Platform.isIOS ? minVersionIOS : minVersionAndroid;

  final int code;
  final String? playStoreUrl;
  final String? appleStoreUrl;
  final String version;
  final String minVersionIOS;
  final String minVersionAndroid;
  final bool isDev;
  final DateTime creationDate;


  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    code: json["code"],
    playStoreUrl: json["playStoreUrl"],
    appleStoreUrl: json["appleStoreUrl"],
    minVersionAndroid: json["minVersionAndroid"],
    minVersionIOS: json["minVersionIOS"],
    isDev: json["isDev"],
    creationDate: DateTime.parse(json["creationDate"]),
  );

  bool needUpdate(String localVersion){
    if(version.isEmpty && kIsWeb){
      return false;
    }
    List<int> remote = version.split(".").map((e) => int.parse(e)).toList();
    List<int> local = localVersion.split(".").map((e) => int.parse(e)).toList();
    if(local.length != remote.length || local.length != 3){
      return true;
    }
    if(local[0] < remote[0]){
      return true;
    }
    if(local[0] == remote[0] && local[1] < remote[1]){
      return true;
    }
    if(local[1] == remote[1] && local[2] < remote[2]){
      return true;
    }

    return false;

  }
}