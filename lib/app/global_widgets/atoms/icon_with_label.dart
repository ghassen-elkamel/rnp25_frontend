import 'package:flutter/material.dart';
import '../../core/values/colors.dart';
import '../../core/theme/text.dart';

class AtomIconWithLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color labelColor;
  final double? iconSize;
  final bool? isCenter;
  final TextDirection? textDirection;
  final double? labelSize;
  const AtomIconWithLabel({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor = black,
    this.labelColor = black,
    this.iconSize = 16,
    this.textDirection,
    this.isCenter,
    this.labelSize,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCenter == true ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(
          color: iconColor,
          icon,
          size: iconSize,
        ),
        const SizedBox(
          width: 8,
        ),
        labelSize != null
            ? Text(
          label,
          textDirection: textDirection,
          textAlign: TextAlign.justify,

          style: TextStyle(
              color: labelColor,
              fontSize: labelSize
          ),
        )
            : CustomText.m(
          label,
          color: labelColor,
          textDirection: textDirection,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
