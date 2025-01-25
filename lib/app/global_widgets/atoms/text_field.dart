import 'package:rnp_front/app/core/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/theme/text.dart';
import '../../core/theme/text_theme.dart';
import '../../core/values/colors.dart';
import '../../core/values/font_family.dart';

class AtomTextField extends StatefulWidget {
  const AtomTextField({
    super.key,
    this.inputKey,
    this.labelSuffix,
    this.controller,
    this.autofocus = false,
    this.isAmount = false,
    this.backgroundColor = greyLight,
    this.borderRadius = 8,
    this.isObscureText = false,
    this.isUnderlined = true,
    this.readOnly = false,
    this.withBorder = true,
    this.padding = 0,
    this.hintText,
    this.validator,
    this.isRequired = true,
    this.onTap,
    this.onChanged,
    this.height = 51,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.withOverlayError = false,
    this.prefix,
    this.suffix,
    this.startHorizontalPosition = 0.0,
    this.showPropertyName = true,
    this.decoration,
    this.style,
    this.icon,
    this.contentCanBeSpace = false,
    this.selectTextOnFocus = true,
    this.label,
    this.onSubmitted,
  }) : simple = false;

  const AtomTextField.simple({
    super.key,
    this.inputKey,
    this.labelSuffix,
    this.controller,
    this.autofocus = false,
    this.isAmount = false,
    this.backgroundColor = greyDark,
    this.borderRadius = 8,
    this.isObscureText = false,
    this.isUnderlined = true,
    this.readOnly = false,
    this.withBorder = true,
    this.padding = 0,
    this.hintText,
    this.validator,
    this.isRequired = true,
    this.onTap,
    this.onChanged,
    this.height = 51,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.withOverlayError = false,
    this.prefix,
    this.suffix,
    this.startHorizontalPosition = 0.0,
    this.showPropertyName = true,
    this.decoration,
    this.style,
    this.icon,
    this.contentCanBeSpace = false,
    this.selectTextOnFocus = true,
    this.label,
    this.onSubmitted,
  }) : simple = true;

  final GlobalKey? inputKey;
  final TextEditingController? controller;
  final Widget? labelSuffix;
  final bool autofocus;
  final bool isAmount;
  final bool isObscureText;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final bool isUnderlined;
  final bool withBorder;
  final Color backgroundColor;
  final double borderRadius;
  final String? hintText;
  final String? label;
  final double padding;
  final String? Function(String?)? validator;
  final bool isRequired;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final double height;
  final TextInputType textInputType;
  final int? maxLines;
  final bool withOverlayError;
  final Widget? prefix;
  final Widget? suffix;
  final double startHorizontalPosition;
  final bool showPropertyName;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Icon? icon;
  final bool contentCanBeSpace;
  final bool simple;
  final bool selectTextOnFocus;
  final void Function(String value)? onSubmitted;

  @override
  _AtomTextFieldState createState() => _AtomTextFieldState();
}

class _AtomTextFieldState extends State<AtomTextField> {
  FocusNode myFocusNode = FocusNode();
  late bool isValidData;
  late String? errorMsg;
  late LayerLink layerLink;
  GlobalKey inputKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;
  late final MouseCursor? mouseCursor;

  @override
  void initState() {
    mouseCursor = widget.readOnly ? SystemMouseCursors.click : null;
    if (widget.inputKey != null) {
      inputKey = widget.inputKey!;
    }
    layerLink = LayerLink();
    isValidData = true;
    errorMsg = null;
    myFocusNode.addListener(() {
      if (widget.selectTextOnFocus) {
        setState(() {
          widget.controller?.selection = TextSelection(
            baseOffset: 0,
            extentOffset: widget.controller?.text.length ?? 0,
          );
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    closeOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomText.l(
                  widget.label.toString(),
                  color: greyDark,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  "*",
                  style: TextStyle(
                    color: red,
                    height: 1,
                    letterSpacing: 8,
                  ),
                ),
              if (widget.labelSuffix != null) widget.labelSuffix!
            ],
          ),
        getInput(),
        if (errorMsg != null && !widget.withOverlayError)
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomText.m(
              errorMsg ?? "",
              color: darkRed,
            ),
          )
      ],
    );
  }

