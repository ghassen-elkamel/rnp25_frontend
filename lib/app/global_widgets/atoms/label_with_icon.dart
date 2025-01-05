import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/string/not_null_and_not_empty.dart';

import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomLabelWithIcon extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final TextDirection? textDirection;

  const AtomLabelWithIcon({super.key, this.label, this.icon, this.textDirection});

  @override
  Widget build(BuildContext context) {
    if(!label.isFilled){
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon!, color: greyLight),
          if (icon != null) const SizedBox(width: 8),
          CustomText.m(label, textDirection: textDirection,),
        ],
      ),
    );
  }
}
