import 'package:flutter/material.dart';
import 'package:eco_trans/app/data/models/file_info.dart';

import '../../core/utils/file_picker.dart';
import '../atoms/text_field.dart';

class MoleculeAttachment extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final void Function(FileInfo file) onTap;

  const MoleculeAttachment({
    super.key,
    required this.controller,
    required this.label,
    required this.onTap,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return AtomTextField.simple(
      onTap: () => getAttachment(context),
      label: label,
      isRequired: isRequired,
      controller: controller,
      readOnly: true,
      suffix: IconButton(
        icon: const Icon(Icons.attach_file),
        onPressed: () => getAttachment(context),
      ),
    );
  }

  Future getAttachment(BuildContext context) async {
    FileInfo? selectedAttachment = await CustomFilePicker.showPicker(context: context, withDocs: true);
    if (selectedAttachment != null) {
      controller.text = selectedAttachment.fileName;
      onTap(selectedAttachment);
    }
  }
}
