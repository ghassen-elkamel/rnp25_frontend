import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/theme/text_theme.dart';
import '../../core/values/colors.dart';

class AtomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String? checkBoxText;
  final String? clickableCheckBoxText;
  final MainAxisAlignment? mainAxisAlignment;
  final void Function()? onTextClick;

  const AtomCheckBox({
    super.key,
    this.value = false,
    required this.onChanged,
    this.checkBoxText,
    this.clickableCheckBoxText,
    this.mainAxisAlignment,
    this.onTextClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged?.call(!value);
      },
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: SizedBox.square(
              dimension: 24,
              child: Checkbox(
                value: value,
                onChanged: (value) {
                  onChanged?.call(value);
                },
                side: const BorderSide(color: greyDark, width: 2.0, ),
                activeColor: primaryColor,
              ),
            ),
          ),
          if ((checkBoxText?.isNotEmpty ?? false) || (clickableCheckBoxText?.isNotEmpty ?? false))
            Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(children: [
                  if (checkBoxText?.isNotEmpty ?? false)
                    TextSpan(
                    text: '$checkBoxText ',
                    style: styleBlackLightFontRobotoW400Size16,
                  ),
                  if (clickableCheckBoxText?.isNotEmpty ?? false)
                    TextSpan(
                    text: clickableCheckBoxText,
                    style: stylePrimaryColorFontRobotoW400Size16Underline,
                    recognizer: TapGestureRecognizer()..onTap = onTextClick,
                  ),
                  if (clickableCheckBoxText?.isNotEmpty ?? false)
                    TextSpan(
                      text: "*",
                      style: stylePrimaryColorFontRobotoW400Size16,
                      recognizer: TapGestureRecognizer()..onTap = onTextClick,
                    ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
