import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/data/enums/button_type.dart';
import 'package:rnp_front/app/data/enums/position_type.dart';
import 'package:rnp_front/app/data/enums/zone.dart';
import 'package:rnp_front/app/data/models/entities/subscription_option.dart';
import 'package:rnp_front/app/data/models/item_select.dart';
import 'package:rnp_front/app/global_widgets/atoms/phone_text_field.dart';
import 'package:rnp_front/app/global_widgets/atoms/spinner_progress_indicator.dart';
import 'package:rnp_front/app/global_widgets/organisms/dropdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rnp_front/app/core/utils/form_utils.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/file_picker.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/room_type.dart';
import '../../../data/models/file_info.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isPad = screenSize.width > 768;

    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: AtomSpinnerProgressIndicator())
            : _buildContent(screenSize, isTablet, isPad),
      ),
    );
  }

  Widget _buildContent(Size screenSize, bool isTablet, bool isPad) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/small_icon.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 8),
                _buildHeaderText(),
                const SizedBox(height: 8),
                _buildFormContainer(screenSize, isTablet, isPad),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return CustomText.xl(
      'createAccount'.tr,
      color: black,
      fontWeight: FontWeight.bold,
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .moveY(begin: 10, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildFormContainer(Size screenSize, bool isTablet, bool isPad) {
    return Container(
      width: isPad
          ? screenSize.width * 0.6
          : isTablet
              ? screenSize.width * 0.8
              : double.infinity,
      constraints: BoxConstraints(
        maxWidth: 650,
        minHeight: screenSize.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: controller.key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 16),
            _buildPageTitle(),
            const SizedBox(height: 24),
            _buildMainContent(isTablet),
            _buildButtons(screenSize),
            const SizedBox(height: 8),
            _buildLoginText(),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .moveY(begin: 20, end: 0, curve: Curves.easeOutQuint, duration: 600.ms);
  }

  Widget _buildStepIndicator() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Center(
        child: Obx(() => AnimatedSmoothIndicator(
              activeIndex: controller.currentStep.value,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotColor: Color(0xFFE0E0E0),
                activeDotColor: primaryColor,
                dotHeight: 12,
                dotWidth: 12,
                spacing: 8,
                expansionFactor: 3,
              ),
            )),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Obx(() => CustomText.l(
              controller.currentStep.value == 0
                  ? 'personalInformation'.tr
                  : controller.currentStep.value == 1
                      ? 'organizationInformation'.tr
                      : 'subscriptionInformation'.tr,
              fontWeight: FontWeight.bold,
            ))
        .animate(key: ValueKey(controller.currentStep.value))
        .fadeIn(duration: 300.ms)
        .slideX(
            begin: controller.pageDirection.value, end: 0, duration: 300.ms);
  }

  Widget _buildMainContent(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final inAnimation = Tween<Offset>(
            begin: Offset(controller.pageDirection.value, 0.0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: inAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        layoutBuilder: (currentChild, previousChildren) => currentChild!,
        child: _getPageContent(isTablet),
      ),
    );
  }

  Widget _getPageContent(bool isTablet) {
    switch (controller.currentStep.value) {
      case 0:
        return firstPage(isTablet);
      case 1:
        return secondPage(isTablet);
      case 2:
        return thirdPage();
      case 3:
        return fourthPage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildButtons(Size screenSize) {
    final buttonWidth = screenSize.width > 400 ? 140.0 : 120.0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.currentStep.value > 0)
                AtomButton(
                  label: "previous".tr,
                  isSmall: true,
                  width: buttonWidth,
                  buttonColor: ButtonColor.second,
                  onPressed: _handlePreviousButton,
                ),
              if (controller.currentStep.value > 0) const SizedBox(width: 16),
              AtomButton(
                isSmall: true,
                width: buttonWidth,
                label: controller.currentStep.value == 2
                    ? "register".tr
                    : "next".tr,
                onPressed: _handleNext,
              ),
            ],
          )),
    );
  }

  void _handlePreviousButton() {
    HapticFeedback.mediumImpact();
    controller.pageDirection.value = 1.0; // Right to left motion
    controller.currentStep.value--;
  }

  void _handleNext() {
    HapticFeedback.mediumImpact();

    // If we're at the last step, perform registration
    if (controller.currentStep.value == 3) {
      // Validate fourth page
      if (!FormUtils.validateRequiredFields(
        formKey: controller.key,
        snackbarMessage: 'pleaseFillInAllRequiredFieldsBeforeRegistering'.tr,
      )) {
        // Show animation and set autovalidation mode to trigger on user interaction
        _showValidationError();
        return;
      }

      // Additional validation for room type
      if (controller.selectedRoomType.value == null) {
        Get.snackbar(
          'roomTypeRequired'.tr,
          'pleaseSelectYourPreferredRoomType'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
        );
        _showValidationError();
        return;
      }

      Future.delayed(const Duration(milliseconds: 1500), () {
        controller.register();
      });
    } else {
      // Validate current step fields based on step number
      bool isValid = false;

      if (controller.currentStep.value == 0) {
        // First page - validate form fields
        isValid = FormUtils.validateRequiredFields(
          formKey: controller.key,
          snackbarMessage: 'pleaseFillInAllPersonalInformation'.tr,
        );
      } else if (controller.currentStep.value == 1) {
        // Second page - validate zone and OLM selection
        if (controller.selectedZoneType.value == null) {
          Get.snackbar(
            'zoneSelectionRequired'.tr,
            'pleaseSelectYourZone'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          );
          isValid = false;
        } else if (controller.selectedOlm.value == null) {
          Get.snackbar(
            'olmSelectionRequired'.tr,
            'pleaseSelectYourOlm'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          );
          isValid = false;
        } else {
          isValid = true;
        }
      } else if (controller.currentStep.value == 2) {
        // Third page - validate position and subscription
        if (controller.selectedPositionType.value == null) {
          Get.snackbar(
            'positionSelectionRequired'.tr,
            'pleaseSelectYourPosition'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          );
          isValid = false;
        } else if (controller.selectedPositionType.value ==
                PositionType.OTHER &&
            !FormUtils.validateField(
              controller: controller.otherPositionType,
              fieldName: 'positionDescription'.tr,
            )) {
          isValid = false;
        } else if (controller.selectedSubscriptionOption.value == null) {
          Get.snackbar(
            'subscriptionSelectionRequired'.tr,
            'pleaseSelectYourSubscription'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          );
          isValid = false;
        } else {
          isValid = true;
        }
      }

      if (!isValid) {
        _showValidationError();
        return;
      }

      // Proceed to next step if validation passes
      controller.pageDirection.value = -1.0;
      controller.currentStep.value++;
    }
  }

  // Helper method to show error animation and set fields to autovalidate
  void _showValidationError() {
    controller.errorShake.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.errorShake.value = false;
    });
  }

  Widget _buildLoginText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Get.offAllNamed(Routes.LOGIN);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              text: "alreadyHaveAnAccount".tr,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              children: [
                TextSpan(
                  text: "login".tr,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstPage(bool isWide) {
    return SizedBox(
      key: const ValueKey('page1'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => controller.errorShake.value
                ? _buildInputField(
                    controller.email,
                    "email".tr,
                    Icons.email,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ).animate().shake(duration: 400.ms, hz: 4)
                : _buildInputField(
                    controller.email,
                    "email".tr,
                    Icons.email,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
          ),
          const SizedBox(height: 16),
          AtomPhoneTextField(
            onCountryChanged: (p0) => controller.countryCode = p0,
            controller: controller.phone,
            hintText: "phone".tr,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller.fullName,
            "fullName".tr,
            Icons.person,
          ),
          const SizedBox(height: 16),
          Obx(() => _buildInputField(
                controller.password,
                "password".tr,
                controller.isObscureText.isTrue
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                isObscureText: controller.isObscureText.value,
                validator: _validatePassword,
                onSuffixTap: () => controller.isObscureText.toggle(),
              )),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText.sm(
              'byCreatingAnAccountYouAgreeToOurTermsOfServiceAndPrivacyPolicy'
                  .tr,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) return "Email is required".tr;
    if (!GetUtils.isEmail(value)) {
      return "invalidEmailFormat".tr;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) return "Password is required".tr;
    return null;
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool isObscureText = false,
    String? Function(String?)? validator,
    VoidCallback? onSuffixTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.sm(
          hintText,
          color: Colors.grey.shade700,
        ),
        const SizedBox(height: 8),
        AtomTextField.simple(
          controller: controller,
          hintText: hintText,
          isObscureText: isObscureText,
          autoValidate: AutovalidateMode.onUserInteraction,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return "$hintText is required".tr;
                }
                return null;
              },
          suffix: InkWell(
            onTap: onSuffixTap,
            child: Icon(
              icon,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget secondPage(bool isWide) {
    return SizedBox(
      key: const ValueKey('page2'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildZoneSelection(isWide),
          const SizedBox(height: 20),
          _buildOlmDropdown(),
        ],
      ),
    );
  }

  Widget _buildZoneSelection(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.m('selectYourZone'.tr, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            CustomText.sm('*', color: Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children:
              zoneTypeList.map((zone) => _buildZoneCard(zone, isWide)).toList(),
        ),
      ],
    );
  }

  Widget _buildZoneCard(ZoneType zone, bool isWide) {
    return Obx(() => GestureDetector(
          onTap: () => _selectZone(zone),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isWide ? 150 : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.selectedZoneType.value == zone
                  ? primaryColor.withOpacity(0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: controller.selectedZoneType.value == zone
                    ? primaryColor
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  controller.selectedZoneType.value == zone
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: controller.selectedZoneType.value == zone
                      ? primaryColor
                      : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText.m(
                    zone.name.tr,
                    fontWeight: controller.selectedZoneType.value == zone
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: controller.selectedZoneType.value == zone
                        ? primaryColor
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _selectZone(ZoneType zone) {
    HapticFeedback.lightImpact();
    controller.selectedZoneType.value = zone;
    controller.selectedZoneOlms.value = [];
    for (var item in controller.olms) {
      if (item.olmZoneType == zone) {
        controller.selectedZoneOlms.value.add(item);
      }
    }
  }

  Widget _buildOlmDropdown() {
    return Obx(() => AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SizedBox(width: 4),
                  CustomText.sm('*', color: Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              OrganismDropdown(
                label: 'selectYourOlm'.tr,
                hintText: 'selectYourOlm'.tr,
                withBorder: true,
                simpleInput: true,
                height: 500,
                items: controller.selectedZoneOlms.value
                    .map((e) => ItemSelect(label: e.name, value: e))
                    .toList(),
                onChange: (item) {
                  HapticFeedback.selectionClick();
                  controller.selectedOlm.value = item.value;
                },
              ),
            ],
          ),
        ));
  }

  Widget thirdPage({bool isWide = false}) {
    return SizedBox(
      key: const ValueKey('page3'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('selectYourPosition'.tr,
              'chooseYourRoleInTheOrganization'.tr, Icons.work_rounded),
          const SizedBox(height: 16),
          _buildPositionDropdown(),
          const SizedBox(height: 16),
          _buildOtherPositionField(),
          _buildSectionHeader(
              'selectYourSubscription'.tr, '', Icons.verified_user_rounded),
          const SizedBox(height: 16),
          _buildSubscriptionOptions(isWide),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget fourthPage({bool isWide = false}) {
    return SizedBox(
      key: const ValueKey('page4'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'roommates'.tr,
            'pleaseEnterRoommates'.tr,
            Icons.people_alt_rounded,
            isRequired: false,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller.roommatesController,
            "roommates".tr,
            Icons.person_add_alt_1_rounded,
            keyboardType: TextInputType.text,
            validator: (value) => null,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'roomType'.tr,
            'selectYourPreferredRoomType'.tr,
            Icons.bedroom_parent_outlined,
          ),
          const SizedBox(height: 16),
          _buildRoomTypeOptions(isWide),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRoomTypeOptions(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.m('roomType'.tr, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            CustomText.sm('*', color: Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 16,
          children: roomTypes
              .asMap()
              .entries
              .map((entry) => _buildRoomTypeCard(entry, isWide))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRoomTypeCard(MapEntry<int, RoomType> entry, bool isWide) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.selectedRoomType.value = entry.value;
      },
      child: Obx(() {
        final isSelected = controller.selectedRoomType.value == entry.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isWide ? 240 : double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.08)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText.sm(
                  entry.value.name.tr,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? primaryColor : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText.sm(
                      'select'.tr,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? primaryColor : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: entry.key * 100),
        )
        .moveY(
          begin: 20,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: entry.key * 100),
          curve: Curves.easeOutQuint,
        );
  }

  Widget _buildPositionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.m('selectYourPosition'.tr, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            CustomText.sm('*', color: Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        OrganismDropdown(
          height: 300,
          isSearchable: true,
          simpleInput: true,
          items: positionTypesList
              .map((e) => ItemSelect(label: e.name, value: e))
              .toList(),
          onChange: (item) {
            HapticFeedback.selectionClick();
            controller.selectedPositionType.value = item.value;
          },
        ).animate().fadeIn(duration: 300.ms).moveY(
            begin: 20, end: 0, duration: 300.ms, curve: Curves.easeOutCubic),
      ],
    );
  }

  Widget _buildOtherPositionField() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child:
          Obx(() => controller.selectedPositionType.value == PositionType.OTHER
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller.otherPositionType,
                      "specifyYourPosition".tr,
                      Icons.edit_note_rounded,
                      validator: (p0) =>
                          p0!.isEmpty ? "pleaseSpecifyYourPosition".tr : null,
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .moveY(begin: 10, end: 0, duration: 300.ms),
                    const SizedBox(height: 24),
                  ],
                )
              : const SizedBox(height: 8)),
    );
  }

  Widget _buildSubscriptionOptions(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.m('selectSubscription'.tr, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            CustomText.sm('*', color: Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => controller.subscriptionOptions.value.isEmpty
            ? _buildEmptySubscriptionState()
            : Wrap(
                spacing: 12,
                runSpacing: 16,
                children: controller.subscriptionOptions.value
                    .asMap()
                    .entries
                    .map((entry) => _buildSubscriptionCard(entry, isWide))
                    .toList(),
              )),
      ],
    );
  }

  Widget _buildSubscriptionCard(
      MapEntry<int, SubscriptionOption> entry, bool isWide) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.selectedSubscriptionOption.value = entry.value;
      },
      child: Obx(() {
        final isSelected =
            controller.selectedSubscriptionOption.value == entry.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isWide ? 240 : double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.08)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText.sm(
                  entry.value.subscriptionType.tr,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CustomText.l(
                    '${entry.value.price}',
                    fontWeight: FontWeight.bold,
                    color: isSelected ? primaryColor : Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  CustomText.m('TND',
                      color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child:
                    _buildSubscriptionExplanation(entry.value.subscriptionType),
              ),
              Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? primaryColor : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText.sm(
                      'select'.tr,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? primaryColor : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    )
        .animate()
        .fadeIn(
            duration: 400.ms, delay: Duration(milliseconds: entry.key * 100))
        .moveY(
          begin: 20,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: entry.key * 100),
          curve: Curves.easeOutQuint,
        );
  }

  Widget _buildSubscriptionExplanation(String subscriptionType) {
    String translationKey = '';

    if (subscriptionType == 'Standard') {
      translationKey = 'standardRegistrationExplanation';
    } else if (subscriptionType == 'SD') {
      translationKey = 'saturdaySundayExplanation';
    } else if (subscriptionType == 'VSD') {
      translationKey = 'fridaySaturdaySundayExplanation';
    }

    return CustomText.sm(
      translationKey.tr,
      color: Colors.grey.shade600,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmptySubscriptionState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.subscriptions_outlined,
              size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          CustomText.m('noSubscriptionOptionsAvailable'.tr,
              color: Colors.grey.shade600, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          CustomText.sm('pleaseCheckBackLaterOrContactSupport'.tr,
              color: Colors.grey.shade500, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String description, IconData icon,
      {bool isRequired = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: primaryColor),
            const SizedBox(width: 8),
            CustomText.l(title.tr, fontWeight: FontWeight.bold),
            if (isRequired) ...[
              const SizedBox(width: 4),
              CustomText.sm('*', color: Colors.red),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: CustomText.sm(description.tr, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
