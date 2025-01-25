import 'package:flutter/material.dart';
import 'package:rnp_front/app/core/utils/date.dart';
import 'package:rnp_front/app/global_widgets/atoms/text_field.dart';

class MoleculeDatePicker extends StatelessWidget {
  final TextEditingController controller;
  DateTime? value;
  final String label;
  final bool isRequired;
  final void Function(DateTime? date) onSelectDate;

  MoleculeDatePicker({
    super.key,
    required this.label,
    required this.onSelectDate,
    this.value,
    TextEditingController? controller,
    this.isRequired = false,
  })  : controller = controller ?? TextEditingController(
            text: value != null ? UtilsDate.formatDDMMYYYY(value) : '');

  @override
  Widget build(BuildContext context) {
    return AtomTextField.simple(
      controller: controller,
      selectTextOnFocus: false,
      isRequired: isRequired,
      label: label,
      readOnly: true,
      suffix: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () => pick(context),
        ),
      ),
      onTap: () => pick(context),
    );
  }

  Future<void> pick(BuildContext context) async {
    value = await UtilsDate.getDate(context, initialDate: value);
    controller.text = UtilsDate.formatDDMMYYYY(value);
    onSelectDate.call(value);
  }
}
