import 'package:flutter/material.dart';
import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomChip extends StatelessWidget {
  const AtomChip({
    required this.label,
    this.avatar,
    this.selected = false,
    this.selectedColor = transparent,
    this.onTap,
    super.key,
  });

  final String label;
  final Color? selectedColor;
  final Widget? avatar;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final InputChip chip = InputChip(
      padding: const EdgeInsets.all(8.0),
      label: CustomText.sm(label),
      avatar: avatar ?? const SizedBox(),
      selected: selected,
      backgroundColor: white,
      selectedColor: selectedColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? secondColor : greyLight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      onSelected: (bool value) {
        if (onTap != null) {
          onTap!();
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: chip,
    );
  }
}
