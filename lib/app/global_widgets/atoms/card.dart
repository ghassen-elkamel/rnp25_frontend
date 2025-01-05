import 'package:flutter/material.dart';

import '../../core/utils/screen.dart';
import '../../core/values/colors.dart';

class AtomCard extends StatelessWidget {
  final double? width;
  final double margin;
  final double radius;
  final double padding;
  final Widget child;
  final bool onlyWeb;
  final bool isSelected;
  final bool isGradient;
  final Color color;
  final void Function()? onTap;

  const AtomCard({
    super.key,
    required this.child,
    this.onlyWeb = false,
    this.isSelected = false,
    this.isGradient = false,
    this.color = white,
    this.margin = 0,
    this.padding = 12,
    this.radius = 10,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (onlyWeb && isMobile(context)) {
      return child;
    }

    final Widget card = Padding(
      padding: EdgeInsets.all(margin),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          side: isSelected
              ? const BorderSide(
                  color: secondColor,
                )
              : BorderSide.none,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isGradient ? linearGradient : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
