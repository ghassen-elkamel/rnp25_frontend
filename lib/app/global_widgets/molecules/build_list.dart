import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eco_trans/app/data/models/item_header.dart';
import 'package:eco_trans/app/data/models/response/meta_data.dart';

import '../../core/theme/text.dart';
import '../../core/utils/screen.dart';
import '../../core/values/colors.dart';
import '../../data/enums/button_type.dart';
import '../../data/models/form/entity_form.dart';
import '../../data/models/form/item_action.dart';
import '../../global_widgets/atoms/button.dart';
import '../../global_widgets/atoms/icon_with_label.dart';
import '../../global_widgets/atoms/list_view_builder.dart';
import '../atoms/edit_delete_actions.dart';
import '../atoms/header.dart';

class MoleculeBuildList<T> extends StatelessWidget {
  const MoleculeBuildList({
    super.key,
    this.entityName,
    required this.items,
    required this.itemBuilder,
    this.mobileItemBuilder,
    this.form,
    this.onDelete,
    this.header,
    this.selectedItem,
    this.showButtons = true,
    this.canShowDetails = true,
    this.showDetailsAction,
    this.selectItem,
    this.clear,
    this.clearInitValues,
    this.showUpdateModal,
    this.fillControllersForItem,
    this.otherActions = const [],
    this.actionsWidth = 80,
    this.isLoading,
    this.withCloseAlertDialog = false,
    this.isGrouped = true,
    this.search,
    this.crossAxisCount,
    this.maxWidth,
    this.maxHeight,
    this.beforeShowDetails,
    this.widgetButton,
    this.onUpdatePage,
    this.page,
    this.info,
  }) : itemsRx = null;

  const MoleculeBuildList.rx({
    super.key,
    this.entityName,
    required this.itemsRx,
    required this.itemBuilder,
    this.mobileItemBuilder,
    this.form,
    this.onDelete,
    this.header,
    this.selectedItem,
    this.showButtons = true,
    this.canShowDetails = true,
    this.showDetailsAction,
    this.selectItem,
    this.clear,
    this.clearInitValues,
    this.showUpdateModal,
    this.fillControllersForItem,
    this.otherActions = const [],
    this.actionsWidth = 80,
    this.isLoading,
    this.withCloseAlertDialog = false,
    this.isGrouped = true,
    this.search,
    this.crossAxisCount,
    this.maxWidth,
    this.maxHeight,
    this.beforeShowDetails,
    this.widgetButton,
    this.onUpdatePage,
    this.page,
    this.info,
  }) : items = const [];

