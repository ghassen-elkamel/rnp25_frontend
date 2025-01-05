import 'package:flutter/material.dart';
import '../../core/theme/text.dart';

class AtomEmptyData extends StatelessWidget {
  final String label;
  const AtomEmptyData({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: CustomText.m(
          label,
        ),
      ),
    );
  }
}
