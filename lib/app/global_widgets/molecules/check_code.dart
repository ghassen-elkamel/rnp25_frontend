import 'package:flutter/material.dart';
import '../../core/theme/text.dart';
import '../../core/values/colors.dart';
import '../../data/enums/button_type.dart';
import '../atoms/number_field.dart';
import '../atoms/button.dart';
import 'package:get/get.dart';

class MoleculeCheckCode extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController first;
  final FocusNode firstFocusNode;

  final TextEditingController second;
  final FocusNode secondFocusNode;

  final TextEditingController third;
  final FocusNode thirdFocusNode;

  final TextEditingController fourth;
  final FocusNode fourthFocusNode;

  final TextEditingController fifth;
  final FocusNode fifthFocusNode;

  final TextEditingController sixth;
  final FocusNode sixthFocusNode;
  final RxString errorMsg = "".obs;

  MoleculeCheckCode({
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  })  : formKey = GlobalKey(),
        first = TextEditingController(),
        firstFocusNode = FocusNode(),
        second = TextEditingController(),
        secondFocusNode = FocusNode(),
        third = TextEditingController(),
        thirdFocusNode = FocusNode(),
        fourth = TextEditingController(),
        fourthFocusNode = FocusNode(),
        fifth = TextEditingController(),
        fifthFocusNode = FocusNode(),
        sixth = TextEditingController(),
        sixthFocusNode = FocusNode();

  final String title;
  final String subTitle;
  final Future<bool> Function(String code) onTap;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 62, bottom: 62),
            child: CustomText.xxl(
              title,
              textAlign: TextAlign.center,
              color: secondColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: CustomText.l(
                    subTitle,
                    textAlign: TextAlign.center,
                    color: greyDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 88,
                        ),
                        AtomNumberField(
                          focusNode: firstFocusNode,
                          controller: first,
                          isRequired: true,
                          onChanged: (value) {
                            if (value.length == 1) {
                              secondFocusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AtomNumberField(
                          focusNode: secondFocusNode,
                          controller: second,
                          isRequired: true,
                          onChanged: (value) {
                            if (value.length == 1) {
                              thirdFocusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AtomNumberField(
                          focusNode: thirdFocusNode,
                          controller: third,
                          isRequired: true,
                          onChanged: (value) {
                            if (value.length == 1) {
                              fourthFocusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AtomNumberField(
                          focusNode: fourthFocusNode,
                          controller: fourth,
                          isRequired: true,
                          onChanged: (value) {
                            if (value.length == 1) {
                              fifthFocusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AtomNumberField(
                          focusNode: fifthFocusNode,
                          controller: fifth,
                          isRequired: true,
                          onChanged: (value) {
                            if (value.length == 1) {
                              sixthFocusNode.requestFocus();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        AtomNumberField(
                          focusNode: sixthFocusNode,
                          controller: sixth,
                          isRequired: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8),
                    child: CustomText.m(
                      errorMsg.value,
                      color: darkRed,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AtomButton(
                      label: "check".tr,
                      isSmall: true,
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          String code = first.text +
                              second.text +
                              third.text +
                              fourth.text +
                              fifth.text +
                              sixth.text;
                          bool response = await onTap(code);
                          if (!response) {
                            clear();
                            firstFocusNode.requestFocus();
                          }
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    AtomButton(
                      label: "back".tr,
                      isSmall: true,
                      buttonColor: ButtonColor.greyLight,
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clear() {
    first.text = '';
    second.text = '';
    third.text = '';
    fourth.text = '';
    fifth.text = '';
    sixth.text = '';
  }
}
