import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/file_info.dart';
import '../theme/text.dart';
import '../values/colors.dart';

enum FileSource {
  camera,
  gallery,
  storage,
}

enum AllowedFile { all, images }

class CustomFilePicker {
  static Future<FilePickerResult?> pickDoc({
    FileSource src = FileSource.storage,
    AllowedFile allowed = AllowedFile.all,
  }) async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowed == AllowedFile.all ? FileType.any : FileType.image,
      withData: true,
    );
    EasyLoading.dismiss();
    return result;
  }

  static Future<FileInfo?> showPicker({
    required BuildContext context,
    bool withDocs = false,
    bool withVideos = false,
  }) async {
    return (await showMultiPicker(
        context: context, withDocs: withDocs, withVideos: withVideos))
        .firstOrNull;
  }

  static Future<List<FileInfo>> showMultiPicker({
    required BuildContext context,
    bool withDocs = false,
    bool withVideos = false,
  }) async {
    List<XFile?> imageFiles = [];
    FilePickerResult? docFile;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (withDocs)
                ListTile(
                  leading: const Icon(Icons.dock),
                  title: CustomText.m(
                    'document'.tr,
                    color: grey,
                  ),
                  onTap: () async {
                    docFile = await pickDoc();
                    Navigator.of(context).pop();
                  },
                ),
              if (withDocs)
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Divider(),
                ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: CustomText.m(
                  'photoLibrary'.tr,
                  color: grey,
                ),
                onTap: () async {
                  imageFiles = await ImagePicker().pickMultiImage();
                  Navigator.of(context).pop();
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                child: Divider(),
              ),
              if (withVideos)
                ListTile(
                  leading: const Icon(Icons.video_camera_back_outlined),
                  title: CustomText.m(
                    'showMedia'.tr,
                    color: grey,
                  ),
                  onTap: () async {
                    docFile = await pickDoc();
                    Navigator.of(context).pop();
                  },
                ),
              if (withVideos)
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Divider(),
                ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: CustomText.m('camera'.tr, color: grey),
                onTap: () async {
                  imageFiles = [
                    await ImagePicker().pickImage(source: ImageSource.camera)
                  ];
                  Navigator.of(context).pop();
                },
              ),
              if (withVideos)
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Divider(),
                ),
              if (withVideos)
                ListTile(
                  leading: const Icon(Icons.video_call),
                  title: CustomText.m('video'.tr, color: grey),
                  onTap: () async {
                    imageFiles = [
                      await ImagePicker().pickVideo(source: ImageSource.camera)
                    ];
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
    if (imageFiles.isNotEmpty && imageFiles.first != null) {
      List<FileInfo> items = [];
      for (XFile? imageFile in imageFiles) {
        if (imageFile != null) {
          CompressFormat? format =
              imageFile.path.split(".").last.getCompressFormat;
          Uint8List? result;
          if (format != null) {
            try {
              result = await FlutterImageCompress.compressWithList(
                (await imageFile.readAsBytes()),
                quality: 50,
                format: CompressFormat.jpeg,
              );
            } catch (_) {
              log("error while compressing");
            }
          } else {
            // MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            //   imageFile.path,
            //   quality: VideoQuality.DefaultQuality,
            //   deleteOrigin: false,
            // );
            // result = await mediaInfo?.file?.readAsBytes();
            log("compress not supported");
          }

          result ??= (await imageFile.readAsBytes());

          items.add(FileInfo(
            fileName: imageFile.path,
            path: imageFile.path,
            length: result.length,
            bytes: result,
          ));
        }
      }
      return items;
    }

    if (docFile?.files.isNotEmpty ?? false) {
      return [
        FileInfo(
          fileName: docFile!.files.first.name,
          path: docFile!.files.first.path,
          length: docFile!.files.first.bytes?.length ?? 0,
          bytes: docFile!.files.first.bytes ?? [],
        )
      ];
    }
    return [];
  }
}

extension CompressFormatExtension on String {
  CompressFormat? get getCompressFormat {
    switch (this) {
      case 'png':
        return CompressFormat.png;
      case 'jpeg':
      case 'jpg':
        return CompressFormat.jpeg;
      case 'webp':
        return CompressFormat.webp;
      case 'heic':
        return CompressFormat.heic;
      default:
        return null;
    }
  }
}
