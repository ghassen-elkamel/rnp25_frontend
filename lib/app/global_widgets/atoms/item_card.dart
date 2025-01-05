import 'package:flutter/material.dart';
import '../../core/values/colors.dart';
import '../../data/models/item_select.dart';
import '../../core/theme/text_theme.dart';

class AtomItemCard<T> extends StatelessWidget {
  final ItemSelect<T> item;
  final bool isSelected;
  final void Function(ItemSelect<T> value) onTap;

  const AtomItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: isSelected ? primaryColor : Colors.transparent,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: item.pathPicture != null
                  ? Center(
                      child: Image.asset(
                        item.pathPicture!,
                        width: 24,
                        height: 24,
                      ),
                    )
                  : Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: isSelected
                          ? styleWhiteFontRobotoW500Size16
                          : styleBlack90FontRobotoW400Size16,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
