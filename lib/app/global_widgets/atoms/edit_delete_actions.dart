import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/alert.dart';
import '../../core/values/colors.dart';
import '../../data/models/form/item_action.dart';
import '../../global_widgets/atoms/icon_with_label.dart';

class AtomEditDeleteActions<T> extends StatelessWidget {
  const AtomEditDeleteActions({
    super.key,
    this.selectedItem,
    required this.currentItem,
    this.onDelete,
    this.onEdit,
    this.canShowDetails = true,
    this.isShowDetails = false,
    this.onEditShowDialog,
    this.canShowDetailsDialog,
    this.selectItem,
    this.clear,
    this.isGrouped = true,
    this.showButtons = true,
    this.otherActions = const [],
    required this.actionsWidth,
  });

  final T? selectedItem;
  final T currentItem;
  final void Function()? onDelete;
  final void Function(T?)? onEdit;
  final bool canShowDetails;
  final bool isShowDetails;
  final bool isGrouped;
  final void Function()? onEditShowDialog;
  final void Function()? canShowDetailsDialog;
  final void Function(T item)? selectItem;
  final void Function()? clear;
  final List<ItemAction<T>> otherActions;
  final double actionsWidth;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: actionsWidth,
      child: selectedItem == currentItem && onEdit != null
          ? Row(
              children: [
                IconButton(
                  onPressed: () => clear != null
                      ? clear!.call()
                      : throw ('to clear the data you must set the function clear()'),
                  icon: const Icon(
                    Icons.cancel,
                    color: greyDark,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onEdit?.call(null);
                  },
                  icon: const Icon(
                    Icons.save_as,
                    color: blue,
                  ),
                ),
              ],
            )
          : !isGrouped
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (onDelete != null && showButtons)
                      Flexible(
                        child: IconButton(
                          onPressed: () => showConfirmDelete(),
                          icon: const Icon(
                            Icons.delete,
                            color: red,
                          ),
                        ),
                      ),
                    if (onEdit != null && showButtons)
                      Flexible(
                        child: IconButton(
                          onPressed: onEditShowDialog ??
                              () => selectItem != null
                                  ? selectItem!.call(currentItem)
                                  : throw ('to edit you must set the function selectItem()'),
                          icon: const Icon(
                            Icons.edit,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    if (canShowDetails && showButtons)
                      IconButton(
                        onPressed: canShowDetailsDialog ??
                            () => selectItem != null
                                ? selectItem!.call(currentItem)
                                : throw ('to edit you must set the function selectItem()'),
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: primaryColor,
                        ),
                      ),
                    ...otherActions.map((e) => e.getWidget(context))
                  ],
                )
              : otherActions.isEmpty &&
                      !canShowDetails &&
                      onEdit == null &&
                      onDelete == null
                  ? const SizedBox()
                  : (otherActions.isNotEmpty || showButtons)
                      ? PopupMenuButton(
                          itemBuilder: (BuildContext bc) {
                            return [
                              if (canShowDetails && showButtons)
                                PopupMenuItem(
                                  onTap: () => safeCall(canShowDetailsDialog ??
                                      () => selectItem != null
                                          ? selectItem!.call(currentItem)
                                          : throw ('to edit you must set the function selectItem()')),
                                  child: AtomIconWithLabel(
                                    label: 'show'.tr,
                                    icon: Icons.remove_red_eye_outlined,
                                    iconColor: primaryColor,
                                  ),
                                ),
                              if ((onEdit != null ||
                                      onEditShowDialog != null) &&
                                  showButtons)
                                PopupMenuItem(
                                  onTap: () => safeCall(onEditShowDialog ??
                                      () => selectItem != null
                                          ? selectItem!.call(currentItem)
                                          : throw ('to edit you must set the function selectItem()')),
                                  child: AtomIconWithLabel(
                                    label: 'edit'.tr,
                                    icon: Icons.edit,
                                    iconColor: darkOrange,
                                  ),
                                ),
                              if (onDelete != null && showButtons)
                                PopupMenuItem(
                                  onTap: () =>
                                      safeCall(() => showConfirmDelete()),
                                  child: AtomIconWithLabel(
                                    label: 'delete'.tr,
                                    icon: Icons.delete,
                                    iconColor: red,
                                  ),
                                ),
                              ...otherActions.map(
                                (e) => PopupMenuItem(
                                  onTap: () {
                                      if(e.item != null){
                                        e.onPressed(e.item as T);
                                      }
                                  },
                                  child: AtomIconWithLabel(
                                    label: e.label,
                                    icon: e.icon,
                                    iconColor: e.iconColor,
                                  ),
                                ),
                              ),
                            ];
                          },
                        )
                      : const SizedBox(),
    );
  }

  void showConfirmDelete() {
    Alert.verifyRequest(
      action: "${'delete'.tr} ${currentItem.toString()}",
      onConfirm: () async => onDelete != null
          ? onDelete!.call()
          : throw ('to delete the data you must set the function onDelete()'),
    );
  }

  void safeCall(void Function() function) async {
    await Future.delayed(const Duration(milliseconds: 200));
    function.call();
  }
}
