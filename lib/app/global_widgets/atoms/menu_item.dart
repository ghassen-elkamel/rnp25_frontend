import 'package:rnp_front/app/core/utils/screen.dart';
import 'package:flutter/material.dart';
import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final void Function()? onTap;

  const AtomMenuItem(
      {super.key,
      required this.label,
      required this.icon,
      this.onTap,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: const EdgeInsets.all(15.0),
      child: Icon(
        icon,
        color: isSelected ? primaryColor: black,
        size: 25,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.3): transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34.0),
              child: !isMobile(context) ? child : Row(
                children: [
                  child,
                  Column(
                    children: [
                      Hero(
                        tag: label,
                        child: isSelected
                            ? CustomText.m(
                                label,
                                color: white,
                              )
                            : CustomText.l(label),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
