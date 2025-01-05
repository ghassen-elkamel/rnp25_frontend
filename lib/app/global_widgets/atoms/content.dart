import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomContent extends StatelessWidget {
  final String? title;
  final Color titleColor;
  final Widget child;
  final Widget? icon;
  final bool isExpanded;
  final Function()? onTap;

  const AtomContent({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.onTap,
    this.titleColor = black,
  }) : isExpanded = false;

  const AtomContent.expanded({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.onTap,
    this.titleColor = black,
  })  : isExpanded = true;

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (title != null) {
      content = Column(
        children: [
          icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.xl(
                      title!.tr,
                      color: titleColor,
                    ),
                    icon!,
                  ],
                )
              : CustomText.xl(
                  title!.tr,
                  color: titleColor,
                ),
          const SizedBox(height: 6),
          content,
        ],
      );
    }

    Widget result = Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: greyLight, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ),
      ),
    );

    if (onTap != null) {
      result = InkWell(
          onTap: () {
            onTap?.call();
          },
          child: result);
    }
    if (isExpanded) {
      result = Expanded(child: result);
    }

    return result;
  }
}
