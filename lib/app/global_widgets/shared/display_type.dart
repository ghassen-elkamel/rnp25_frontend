import 'package:flutter/material.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import '../../core/values/colors.dart';
import 'package:get/get.dart';

class DisplayType extends StatelessWidget {
  const DisplayType({
    super.key,
    required this.isGrouped,
    required this.onChange,
  });

  final bool isGrouped;
  final void Function(bool isGrouped) onChange;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: CustomText.m(
                'grouped'.tr,
                color: isGrouped ? primaryColor : greyDark,
              ),
              onTap: () => onChange(true),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              child: CustomText.m(
                'detailed'.tr,
                color: isGrouped ? grey : primaryColor,
              ),
              onTap: () => onChange(false),
            ),
          ],
        ),
      ),
    );
  }
}
