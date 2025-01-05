import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/text_theme.dart';
import '../../core/values/colors.dart';
import '../../data/models/item_select.dart';
import '../../global_widgets/atoms/text_field.dart';
import '../../global_widgets/molecules/dropdown_content.dart';
import '../atoms/image.dart';


class OrganismDropdown<T> extends StatefulWidget {
  OrganismDropdown({
    super.key,
    ItemSelect<T>? initValue,
    required this.items,
    this.rxItems,
    this.hintText = "",
    this.isRequired = true,
    this.withBorder = true,
    this.underlineColor = Colors.grey,
    this.backgroundColor,
    this.label,
    this.padding = 10,
    this.onClear,
    this.onChange,
    this.height = 200,
    this.isSearchable = false,
    this.simpleInput = false,
    this.labelOnNull = "unknown",
  })
      : onChangeSelectedItems = null,
        isMultiselect = false,
        controller = TextEditingController(),
        initValue = initValue == null
            ? null
            : [ initValue
        ];



  OrganismDropdown.multiselect({
    super.key,
    TextEditingController? controller,
    List<T>? init,
    required List<T> objects,
    this.hintText = "",
    this.isRequired = true,
    this.withBorder = true,
    this.onClear,
    this.underlineColor = Colors.grey,
    this.backgroundColor,
    this.label,
    this.padding = 0,
    this.onChangeSelectedItems,
    this.height = 200,
    this.isSearchable = true,
    this.simpleInput = true,
    this.labelOnNull = "unknown",
  })
      : onChange = null,
        rxItems = null,
        isMultiselect = true,
        controller = controller ?? TextEditingController(),
        items = objects
            .map((e) =>
            ItemSelect<T>(
                label: e?.toString() ?? labelOnNull
                    .toString()
                    .tr, value: e))
            .toList(),
        initValue = init?.map((e) =>
            ItemSelect<T>(
              label: e.toString(),
              value: e,
            )).whereType<ItemSelect<T>>().toList();

  OrganismDropdown.entity({
    super.key,
    TextEditingController? controller,
    T? init,
    required List<T> objects,
    this.hintText = "",
    this.isRequired = true,
    this.withBorder = true,
    this.underlineColor = Colors.grey,
    this.backgroundColor,
    this.label,
    this.padding = 0,
    this.onChange,
    this.height = 200,
    this.isSearchable = false,
    this.simpleInput = true,
    this.isMultiselect = false,
    this.onClear,
    this.rxItems,
    this.labelOnNull = "unknown",
  })
      : controller = controller ?? TextEditingController(),
        onChangeSelectedItems = null,
        items = objects
            .map((e) =>
            ItemSelect<T>(
                label: e?.toString() ?? labelOnNull
                    .toString()
                    .tr, value: e))
            .toList(),
        initValue = init == null
            ? null
            : [ ItemSelect(
          label: init.toString(),
          value: init,
        )
        ];

  final List<ItemSelect<T>>? initValue;
  final bool isMultiselect;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final bool withBorder;
  final Color underlineColor;
  final Color? backgroundColor;
  final String? label;
  final List<ItemSelect<T>> items;
  final RxList<ItemSelect<T>>? rxItems;
  final double padding;
  final void Function(ItemSelect item)? onChange;
  final void Function(List<T> items)? onChangeSelectedItems;
  final bool isSearchable;
  final double height;
  final bool simpleInput;
  final String labelOnNull;
  final void Function()? onClear;

  @override
  State<OrganismDropdown> createState() => _OrganismDropdownState<T>();
}

class _OrganismDropdownState<T> extends State<OrganismDropdown<T>> {
  late GlobalKey key;
  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;
  bool _isVisible = false;
  ItemSelect<T>? value;
  List<ItemSelect<T>> values = [];
  List<ItemSelect<T>> items = [];
  late LayerLink layerLink;

