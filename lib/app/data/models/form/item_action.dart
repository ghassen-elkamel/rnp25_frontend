import 'package:flutter/material.dart';
import 'package:rnp_front/app/core/values/colors.dart';

class ItemAction<T> {
  const ItemAction({
    this.item,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.showIf,
    this.iconColor,
  });

  final T? item;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final  Function(T item) onPressed;
  final bool Function(T param)? showIf;

  Widget getWidget(BuildContext context) {
    if (item == null) {
      return const SizedBox();
    }
    return IconButton(
      onPressed: () => onPressed(item as T),
      icon: Icon(
        icon,
        color: iconColor ?? greyDark,
      ),
    );
  }
}
