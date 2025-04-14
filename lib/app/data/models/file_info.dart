import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/alert.dart';

class FileInfo {
  List<int> bytes;
  String fileName;
  String? path;
  int length;

  FileInfo({
    required this.fileName,
    required this.path,
    required this.length,
    required this.bytes,
  });

  // Get just the file name without the path
  String get getFileName {
    return fileName.split('/').last;
  }

  // Set filename with proper handling
  set setFileName(String name) {
    fileName = name;
  }

  List<XFile> getXFiles() {
    List<XFile> files = [];
    if (bytes.isNotEmpty && fileName.isNotEmpty) {
      XFile imageFile = XFile.fromData(
        Uint8List.fromList(bytes),
        mimeType: lookupMimeType(fileName),
        name: fileName.split('/').last,
      );
      files.add(imageFile);
    }
    return files;
  }

  share({String? text, void Function()? onFinish}) {
    Alert.verifyRequest(
      action: "toShare".tr,
      onConfirm: () async {
        Get.back();
        await Share.shareXFiles(getXFiles(), subject: "share".tr, text: text);
        onFinish?.call();
      },
    );
  }
}

extension MultiFilesShare on List<FileInfo> {
  List<XFile> getXFiles() {
    List<XFile> files = [];
    for (var file in this) {
      if (file.bytes.isNotEmpty && file.fileName.isNotEmpty) {
        files.add(XFile.fromData(
          Uint8List.fromList(file.bytes),
          mimeType: lookupMimeType(file.fileName),
          name: file.fileName.split('/').last,
          path: file.fileName,
        ));
      }
    }
    return files;
  }

  share({String? text, void Function()? onFinish}) {
    Alert.verifyRequest(
      action: "toShare".tr,
      onConfirm: () async {
        Get.back();
        await Share.shareXFiles(getXFiles(), subject: "share".tr, text: text);
        onFinish?.call();
      },
    );
  }
}
