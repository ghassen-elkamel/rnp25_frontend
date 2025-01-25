import 'package:rnp_front/app/core/values/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:rnp_front/app/core/utils/language_helper.dart';
import '../../core/theme/text.dart';
import '../../core/values/colors.dart';

class AtomPhoneTextField extends StatefulWidget {
  const AtomPhoneTextField({
    super.key,
    this.controller,
    this.backgroundColor = Colors.transparent,
    this.isUnderlined = true,
    this.readOnly = false,
    this.height = 51,
    this.hintText,
    this.label,
    this.validator,
    this.isRequired = true,
    this.onChanged,
    this.onCountryChanged,
    this.textInputType = TextInputType.number,
    this.maxLines = 1,
    this.withOverlayError = false,
    this.prefix,
    this.startHorizontalPosition = 0.0,
    this.decoration,
    this.style,
    this.autofocus= false,
    this.initialCountryCode,
  });

  final TextEditingController? controller;
  final bool readOnly;
  final bool isUnderlined;
  final Color backgroundColor;
  final double height;
  final void Function(String)? onCountryChanged;
  final String? hintText;
  final String? label;
  final String? Function(String?)? validator;
  final bool isRequired;
  final void Function(PhoneNumber)? onChanged;
  final TextInputType textInputType;
  final int? maxLines;
  final bool withOverlayError;
  final Widget? prefix;
  final double startHorizontalPosition;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool autofocus;
  final String? initialCountryCode;

  @override
  _AtomPhoneTextFieldState createState() => _AtomPhoneTextFieldState();
}

class _AtomPhoneTextFieldState extends State<AtomPhoneTextField> {
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
    layerLink = LayerLink();
    isValidData = true;
    errorMsg = null;
    myFocusNode.addListener(() {
      setState(() {});
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
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                key: inputKey,
                autofocus: widget.autofocus,
                controller: widget.controller,
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                initialCountryCode: widget.initialCountryCode ?? 'TN',
                readOnly: widget.readOnly,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: widget.decoration ??
                    InputDecoration(
                      hintText: widget.hintText,hintTextDirection: TextDirection.rtl,
                      suffixIcon: isValidData
                          ? const SizedBox()
                          : const Icon(
                        Icons.error_outline,
                        color: darkRed,
                      ),
                      hintStyle: const TextStyle(
                        color: greyDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: firstFamily,
                      ),
                      filled: true,
                      fillColor: widget.backgroundColor,
                      labelStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.only(left: 12, right: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: errorMsg != null ? darkRed : primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                validator: validate,
                invalidNumberMessage: "thisPhoneNumberNotValid".tr,
                languageCode: LanguageHelper.language ?? "ar",
                onCountryChanged: (value) {
                  widget.onCountryChanged?.call(value.dialCode);
                },
                onChanged: widget.onChanged,
                showDropdownIcon: false,
              ),
            ),
            if (errorMsg != null && !widget.withOverlayError)
              Padding(
                padding: const EdgeInsets.all(8),
                child: CustomText.m(
                  errorMsg ?? "",
                  color: darkRed,
                ),
              )
          ],
        ),
      ],
    );
  }

  String? validate(PhoneNumber? value) {
    String? oldMsg = errorMsg;
    if (widget.isRequired && value!.number.trim().isEmpty) {
      errorMsg = "${"the-field".tr} ${widget.label ?? widget.hintText} ${"is-required".tr}";
    } else {
      errorMsg = null;
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
    return isValidData ? null : errorMsg;
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CustomText.m(
                            errorMsg ?? "",
                            color: darkRed,
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
}