  @override
  void initState() {
    key = GlobalKey();
    layerLink = LayerLink();
    if (widget.initValue  case List<ItemSelect<T>> initValue) {
      if (widget.isMultiselect) {
        values.addAll(initValue);
        widget.controller.text = values.map((e) => e.label).join(", ");
      } else {
        value = initValue.firstOrNull;
        widget.controller.text = value?.label ?? "";
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items = widget.items.whereType<ItemSelect<T>>().toList();
    Icon arrowIcon = Icon(
      _isVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      color: black,
      size: widget.withBorder ? 16 : 30,
    );
    return WillPopScope(
      onWillPop: () {
        if (_isVisible) {
          closeOverlay();
        }
        return Future.value(true);
      },
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CompositedTransformTarget(
                link: layerLink,
                child: widget.simpleInput
                    ? AtomTextField.simple(
                  inputKey: key,
                  backgroundColor: widget.backgroundColor ?? greyDark,
                  controller: widget.controller,
                  label: widget.label,
                  padding: widget.padding,
                  readOnly: true,
                  suffix: arrowIcon,
                  isRequired: widget.isRequired,
                  prefix: value?.pathPicture == null
                      ? null
                      : Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 18.0),
                    child: AtomImage(
                      path: value!.pathPicture!,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  onTap: () {
                    if (!_isVisible) {
                      _isVisible = true;
                      _overlayEntry = _createOverlayEntry();
                      _overlayState = Overlay.of(context);
                      _overlayState!.insert(_overlayEntry!);
                    } else {
                      closeOverlay();
                    }
                  },
                )
                    : AtomTextField(
                  inputKey: key,
                  controller: widget.controller,
                  label: widget.label,
                  readOnly: true,
                  isRequired: widget.isRequired,
                  contentCanBeSpace: true,
                  backgroundColor: widget.backgroundColor ?? greyDark,
                  withBorder: false,
                  hintText: widget.hintText,
                  prefix: value?.pathPicture == null
                      ? null
                      : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AtomImage(
                      path: value!.pathPicture!,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    suffixIcon: arrowIcon,
                    border: InputBorder.none,
                    errorStyle: styleTransparentColor,
                    errorText: "",
                    errorMaxLines: 1,
                    contentPadding: const EdgeInsets.only(
                        left: 12, bottom: 0, top: 16),
                  ),
                  style: styleBlackLightFontRobotoW400Size16,
                  onTap: () {
                    if (!_isVisible) {
                      _isVisible = true;
                      _overlayEntry = _createOverlayEntry();
                      _overlayState = Overlay.of(context);
                      _overlayState!.insert(_overlayEntry!);
                    } else {
                      closeOverlay();
                    }
                  },
                ),
              ),
            ),
          ),
          if (value != null && widget.onClear != null)
            InkWell(
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 26,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: black,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.controller.clear();
                  widget.onClear?.call();
                  value = null;
                });
              },
            ),
        ],
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    bool openOnDown =
        position.dy + widget.height < MediaQuery
            .of(context)
            .size
            .height;

    double startPosition = widget.label == null ? 0 : 36;
    if (openOnDown) {
      startPosition += box.size.height;
    }
    return OverlayEntry(
      builder: (context) {
        return FittedBox(
          fit: BoxFit.fill,
          child: InkWell(
            onTap: () => closeOverlay(),
            child: CompositedTransformFollower(
              link: layerLink,
              followerAnchor:
              openOnDown ? Alignment.topLeft : Alignment.bottomLeft,
              offset: Offset(
                -4,
                startPosition,
              ),
              child: FittedBox(
                fit: BoxFit.none,
                child: SizedBox(
                  height: widget.height,
                  width: box.size.width + 8,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: secondColor.withOpacity(0.4)),
                    ),
                    child: StatefulBuilder(
                        builder: (context, setStateDropdownContent) {
                          return widget.rxItems != null
                              ? Obx(() {
                            return MoleculeDropdownContent<T>(
                              onTap: (item) =>
                                  onTapDropDown(
                                      item, setStateDropdownContent),
                              onSearch: widget.isSearchable ? onSearch : null,
                              items: widget.rxItems!.value.whereType<
                                  ItemSelect<T>>().toList(),
                              selectedItem: value,
                              selectedItems: values,
                            );
                          })
                              : MoleculeDropdownContent<T>(
                            onTap: (item) =>
                                onTapDropDown(item, setStateDropdownContent),
                            onSearch: widget.isSearchable ? onSearch : null,
                            items: items,
                            selectedItem: value,
                            selectedItems: values,
                          );
                        }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  onTapDropDown(ItemSelect<T> item, setStateDropdownContent) {
    value = item;
    if (widget.isMultiselect) {
      setStateDropdownContent(() {
        if (values.map((e) => e.value).contains(item.value)) {
          values.removeWhere((element) => element.value == item.value);
          value = null;
        } else {
          values.add(item);
        }
      });
      widget.controller.text = values.map((e) => e.label).join(", ");
      widget.onChangeSelectedItems?.call(
          values.map((e) => e.value).whereType<T>().toList());
    } else {
      widget.controller.text = value?.label ?? "";
      widget.onChange?.call(item);
      closeOverlay();
    }
  }

  void closeOverlay() {
    items = widget.items.whereType<ItemSelect<T>>().toList();
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _isVisible = false;
  }

  void onSearch(value) {
    items = widget.items
        .where((element) =>
        element.label
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
        .whereType<ItemSelect<T>>()
        .toList();
    _overlayEntry!.markNeedsBuild();
  }

  @override
  void dispose() {
    closeOverlay();
    super.dispose();
  }
}
