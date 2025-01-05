import 'package:flutter/material.dart';

import '../values/colors.dart';
import '../values/font_family.dart';
import '../values/size.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final FontWeight fontWeight;
  final bool isGradient;
  final bool withFixedSize;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = mSize,
    this.color = black,
    this.fontFamily = secondFamily,
    this.fontWeight = FontWeight.w200,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  }) : withFixedSize = false;

  const CustomText.xs(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = secondFamily,
    this.fontWeight = FontWeight.w300,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = xsSize,
        withFixedSize = false;

  const CustomText.sm(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w400,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = smSize,
        withFixedSize = false;

  const CustomText.m(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w500,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = mSize,
        withFixedSize = false;

  const CustomText.l(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w600,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = lSize,
        withFixedSize = false;

  const CustomText.xl(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w800,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = xlSize,
        withFixedSize = false;

  const CustomText.xxl(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w900,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  })  : fontSize = xxlSize,
        withFixedSize = false;

  const CustomText.showAll(
    this.text, {
    super.key,
    this.color = black,
    this.fontSize = xxlSize,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w800,
    this.textDirection,
    this.textAlign = TextAlign.left,
    this.decoration,
    this.isGradient = false,
    this.maxLines,
    this.overflow,
  })  : withFixedSize = false;

  const CustomText.fixedSize(
    this.text, {
    super.key,
    this.color = black,
    this.fontFamily = firstFamily,
    this.fontWeight = FontWeight.w500,
    this.textDirection,
    this.textAlign,
    this.decoration,
    this.isGradient = false,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.fontSize = mSize,
  }) : withFixedSize = true;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        color: isGradient ? null : color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        decoration: decoration,
        fontWeight: fontWeight,
        foreground: isGradient
            ? (Paint()
              ..shader = textLinearGradient.createShader(
                const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
              ))
            : null,
        height: 1.5,
      ),
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.justify,
      textScaler: withFixedSize ? TextScaler.noScaling : null,
    );
  }
}
