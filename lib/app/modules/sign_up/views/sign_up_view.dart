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

import '../../../core/theme/text.dart';
import '../../../core/utils/file_picker.dart';
import '../../../core/values/colors.dart';
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
      backgroundColor: primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
          ),
        ),
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: AtomSpinnerProgressIndicator())
              : _buildContent(screenSize, isTablet, isPad),
        ),
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
                const SizedBox(height: 16),
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
      color: white,
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
                onPressed: _handleNextButton,
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

  void _handleNextButton() {
    HapticFeedback.mediumImpact();

    if (controller.currentStep.value == 2) {

      Future.delayed(const Duration(milliseconds: 1500), () {
        controller.register();
      });
    } else {
      if (controller.currentStep.value == 0 &&
          !controller.key.currentState!.validate()) {
        controller.errorShake.value = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          controller.errorShake.value = false;
        });
        return;
      }
      controller.pageDirection.value = -1.0;
      controller.currentStep.value++;
    }
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
              text: "alreadyHaveAnAccount? ",
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
              'byCreatingAnAccountYouAgreeToOurTermsOfServiceAndPrivacyPolicy',
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
          validator: validator,
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
          CustomText.m('Select your zone'.tr, color: Colors.grey.shade700),
          const SizedBox(height: 16),
          _buildZoneSelection(isWide),
          const SizedBox(height: 20),
          _buildOlmDropdown(),
        ],
      ),
    );
  }

  Widget _buildZoneSelection(bool isWide) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children:
          zoneTypeList.map((zone) => _buildZoneCard(zone, isWide)).toList(),
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
          child: OrganismDropdown(
            label: 'selectYourOlm',
            hintText: 'selectYourOlm'.tr,
            withBorder: true,
            simpleInput: true,
            isSearchable: true,
            items: controller.selectedZoneOlms.value
                .map((e) => ItemSelect(label: e.name, value: e))
                .toList(),
            onChange: (item) {
              HapticFeedback.selectionClick();
              controller.selectedOlm.value = item.value;
            },
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
          const SizedBox(height: 32),
          _buildSectionHeader(
              'uploadReceipt'.tr,
              'pleaseAttachYourPaymentConfirmation'.tr,
              Icons.receipt_long_rounded),
          const SizedBox(height: 16),
          _buildFileUploadArea(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPositionDropdown() {
    return OrganismDropdown(
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
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .moveY(begin: 20, end: 0, duration: 300.ms, curve: Curves.easeOutCubic);
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
    return Obx(() => controller.subscriptionOptions.value.isEmpty
        ? _buildEmptySubscriptionState()
        : Wrap(
            spacing: 12,
            runSpacing: 16,
            children: controller.subscriptionOptions.value
                .asMap()
                .entries
                .map((entry) => _buildSubscriptionCard(entry, isWide))
                .toList(),
          ));
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
            duration: 400.ms, delay: Duration(milliseconds: entry.key * 100))
        .moveY(
          begin: 20,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: entry.key * 100),
          curve: Curves.easeOutQuint,
        );
  }

  Widget _buildFileUploadArea() {
    return Obx(() => controller.selectedImage.value != null
        ? _buildFilePreview(controller.selectedImage.value!)
        : _buildAttachmentButton());
  }

  Widget _buildSectionHeader(String title, String description, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: primaryColor),
            const SizedBox(width: 8),
            CustomText.l(title.tr, fontWeight: FontWeight.bold),
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
          CustomText.m('NoSubscriptionOptionsAvailable',
              color: Colors.grey.shade600, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          CustomText.sm('pleaseCheckBackLaterOrContactSupport',
              color: Colors.grey.shade500, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: InkWell(
          onTap: _selectFile,
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined,
                  size: 48, color: primaryColor.withOpacity(0.7)),
              const SizedBox(height: 12),
              CustomText.m('uploadReceipt'.tr,
                  color: primaryColor, fontWeight: FontWeight.w600),
              const SizedBox(height: 8),
              CustomText.sm('Click to browse or drop files here'.tr,
                  color: Colors.grey.shade600),
              const SizedBox(height: 8),
              CustomText.xs('Support: JPEG, PNG, PDF (Max: 5MB)'.tr,
                  color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .scale(duration: 400.ms, delay: 200.ms);
  }

  Future<void> _selectFile() async {
    Rx<FileInfo?> selectedImage = Rx<FileInfo?>(null);
    selectedImage.value =
        await CustomFilePicker.showPicker(context: Get.context!);

    if (selectedImage.value != null) {
      HapticFeedback.mediumImpact();
      controller.selectedImage.value = selectedImage.value;
    }
  }

  Widget _buildFilePreview(FileInfo file) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.insert_drive_file_rounded,
                color: primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.m(
                  file.fileName,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText.sm('receiptDocument'.tr,
                    color: Colors.grey.shade600),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              controller.selectedImage.value = null;
            },
            icon:
                Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }
}
