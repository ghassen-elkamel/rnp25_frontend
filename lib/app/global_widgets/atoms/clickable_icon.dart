import 'package:flutter/material.dart';

import '../../core/values/colors.dart';
class AtomClickableIcon extends StatelessWidget {
  const AtomClickableIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (Rect bounds) =>
            textLinearGradient.createShader(bounds),
        child:  Icon(
          icon,
          size: 25,
          color: isSelected
              ? primaryColor
              : greyLight,
        ),
      ),
    );
  }
}