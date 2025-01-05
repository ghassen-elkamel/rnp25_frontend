import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomDecoratedText extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double width;
  final double padding;
  final double fontSize;
  final void Function() onTap;
  final bool? isSelected;

  const AtomDecoratedText({
    super.key,
    required this.label,
    required this.onTap,
    this.width = 40,
    this.padding = 16,
    this.fontSize = 20,
    this.isSelected = false,
    this.labelColor = black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: isSelected != null && isSelected == true
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: white,
                  border: Border.all(color: primaryColor))
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: white,
                ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: CustomText(
                label,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                isGradient: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
