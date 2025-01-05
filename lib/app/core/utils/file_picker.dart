import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/text.dart';
import '../../data/models/file_info.dart';
import '../values/colors.dart';
import 'package:get/get.dart';

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
    bool onlyDocs = false,
  }) async {
    XFile? imageFile;
    FilePickerResult? docFile;
    if(onlyDocs){
      docFile = await pickDoc();
    }else{
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                if(withDocs)
                  ListTile(
                    leading: const Icon(Icons.dock),
                    title: CustomText.m(
                      'document'.tr,
                      color: greyDark,
                    ),
                    onTap: () async {
                      docFile = await pickDoc();
                      Navigator.of(context).pop();
                    },
                  ),
                if(withDocs) const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: CustomText.m(
                    'photoLibrary'.tr,
                    color: greyDark,
                  ),
                  onTap: () async {
                    imageFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: CustomText.m('camera'.tr, color: greyDark),
                  onTap: () async {
                    imageFile =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    if (imageFile != null) {
      return FileInfo(
        fileName: imageFile!.path.split('/').last,
        length: await imageFile!.length(),
        bytes: (await imageFile!.readAsBytes()).toList(),
      );
    }

    if (docFile?.files.isNotEmpty ?? false) {
      return FileInfo(
        fileName: docFile!.files.first.name,
        length: docFile!.files.first.bytes?.length ?? 0,
        bytes: docFile!.files.first.bytes ?? [],
      );
    }
    return null;
  }
}
