import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/values/colors.dart';

class AtomNumberField extends StatefulWidget {
  const AtomNumberField({
    super.key,
    this.inputKey,
    this.controller,
    this.backgroundColor = greyDark,
    this.isUnderlined = true,
    this.borderlineColor = const Color(0xffC9CED4),
    this.validator,
    this.isRequired = true,
    this.onTap,
    this.onChanged,
    this.height = 51,
    this.withOverlayError = false,
    this.prefix,
    this.startHorizontalPosition = 0.0,
    this.decoration,
    this.style,
    this.focusNode,
  });

  final GlobalKey? inputKey;
  final TextEditingController? controller;
  final bool isUnderlined;
  final Color borderlineColor;
  final Color backgroundColor;
  final String? Function(String?)? validator;
  final bool isRequired;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final double height;
  final bool withOverlayError;
  final Widget? prefix;
  final double startHorizontalPosition;
  final InputDecoration? decoration;
  final TextStyle? style;
  final FocusNode? focusNode;

  @override
  _AtomNumberFieldState createState() => _AtomNumberFieldState();
}

class _AtomNumberFieldState extends State<AtomNumberField> {
  late FocusNode myFocusNode;
  late bool isValidData;
  GlobalKey inputKey = GlobalKey();
  late final MouseCursor? mouseCursor;

  @override
  void initState() {
    myFocusNode = widget.focusNode ?? FocusNode();
    mouseCursor = SystemMouseCursors.click;
    if (widget.inputKey != null) {
      inputKey = widget.inputKey!;
    }
    isValidData = true;

    myFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(
            color: widget.borderlineColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: DecoratedBox(
          decoration: isValidData
              ? BoxDecoration(
                  border: (!widget.isUnderlined || !myFocusNode.hasFocus) &&
                          isValidData
                      ? null
                      : Border.all(
                          color: secondColor,
                          width: 1,
                        ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                )
              : BoxDecoration(
                  border: (!widget.isUnderlined || !myFocusNode.hasFocus) &&
                          isValidData
                      ? null
                      : Border.all(
                          color: darkRed,
                          width: 1,
                        ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
          child: Row(
            children: [
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {},
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextFormField(
                      autofocus: true,
                      key: inputKey,
                      mouseCursor: mouseCursor,
                      controller: widget.controller,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onTap: widget.onTap,
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!.call(value);
                        }
                        validate(value);
                      },
                      focusNode: myFocusNode,
                      expands: false,
                      decoration: widget.decoration ??
                          const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            border: InputBorder.none,
                          ),
                      validator: validate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validate(String? value) {
    if (widget.isRequired && value!.trim().isEmpty) {
      isValidData = false;
    } else {
      isValidData = true;
    }
    setState(() {});

    return isValidData ? null : "";
  }
}
