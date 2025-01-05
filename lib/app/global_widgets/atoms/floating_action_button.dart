import 'package:flutter/material.dart';

import '../../core/values/colors.dart';

class AtomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const AtomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  })  : color = white,
        backgroundColor = primaryColor;

  const AtomFloatingActionButton.white({
    super.key,
    required this.onPressed,
    required this.icon,
  })  : color = primaryColor,
        backgroundColor = white;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      key: key,
      radius: 26,
      backgroundColor: backgroundColor,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