  String? validate(String? value) {
    String? oldMsg = errorMsg;
    if (!widget.contentCanBeSpace) {
      value = value?.trim();
    }
    if (widget.isRequired && value!.isEmpty) {
      String fieldName = widget.label ?? widget.hintText ?? "";
      errorMsg = widget.showPropertyName
          ? "the-field".tr + fieldName.toLowerCase() + "is-required".tr
          : "this-field".tr + "is-required".tr;
    } else {
      errorMsg = null;
    }
    if (widget.isAmount) {
      errorMsg ??= FormValidator().validateDouble(
        value,
        isRequired: widget.isRequired,
      );
    }
    if (errorMsg == null && widget.validator != null) {
      errorMsg = widget.validator!(value);
    }

    if (errorMsg == null) {
      isValidData = true;
    } else {
      isValidData = false;
    }

    if (widget.withOverlayError) {
      if (myFocusNode.hasFocus) {
        initOverlay(context);
      } else {
        closeOverlay();
      }
    }

    if (oldMsg != errorMsg) {
      setState(() {});
    }
    return isValidData ? null : "";
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => isValidData
          ? const SizedBox()
          : FittedBox(
              fit: BoxFit.cover,
              child: CompositedTransformFollower(
                link: layerLink,
                offset: Offset(widget.startHorizontalPosition, 55),
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Material(
                    color: Colors.transparent,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: red, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CustomText.m(
                            errorMsg ?? "",
                            color: white,
                          ),
                        )),
                  ),
                ),
              ),
            ),
    );
  }

  void initOverlay(context) {
    closeOverlay();
    _overlayEntry = _createOverlayEntry();
    _overlayState = Overlay.of(context!);
    _overlayState!.insert(_overlayEntry!);
  }

  void closeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  Widget simpleTextField() {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey.shade50),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder focusBorderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey.shade100),
      borderRadius: BorderRadius.circular(8),
    );
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextFormField(
        key: inputKey,
        mouseCursor: mouseCursor,
        cursorColor: primaryColor,
        onFieldSubmitted: widget.onSubmitted,
        controller: widget.controller,
        autofocus: widget.autofocus,
        textDirection: widget.isAmount ? TextDirection.ltr : null,
        inputFormatters:
            widget.isAmount ? [ThousandSeparatorInputFormatter()] : null,
        keyboardType: widget.isAmount
            ? const TextInputType.numberWithOptions(decimal: true)
            : widget.textInputType,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        autovalidateMode: AutovalidateMode.disabled,
        onTap: widget.onTap,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(value);
          }
        },
        focusNode: myFocusNode,
        expands: widget.maxLines == null ? true : false,
        decoration: widget.decoration ??
            InputDecoration(
              hintText: widget.hintText,
              suffixIcon: isValidData
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.suffix,
                    )
                  : const Icon(
                      Icons.error_outline,
                      color: darkRed,
                    ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 25,
              ),
              prefixIcon: widget.prefix ?? widget.icon,
              hintStyle: const TextStyle(
                color: greyDark,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: firstFamily,
              ),
              errorStyle: styleTransparentColor,
              errorText: null,
              errorMaxLines: 1,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding:
                  const EdgeInsets.only(left: 12, right: 12, top: 12),
              enabledBorder: borderStyle,
              focusedBorder: focusBorderStyle,
              errorBorder: borderStyle,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorMsg != null ? darkRed : primaryColor),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
        validator: validate,
        obscureText: widget.isObscureText,
        style: widget.style ??
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: firstFamily,
            ),
      ),
    );
  }

  Widget getInput() {
    Widget input = SizedBox(
      height: widget.height,
      child: widget.simple
          ? simpleTextField()
          : DecoratedBox(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(
                  color: greyDark,
                  width: 1,
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius)),
              ),
              child: DecoratedBox(
                decoration: isValidData
                    ? BoxDecoration(
                        border:
                            (!widget.isUnderlined || !myFocusNode.hasFocus) &&
                                    isValidData
                                ? null
                                : Border.all(
                                    color: secondColor,
                                    width: 1,
                                  ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                      )
                    : BoxDecoration(
                        border:
                            (!widget.isUnderlined || !myFocusNode.hasFocus) &&
                                    isValidData
                                ? null
                                : Border.all(
                                    color: darkRed,
                                    width: 1,
                                  ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                child: Row(
                  key: inputKey,
                  children: [
                    if (widget.prefix != null) widget.prefix!,
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (widget.withOverlayError) {
                            if (hasFocus) {
                              initOverlay(context);
                            } else {
                              closeOverlay();
                            }
                          }
                        },
                        child: CompositedTransformTarget(
                          link: layerLink,
                          child: TextFormField(
                            mouseCursor: mouseCursor,
                            controller: widget.controller,
                            onFieldSubmitted: widget.onSubmitted,
                            autofocus: widget.autofocus,
                            textDirection:
                                widget.isAmount ? TextDirection.ltr : null,
                            inputFormatters: widget.isAmount
                                ? [ThousandSeparatorInputFormatter()]
                                : null,
                            keyboardType: widget.isAmount
                                ? const TextInputType.numberWithOptions(
                                    decimal: true)
                                : widget.textInputType,
                            readOnly: widget.readOnly,
                            maxLines: widget.maxLines,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.disabled,
                            onTap: widget.onTap,
                            onChanged: (value) {
                              if (widget.onChanged != null) {
                                widget.onChanged!.call(value);
                              }
                            },
                            focusNode: myFocusNode,
                            expands: widget.maxLines == null ? true : false,
                            decoration: widget.decoration ??
                                InputDecoration(
                                    contentPadding: const EdgeInsets.all(12.0),
                                    border: InputBorder.none,
                                    hintText: widget.hintText,
                                    suffixIcon: isValidData
                                        ? null
                                        : const Icon(
                                            Icons.error_outline,
                                            color: darkRed,
                                          ),
                                    prefixIcon: widget.icon,
                                    hintStyle: const TextStyle(
                                      color: greyDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: firstFamily,
                                    ),
                                    errorStyle: styleTransparentColor,
                                    errorText: "",
                                    errorMaxLines: 1),
                            validator: validate,
                            obscureText: widget.isObscureText,
                            style: widget.style ??
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: firstFamily,
                                ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.suffix != null) widget.suffix!,
                  ],
                ),
              ),
            ),
    );

    return input;
  }
}

class ThousandSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^\d.,]'), '');

    List<String> parts = newText.split(RegExp(r'[.,]'));
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    String formattedInteger = '';
    for (int i = integerPart.length; i > 0; i--) {
      if ((integerPart.length - i) % 3 == 0 && i != integerPart.length) {
        formattedInteger = ' $formattedInteger';
      }
      formattedInteger = integerPart[i - 1] + formattedInteger;
    }
    String formattedText = decimalPart != null
        ? '$formattedInteger.${decimalPart.substring(0, decimalPart.length)}'
        : formattedInteger;

    int selectionIndex = newValue.selection.end;

    selectionIndex =
        formattedText.length - (newValue.text.length - selectionIndex);

    if (selectionIndex > formattedText.length) {
      selectionIndex = formattedText.length;
    } else if (selectionIndex < 0) {
      selectionIndex = 0;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
