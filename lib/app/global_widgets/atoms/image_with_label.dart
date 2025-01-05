import 'package:flutter/material.dart';
import '../../core/values/colors.dart';
import '../../core/theme/text.dart';

class AtomImageWithLabel extends StatelessWidget {
  final String label;
  final Widget image;
  final TextDirection? textDirection;
  final Color labelColor;
  final Color color;

  const AtomImageWithLabel({
    super.key,
    required this.label,
    required this.image,
    this.textDirection,
    this.labelColor = black,
    this.color = black,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox(
      width: 140,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              image,
              const SizedBox(
                width: 8,
              ),
              CustomText.m(
                label,
                color: labelColor,
                textDirection: textDirection,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
    return body;
  }
}
