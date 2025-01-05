import 'package:flutter/material.dart';

import '../../../../app/core/values/colors.dart';
import '../../core/theme/text.dart';
import '../atoms/text_field.dart';

class MoleculeEditableText extends StatelessWidget {
  const MoleculeEditableText({
    super.key,
    this.text = '',
    this.suffix,
    this.subText = const [],
    this.showLabel = false,
    this.isEdit = false,
    this.onChanged,
    this.label,
    this.readOnly = false,
    this.isRequired = true,
    this.color,
    this.tooltipMessage,
    this.onTap,
    this.textDirection,
    this.flex,
    this.controller,
  });

  final bool showLabel;
  final TextEditingController? controller;
  final int? flex;
  final Widget? suffix;
  final bool isEdit;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? label;
  final String? text;
  final List<String?> subText;
  final bool readOnly;
  final bool isRequired;
  final Color? color;
  final String? tooltipMessage;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerIntern =
        controller ?? TextEditingController(text: text);
    if (isEdit) {
      if (controllerIntern.text == '-') {
        controllerIntern.clear();
      }
      return Expanded(
        flex: flex ?? 4,
        child: AtomTextField.simple(
          controller: controllerIntern,
          hintText: label,
          isRequired: isRequired,
          readOnly: readOnly,
          padding: 0,
          onChanged: onChanged,
          suffix: suffix,
        ),
      );
    }
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: showLabel
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.l(
                  label,
                  textAlign: TextAlign.start,
                  color: greyDark,
                  textDirection: textDirection,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText.m(
                  controllerIntern.text,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  color: color ?? black,
                  textDirection: textDirection,
                ),
              ],
            )
          : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
          CustomText.m(
            controllerIntern.text,
            textAlign: TextAlign.start,
            color: color ?? black,
            textDirection: textDirection,
            maxLines: null,
          ),
          ...subText.where((element) => element?.isNotEmpty ?? false).map((text) => CustomText.sm(
            text,
            textAlign: TextAlign.start,
            color: black,
            textDirection: textDirection,
          ))
                  ],
                ),
    );
    content = onTap == null
        ? content
        : InkWell(
            onTap: onTap,
            child: content,
          );
    if (suffix != null) {
      content = Row(
        children: [
          content,
          suffix!,
        ],
      );
    }
    return Expanded(
      flex: flex ?? 1,
      child: tooltipMessage == null
          ? Align(alignment: AlignmentDirectional.centerStart, child: content)
          : Tooltip(
              message: tooltipMessage,
              child: content,
            ),
    );
  }
}
