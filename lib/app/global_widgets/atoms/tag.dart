import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/string/not_null_and_not_empty.dart';
import 'package:eco_trans/app/core/values/size.dart';

import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomTag extends StatelessWidget {
  const AtomTag({
    super.key,
    required String? text,
    this.textDirection,
    this.isSelected = false,
    this.color = greyDark,
    this.textColor = white,
    this.onTap,
    this.size,
    this.isGradient = false,
    this.isCircular = false,
    this.fontSize = smSize,
    this.padding = 5,
    this.margin = 2,
    this.width,
  }) : label = text ?? "";

  const AtomTag.size({
    super.key,
    required String? text,
    this.isSelected = false,
    this.textDirection,
    this.color = greyDark,
    this.textColor = white,
    this.onTap,
    this.size,
    this.isGradient = false,
    this.isCircular = false,
    this.fontSize = smSize,
    this.padding = 5,
    this.margin = 2,
  })  : label = text ?? "",
        width = null;

  final String label;
  final TextDirection? textDirection;
  final bool isSelected;
  final bool isGradient;
  final bool isCircular;
  final double fontSize;
  final double? size;
  final double padding;
  final double margin;
  final Color color;
  final Color textColor;
  final double? width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {

    if (!label.isFilled) {
      return const SizedBox();
    }
    Widget body = CustomText(
      label,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: textColor,
      textDirection: textDirection,
    );
    if (size != null) {
      body = SizedBox(
        height: size,
        width: size,
        child: body,
      );
    }

    if (width != null && size == null) {
      body = SizedBox(
        width: width,
        child: Center(child: body),
      );
    }
    if (isCircular) {
      body = DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: linearGradient,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: body,
          ),
        ),
      );
    } else {
      body = DecoratedBox(
        decoration: BoxDecoration(
            color: isSelected ? primaryColor : color,
            borderRadius: BorderRadius.circular(20),
            gradient: isGradient ? linearGradientBlue : null),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: body,
        ),
      );
    }
    body = Padding(
      padding: EdgeInsets.all(margin),
      child: body,
    );

    if (onTap != null) {
      body = InkWell(
        onTap: onTap,
        child: body,
      );
    }

    return body;
  }
}
