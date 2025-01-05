import 'package:eco_trans/app/core/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/alert.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/check_box.dart';
import '../../../global_widgets/atoms/grid_view.dart';
import '../../../global_widgets/atoms/phone_text_field.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/molecules/build_list.dart';
import '../../../global_widgets/molecules/date_picker.dart';
import '../../../global_widgets/organisms/dropdown.dart';
import 'item_form.dart';

class EntityForm<T> {
  final String? entityName;
  final String? title;
  final IconData icon;
  final List<ItemForm> itemsForm;
  final GlobalKey<FormState> formKey;
  final Future<bool> Function() onAdd;
  final Future<bool> Function(T? item)? onEdit;
  final Widget? errors;
  final bool openInNewPage;
  final Future<void> Function(T item)? fillControllersForItem;
  final Future<void> Function()? beforeShowDetails;

  EntityForm({
    required this.itemsForm,
    required this.onAdd,
    this.onEdit,
    this.fillControllersForItem,
    this.beforeShowDetails,
    this.icon = Icons.add,
    this.title,
    this.entityName,
    this.errors,
    this.openInNewPage = true,
  }) : formKey = GlobalKey();

  EntityForm.observable({
    required this.itemsForm,
    required this.onAdd,
    this.onEdit,
    this.fillControllersForItem,
    this.beforeShowDetails,
    this.icon = Icons.add,
    this.title,
    this.errors,
    this.openInNewPage = true,
  })  : formKey = GlobalKey(),
        entityName = null;

  void clearAddControllers() {
    for (ItemForm element in itemsForm) {
      element.controller.clear();
    }
  }

  Future<void> showAddUpdateModal({
    bool isAdd = true,
    T? item,
    isShowDetails = false,
    int? crossAxisCount,
    double? maxWidth,
    double? maxHeight,
    required BuildContext context,
  }) async {
    if (isAdd) {
      clearAddControllers();
    } else {
      if (fillControllersForItem == null || item == null) {
        throw Exception("fillControllersForItem or item is null");
      }
      await fillControllersForItem!.call(item);
    }

    if (isShowDetails) {
      await beforeShowDetails?.call();
    }
    Alert.showCustomDialog(
      title:
          "${isShowDetails ? "show".tr : isAdd ? "addNew".tr : "update".tr} ${(entityName ?? "").tr}",
      content: SizedBox(
        height: maxHeight ?? Get.height * 0.7,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: AtomGridView(
                    withBuilder: false,
                    crossAxisCount: crossAxisCount ?? 1,
                    children: itemsForm
                        .map(
                          (element) => getItem(
                            element: element,
                            isShowDetails: isShowDetails,
                            isAdd: isAdd,
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (errors != null) errors!,
                if (!isShowDetails) const SizedBox(height: 16),
                if (!isShowDetails)
                  AtomButton(
                    label: "confirm".tr,
                    onPressed: () async {
                      if(formKey.currentState?.validate() ?? false){
                        bool isDone = false;
                        if(isAdd){
                          isDone = await  onAdd.call();
                        }else{
                          isDone = (await onEdit?.call(item)) ?? true;
                        }
                        if(isDone) {
                          Get.back();
                        }
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getItem({
    required ItemForm element,
    required bool isShowDetails,
    required bool isAdd,
  }) {
    switch (element.inputType) {
      case InputType.text:
        return AtomEditableWidget(
          label: element.label,
          key: UniqueKey(),
          isShow: isShowDetails,
          text: element.controller.text,
          onTapInView: element.onTapInView,
          editableWidget: AtomTextField.simple(
            controller: element.controller,
            label: element.label,
            validator: element.validator,
            textInputType: element.textInputType,
            suffix: element.suffix,
            onTap: element.onTap,
            readOnly: element.readOnly,
            isRequired: element.isRequired,
            onChanged: element.onChange,
          ),
        );

      case InputType.date:
        return AtomEditableWidget(
          label: element.label,
          key: UniqueKey(),
          isShow: isShowDetails,
          text: UtilsDate.formatDDMMYYYY(element.initValue),
          onTapInView: element.onTapInView,
          editableWidget: MoleculeDatePicker(
            controller: element.controller,
            label: element.label,
            isRequired: element.isRequired,
            value: element.initValue,
            onSelectDate: (date) => element.onChange?.call(date),
          ),
        );
      case InputType.checkBox:
        return AtomEditableWidget(
          label: element.label,
          key: UniqueKey(),
          isShow: isShowDetails || element.showInViewPage,
          text: element.rxValue?.value ? "yes".tr : "no".tr,
          onTapInView: element.onTapInView,
          editableWidget: Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AtomCheckBox(
                onChanged: element.onChange,
                checkBoxText: element.label,
                value: element.rxValue?.value,
              ),
            );
          }),
        );
      case InputType.select:
        return element.rxItems == null && element.rxValue == null
            ? AtomEditableWidget(
                key: UniqueKey(),
                label: element.label,
                isShow: isShowDetails,
                showInViewPage: element.showInViewPage,
                text: element.initValue?.toString() ?? "",
                onTapInView: element.onTapInView,
                editableWidget: element.child ??
                    OrganismDropdown.entity(
                      controller: element.controller,
                      init: element.initValue,
                      label: element.label,
                      isSearchable: element.isSearchable,
                      onChange: (item) => element.onChange!(item.value),
                      simpleInput: true,
                      isRequired: element.isRequired,
                      objects: element.items,
                    ),
              )
            : Obx(() {
                return AtomEditableWidget(
                  label: element.label,
                  isShow: isShowDetails,
                  key: UniqueKey(),
                  text: element.rxValue?.toString() ??
                      element.initValue ??
                      "",
                  onTapInView: element.onTapInView,
                  editableWidget: OrganismDropdown.entity(
                    controller: element.controller,
                    isRequired: element.isRequired,
                    init: element.initValue ??
                         element.rxValue?.value,
                    isSearchable: element.isSearchable,
                    label: element.label,
                    onChange: (item) => element.onChange!(item.value),
                    simpleInput: true,
                    objects: element.rxItems?.value ?? element.items,
                  ),
                );
              });
      case InputType.phone:
        return AtomEditableWidget(
          label: element.label,
          key: UniqueKey(),
          isShow: isShowDetails,
          text: element.controller.text,
          onTapInView: element.onTapInView,
          editableWidget: AtomPhoneTextField(
            label: "phone".tr,
            controller: element.controller,
            isRequired: element.isRequired,
            onCountryChanged: (countryCode) async {
              element.onChange?.call(countryCode);
            },
          ),
        );
    }
  }
}
