import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rnp_front/app/core/utils/alert.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/values/colors.dart';

 download(List<int> bodyBytes, String fileName) async{
  try {
    await Permission.storage.request();
    String filePath = await _prepareSaveDir();
    filePath = '$filePath/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bodyBytes);

    Alert.showCustomSnackBar(
      title: "fileDownloaded".tr,
      message: "open".tr,
      duration: 10,
      onTapMessage: () async {
        await Permission.photos.request();
        OpenFile.open(filePath);
        Get.closeCurrentSnackbar();

      },
      icon: const Icon(
        Icons.file_download,
        color: black,
      ),
    );
  } catch (e) {
    Alert.showCustomSnackBar(
      title: "error".tr,
      message: "weCantDownloadThisFile".tr,
    );
  }
}

Future<String> _prepareSaveDir() async {
  String? localPath = await findLocalPath;
  final savedDir = Directory(localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create(recursive: true);
  }
  return localPath;
}

Future<String> get findLocalPath async {
  if (Platform.isAndroid) {
    return "/storage/emulated/0/Download";
  } else {
    var directory = await getApplicationDocumentsDirectory();
    return '${directory.path}${Platform.pathSeparator}Download';
  }
}
