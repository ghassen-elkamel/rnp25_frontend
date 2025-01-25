import 'package:flutter/material.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/values/colors.dart';

class AtomLink extends StatelessWidget {
  const AtomLink({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.color,
  });

  final String text;
  final void Function()? onTap;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(
              icon!,
              color: color ?? darkBlue,
            ),
          CustomText.l(
            text,
            color: color ?? darkBlue,
          ),
        ],
      ),
    );
  }
}
