import 'package:flutter/material.dart';

import '../../core/theme/text.dart';
import '../../core/values/colors.dart';
class AtomRateCurrency extends StatelessWidget {
  final String from;
  final String to;
  final double? value;

  const AtomRateCurrency({
    super.key,
    required this.from,
    required this.to,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: greyLight, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CustomText.l(
                    from,
                    fontWeight: FontWeight.w900,
                  ),
                  const Icon(Icons.arrow_forward_outlined),
                  CustomText.l(
                    to,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              CustomText.sm(
                value?.toString(),
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
