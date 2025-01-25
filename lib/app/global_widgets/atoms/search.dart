import 'dart:async';

import 'package:rnp_front/app/core/values/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/values/colors.dart';

class AtomSearch extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? fillColor;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? clearSearch;
  final double height;
  final TextInputType textInputType;
  final int? maxLines;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool isFuture;
  final double borderRadius;
  Timer? _debounce;

  AtomSearch({
    super.key,
    TextEditingController? controller,
    this.hintText,
    this.fillColor,
    this.onTap,
    this.onChanged,
    this.clearSearch,
    this.height = 50,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.decoration,
    this.style,
    this.borderRadius = 30,
    this.isFuture = true,
  }) : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: black,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: fillColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: textInputType,
                  maxLines: maxLines,
                  onTap: onTap,
                  onChanged: _onSearchChanged,
                  decoration: decoration ??
                      InputDecoration(
                        contentPadding: const EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        hintText: hintText ?? "${"search".tr} ...",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 3.0, right: 12),
                          child: SvgPicture.asset("assets/icons/search.svg",height: 25,),
                        ),
                        suffixIcon: clearSearch == null
                            ? null
                            : IconButton(
                                onPressed: () {
                                  clearSearch?.call();
                                  controller.clear();
                                },
                                icon: const Icon(Icons.close),
                              ),
                      ),
                  style: style ??
                      const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: firstFamily),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (!isFuture) return onChanged?.call(value);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      onChanged?.call(value);
    });
  }
}
