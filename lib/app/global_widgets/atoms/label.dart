import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/string/not_null_and_not_empty.dart';
import 'package:eco_trans/app/core/theme/text.dart';
import 'package:eco_trans/app/core/theme/text_theme.dart';

class AtomLabel extends StatelessWidget {
  final String label;
  final String? value;
  final TextDirection? valueTextDirection;

  const AtomLabel(
      {super.key, required this.label, this.value, this.valueTextDirection});

  @override
  Widget build(BuildContext context) {
    if(!value.isFilled){
      return const SizedBox();
    }
    return RichText(
      text: TextSpan(
        text: "$label : ",
        style: styleBlack2FontRobotoW500Size16,
        children: [
          WidgetSpan(
            child: CustomText.m(
              value,
              textDirection: valueTextDirection,
            ),
          ),
        ],
      ),
    );
  }
}
