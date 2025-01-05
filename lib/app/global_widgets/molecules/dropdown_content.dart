import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/values/colors.dart';
import '../../data/models/item_select.dart';
import '../../global_widgets/atoms/empty_list.dart';
import '../../global_widgets/atoms/item_card.dart';
import '../atoms/text_field.dart';

class MoleculeDropdownContent<T> extends StatelessWidget {
  final List<ItemSelect<T>> items;
  final ItemSelect<T>? selectedItem;
  final List<ItemSelect<T>> selectedItems;
  final void Function(ItemSelect<T>) onTap;
  final void Function(String value)? onSearch;

  const MoleculeDropdownContent({
    super.key,
    required this.items,
    required this.onTap,
    this.onSearch,
    this.selectedItem,
    this.selectedItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onSearch != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: AtomTextField(
              hintText: "search".tr,
              onChanged: onSearch,
              height: 40,
              borderRadius: 30,
              suffix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: secondColor,
                ),
              ),
            ),
          ),
        items.isEmpty
            ? const AtomEmptyList()
            : Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return AtomItemCard<T>(
                      item: items[index],
                      onTap: onTap,
                      isSelected: selectedItem?.value == items[index].value ||
                          selectedItems
                              .map((e) => e.value)
                              .contains(items[index].value),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
