import 'package:flutter/material.dart';

import '../../core/theme/text.dart';
import '../../core/theme/text_theme.dart';
import '../../core/utils/screen.dart';
import '../../core/values/colors.dart';
import '../../data/enums/button_type.dart';

class AtomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final ButtonColor buttonColor;
  final Color? textColor;
  final bool isSmall;
  final bool primaryColorBorder;
  final double width;
  final double height;
  final double radius;

  const AtomButton({
    super.key,
    required this.label,
    this.buttonColor = ButtonColor.primary,
    this.primaryColorBorder = false,
    this.onPressed,
    this.isSmall = false,
    this.textColor,
    this.width = 130,
    this.height = 51,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    ElevatedButton elevatedButton = ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          elevation: WidgetStateProperty.all(10),
          minimumSize: WidgetStateProperty.all(
            isSmall ? Size(width, height) : Size.fromHeight(height),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                color: primaryColorBorder ? primaryColor : Colors.transparent,
              ),
            ),
          ),
          textStyle: WidgetStateProperty.all(styleFontBebasW400Size18),
          shadowColor: WidgetStateProperty.all(greyLight),
          foregroundColor: WidgetStateProperty.all(getOnPressedColor()),
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return getOnPressedColor();
            } else if (states.contains(WidgetState.disabled)) {
              return greyLight;
            } else if (states.contains(WidgetState.focused)) {
              return grey.withOpacity(0.9);
            }
            return getButtonColor();
          })),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile(context) ? 8.0 : 30.0,
          vertical: 0,
        ),
        child: CustomText.l(
          label,
          color: getLabelColor(),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return elevatedButton;
  }

  getOnPressedColor() {
    switch (buttonColor) {
      case ButtonColor.primary:
        return primaryColor.withOpacity(0.7);
      case ButtonColor.second:
        return secondColor.withOpacity(0.7);
      case ButtonColor.white:
        return black.withOpacity(0.005);
      case ButtonColor.third:
        return thirdColor.withOpacity(0.7);
      case ButtonColor.greyLight:
        return white.withOpacity(0.7);
      case ButtonColor.greenLight:
        return greenLight.withOpacity(0.7);
      case ButtonColor.red:
        return red.withOpacity(0.7);
    }
  }

  getLabelColor() {
    if (onPressed == null) {
      return grey;
    }

    if (textColor != null) {
      return textColor;
    }
    switch (buttonColor) {
      case ButtonColor.white:
      case ButtonColor.greyLight:
        return primaryColor;

      case ButtonColor.third:
      case ButtonColor.second:
      case ButtonColor.primary:
      case ButtonColor.greenLight:
      case ButtonColor.red:
        return white;
    }
  }

  Color getButtonColor() {
    if (onPressed == null) {
      return greyLight;
    }

    switch (buttonColor) {
      case ButtonColor.white:
        return white;

      case ButtonColor.third:
        return thirdColor;
      case ButtonColor.second:
        return secondColor;

      case ButtonColor.primary:
        return primaryColor;

      case ButtonColor.greyLight:
        return greyLight.withOpacity(0.7);

      case ButtonColor.greenLight:
        return greenLight;

      case ButtonColor.red:
        return red;
    }
  }
}
