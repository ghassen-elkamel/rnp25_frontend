
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../core/theme/text.dart';
import '../../core/utils/file_picker.dart';
import '../../core/values/colors.dart';
import '../../data/models/file_info.dart';

class AtomAttachementButton extends StatelessWidget {
  final void Function(FileInfo)? onPressed;
  final bool withDocs;
  final bool onlyDocs;
  const AtomAttachementButton({
    required this.onPressed,
    this.withDocs = false,
    this.onlyDocs = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Rx<FileInfo?> selectedImage = Rx<FileInfo?>(null);

    return InkWell(
      onTap: () async {
        selectedImage.value = await CustomFilePicker.showPicker(

            context: context, withDocs: withDocs);
        if (selectedImage.value != null) {
          onPressed?.call(selectedImage.value!);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: secondColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset("assets/icons/link.png"),
              const SizedBox(width: 8),
              Obx(() {
                return selectedImage.value != null
                    ? SizedBox(
                  width: 100,
                  child: CustomText.l(
                    "${selectedImage.value?.fileName}",
                    color: white,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                )
                    : CustomText(
                  "attachment".tr,
                  color: white,
                  fontSize: 14,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}