  final String? entityName;
  final EntityForm<T>? form;
  final List<T> items;
  final RxList<T>? itemsRx;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Future<void> Function(T item)? onDelete;
  final Widget Function(BuildContext context, int index, T item)?
      mobileItemBuilder;
  final List<ItemHeader>? header;
  final double actionsWidth;
  final T? selectedItem;
  final void Function()? clearInitValues;
  final bool canShowDetails;
  final Future<void> Function(T item)? showDetailsAction;
  final bool showButtons;
  final Future<void> Function(T item)? showUpdateModal;
  final void Function(T item)? selectItem;
  final Future<void> Function(T item)? fillControllersForItem;
  final Future<void> Function()? beforeShowDetails;
  final void Function()? clear;
  final List<ItemAction<T>> otherActions;
  final bool withCloseAlertDialog;
  final RxBool? isLoading;
  final Widget? search;
  final int? crossAxisCount;
  final double? maxWidth;
  final double? maxHeight;
  final bool isGrouped;
  final Widget? widgetButton;
  final PageMetaData? page;
  final Future<void> Function(PageMetaData? newPage)? onUpdatePage;
  final Widget? info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widgetContents(context),
        if (info != null) Center(child: info!),
        const SizedBox(height: 16),
        Flexible(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null && !isMobile(context))
                  AtomHeader(
                    headers: header!,
                    actionsWidth: actionsWidth,
                    showButtons: showButtons,
                  ),
                if (header != null && !isMobile(context))
                  const Divider(
                    thickness: 2,
                    color: greyLight,
                  ),
                Flexible(
                  child: Obx(() {
                    return AtomListViewBuilder(
                      items: itemsRx?.value ?? items,
                      isLoading: (isLoading?.value ?? false),
                      itemBuilder: buildItemBuilder,
                    );
                  }),
                ),
                if (page != null)
                  const Divider(
                    thickness: 2,
                    color: primaryColor,
                  ),
                if (page != null)
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed:
                          page!.hasPreviousPage && !(isLoading?.value ?? false)
                              ? () => onUpdatePage?.call(page!.previousPage())
                              : null,
                          icon: const Icon(
                            Icons.navigate_before,
                          ),
                          color: page!.hasPreviousPage && !(isLoading?.value ?? false)
                              ? black
                              : grey,
                        ),
                        CustomText.m(page?.page.toString()),
                        IconButton(
                          onPressed: page!.hasNextPage && !(isLoading?.value ?? false)
                              ? () => onUpdatePage?.call(page?.nextPage())
                              : null,
                          icon: const Icon(
                            Icons.navigate_next,
                          ),
                          color: (page!.hasNextPage && !(isLoading?.value ?? false))
                              ? black
                              : grey,
                        ),
                      ],
                    );
                  })
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildItemBuilder(BuildContext context, int index, T item) {
    return isMobile(context) && mobileItemBuilder != null
        ? mobileItemBuilder!(context, index, item)
        : Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, ),
            child: itemBuilder(
              context,
              index,
              item,
            ),
          ),
        ),
        if (showButtons)
          AtomEditDeleteActions<T>(
            currentItem: item,
            isGrouped: isGrouped,
            onDelete: onDelete == null
                ? null
                : () async {
              await onDelete?.call(item);
              if (withCloseAlertDialog) {
                Get.back();
              }
            },
            otherActions: otherActions
                .where(
                    (element) => element.showIf?.call(item) ?? true)
                .map((e) => ItemAction(
              label: e.label,
              icon: e.icon,
              onPressed: (value) {
                e.onPressed.call(item);
              },
              iconColor: e.iconColor,
              item: item,
            ))
                .toList(),
            clear: clear,
            onEdit: form?.onEdit,
            canShowDetails: canShowDetails,
            onEditShowDialog:
            form?.onEdit == null && showUpdateModal == null
                ? null
                : () {
              if (showUpdateModal != null) {
                showUpdateModal?.call(item);
              } else {
                form?.showAddUpdateModal(
                  isAdd: false,
                  item: item,
                  context: context,
                  maxWidth: maxWidth,
                  crossAxisCount: crossAxisCount,
                  maxHeight: maxHeight ?? 500,
                );
              }
            },
            canShowDetailsDialog: canShowDetails
                ? () =>
            showDetailsAction?.call(item) ??
                form?.showAddUpdateModal(
                  isAdd: false,
                  item: item,
                  isShowDetails: true,
                  context: context,
                  maxHeight: maxHeight ?? 400,
                  maxWidth: maxWidth,
                  crossAxisCount: crossAxisCount,
                )
                : null,
            selectedItem: selectedItem,
            selectItem: selectItem,
            actionsWidth: actionsWidth,
          ),
      ],
    );
  }

  Widget widgetContents(BuildContext context) {
    if (isMobile(context)) {
      return Column(
        children: [
          if (search != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: search!,
              ),
            ),
          Row(
            children: [
              if (form?.onAdd != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:AtomButton(
                    isSmall: true,
                    radius: 16,
                    buttonColor: ButtonColor.second,
                    key: UniqueKey(),
                    onPressed: () => form?.showAddUpdateModal(
                      context: context,
                      crossAxisCount: crossAxisCount,
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                    ),
                    label: form?.title ?? "addNew".tr,
                  ),
                ),
              if (widgetButton != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widgetButton!,
                ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (search != null)
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: search!,
                ),
              ),
            ),
          if (form?.onAdd != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AtomButton(
                isSmall: true,
                radius: 16,
                buttonColor: ButtonColor.second,
                key: UniqueKey(),
                onPressed: () => form?.showAddUpdateModal(
                  context: context,
                  crossAxisCount: crossAxisCount,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                label: form?.title ?? "addNew".tr,
              ),
            ),
          if (widgetButton != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widgetButton!,
            ),
        ],
      );
    }
  }
}

class AtomEditableWidget extends StatelessWidget {
  final Widget editableWidget;
  final String label;
  final String text;
  final bool isShow;
  final bool showInViewPage;
  final Future<void> Function()? onTapInView;

  const AtomEditableWidget({
    super.key,
    required this.label,
    required this.editableWidget,
    required this.text,
    required this.isShow,
    this.showInViewPage = false,
    this.onTapInView,
  });

  @override
  Widget build(BuildContext context) {
    if (isShow) {
      if (text.isEmpty && !showInViewPage) {
        return const SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.l(
                    label,
                    color: greyDark,
                  ),
                  const SizedBox(
                    width: 18,
                    height: 12,
                  ),
                ],
              ),
            ),
            showInViewPage
                ? editableWidget
                : InkWell(
                    onTap: () {
                      if (onTapInView != null) {
                        onTapInView?.call();
                      }
                    },
                    child: onTapInView != null
                        ? AtomIconWithLabel(
                            label: text,
                            icon: Icons.download_for_offline_outlined,
                            iconSize: 20,
                          )
                        : CustomText.m(
                            text,
                          ),
                  ),
            const Divider()
          ],
        ),
      );
    }
    return editableWidget;
  }
}
