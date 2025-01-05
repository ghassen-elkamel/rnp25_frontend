import 'package:flutter/material.dart';
import '../../core/values/colors.dart';


class AtomCircularIcon extends StatelessWidget {
  const AtomCircularIcon({
    this.icon,
    this.padding,
    this.onTap,
    super.key,
  });
  final IconData? icon;
  final double? padding;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 10,
          backgroundColor: secondColor,
          child: Icon(
          icon,
            size: 16,
            color: white,
          ),
        ),
      ),
    );
  }
}