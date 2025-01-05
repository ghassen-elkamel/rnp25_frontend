import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum InputType { text, select, phone, checkBox, date }

class ItemForm<T> {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final Rx<T>? rxValue;
  final RxList<T>? rxItems;
  final bool readOnly;
  final void Function()? onTap;
  final InputType inputType;
  final List<T> items;
  final Widget? child;
  final Widget? suffix;
  final TextInputType textInputType;
  final void Function(T newItem)? onChange;
  final String? Function(String? value)? validator;
  final T? initValue;
  final bool onlyForAdd;
  final bool showInViewPage;
  final bool isSearchable;
  final Future<void> Function()? onTapInView;
  final void Function()? onClear;

  ItemForm({
    required this.label,
    required this.controller,
    this.validator,
    this.suffix,
    this.onTap,
    this.textInputType = TextInputType.text,
    this.onlyForAdd = false,
    this.isRequired = true,
    this.readOnly = false,
    this.onChange,
    this.onTapInView,
    this.onClear,
  })  : inputType = InputType.text,
        items = [],
        rxValue = null,
        child = null,
        initValue = null,
        rxItems = null,
        showInViewPage = false,
        isSearchable = true;

  ItemForm.select({
    required this.label,
    required this.items,
    TextEditingController? controller,
    required this.onChange,
    this.validator,
    this.textInputType = TextInputType.text,
    this.initValue,
    this.onTapInView,
    this.onlyForAdd = false,
    this.isSearchable = true,
    this.readOnly = false,
    this.isRequired = true,
    this.onClear,
  })  : inputType = InputType.select,
        child = null,
        controller = controller ?? TextEditingController(),
        suffix = null,
        rxValue = null,
        rxItems = null,
        showInViewPage = false,
        onTap = null;

  ItemForm.rxSelect({
    required this.label,
    TextEditingController? controller,
    this.rxItems,
    this.rxValue,
    required this.onChange,
    this.onClear,
    this.validator,
    this.textInputType = TextInputType.text,
    this.onlyForAdd = false,
    this.isSearchable = true,
    this.readOnly = false,
    this.isRequired = true,
    this.onTapInView,
  })  : inputType = InputType.select,
        controller = controller ?? TextEditingController(),
        child = null,
        suffix = null,
        items = const [],
        initValue = null,
        showInViewPage = false,
        onTap = null;

  ItemForm.phone({
    required this.controller,
    required this.label,
    required onChangeCountryCode,
    this.initValue,

    this.validator,
    this.textInputType = TextInputType.phone,
    this.isRequired = true,
    this.readOnly = false,
    this.onTapInView,
    this.onlyForAdd = false,
    this.showInViewPage = true,
    this.onClear,
  })  : inputType = InputType.phone,
        onChange = onChangeCountryCode,
        isSearchable = false,
        items = [],
        onTap = null,
        rxValue = null,
        rxItems = null,
        suffix = null,
        child = null;

  ItemForm.checkbox({
    required this.label,
    required this.onChange,
    required this.rxValue,
    this.onClear,
    this.textInputType = TextInputType.text,
    this.onlyForAdd = false,
    this.isRequired = true,
    this.readOnly = false,
    this.onTapInView,
  })  : inputType = InputType.checkBox,
        initValue = null,
        controller = TextEditingController(),
        validator = null,
        suffix = null,
        onTap = null,
        rxItems = null,
        child = null,
        isSearchable = false,
        showInViewPage = false,
        items = [];

  ItemForm.date({
    required this.label,
    required this.onChange,
    this.initValue,
    TextEditingController? controller,
    this.onClear,
    this.onlyForAdd = false,
    this.isRequired = true,
    this.onTapInView,
  })  : inputType = InputType.date,
        validator = null,
        controller = controller ?? TextEditingController(),
        suffix = null,
        onTap = null,
        textInputType = TextInputType.text,
        rxItems = null,
        child = null,
        isSearchable = false,
        readOnly = true,
        showInViewPage = false,
        rxValue = null,
        items = [];



}
