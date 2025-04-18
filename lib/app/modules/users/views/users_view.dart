import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:rnp_front/app/core/extensions/string/language.dart';
import 'package:rnp_front/app/core/utils/constant.dart';
import 'package:rnp_front/app/data/models/form/entity_form.dart';
import 'package:rnp_front/app/data/models/form/item_action.dart';
import 'package:rnp_front/app/data/models/item_header.dart';
import 'package:rnp_front/app/data/providers/external/api_provider.dart';
import 'package:rnp_front/app/data/providers/external/src/api_provider_helper.dart';
import 'package:rnp_front/app/global_widgets/atoms/safe_image_network.dart';
import 'package:rnp_front/app/global_widgets/atoms/search.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../core/utils/date.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/role_type.dart';
import '../../../data/models/entities/subscription_form.dart';
import '../../../data/models/entities/user.dart';
import '../../../data/models/form/item_form.dart';
import '../../../data/services/auth_service.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/label_with_icon.dart';
import '../../../global_widgets/atoms/list_view_builder.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/molecules/build_list.dart';
import '../../../global_widgets/molecules/editable_text.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../../../routes/app_pages.dart';
import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  final bool isAdd;

  const UsersView({super.key, this.isAdd = false});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'users'.tr,
      selectedIndex: 3,
      padding: const EdgeInsets.all(16.0),
      withMenu: true,
      withCloseIcon: Navigator.canPop(context),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: AtomListViewBuilder(
              items: AuthService.getMyRolesFilter(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index, action) {
                return buildAction(action);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return MoleculeBuildList<User>.rx(
                form: entityForm(),
                itemsRx: controller.users,
                isLoading: controller.isLoading,
                actionsWidth: 40,
                header: [
                  ItemHeader(
                    "#",
                    onChangeOrder: (order) {
                      controller.orderByCode(order);
                    },
                  ),
                  ItemHeader(
                    "fullName".tr,
                    onChangeOrder: (order) {
                      controller.orderByFullName(order);
                    },
                  ),
                  ItemHeader(
                    "email".tr,
                  ),
                  ItemHeader("phone".tr),
                ],
                onDelete: (item) async {
                  controller.deleteAccount(item);
                },
                showDetailsAction: (item) async {
                  Get.toNamed(Routes.WALLET,
                      parameters: {"userId": item.id.toString()});
                },
                otherActions: [
                  ItemAction(
                    label: "password".tr,
                    icon: Icons.password,
                    onPressed: (User item) {
                      showUpdatePassword(item);
                    },
                  ),
                ],
                search: AtomSearch(
                  controller: controller.search,
                  onChanged: (value) => controller.searchItems(),
                  fillColor: white,
                  borderRadius: 20,
                ),
                itemBuilder: (context, index, item) {
                  return InkWell(
                    onTap: () {
                      UserDetailsDialog.show(
                        entity:
                            controller.selectedRole.value == RolesType.client
                                ? item.subscirptionForm
                                : item,
                        onActivate: (p0) {
                          controller.onActivate(item);
                        },
                        onBlock: (p0) {
                          controller.onBlock(item);
                        },
                        onDownloadPdf: () async {
                          // Try both possible backend endpoint paths
                          var receiptUrl =
                              '$hostPath$apiPrefix/v1/subscription-form/receipt/${item.subscirptionForm?.id}';

                          try {
                            // Create the URI for launching
                            final uri = Uri.parse(receiptUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              // Try fallback with typo in endpoint
                              receiptUrl =
                                  '$hostPath$apiPrefix/v1/subscription-form/reciept/${item.subscirptionForm?.id}';
                              final fallbackUri = Uri.parse(receiptUrl);
                              if (await canLaunchUrl(fallbackUri)) {
                                await launchUrl(
                                  fallbackUri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                throw 'Could not launch receipt URL';
                              }
                            }
                          } catch (e) {
                            Get.snackbar(
                              'error'.tr,
                              'Failed to download receipt: ${e.toString()}',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.red.shade900,
                            );
                          }
                        },
                      );
                    },
                    child: Row(
                      children: [
                        MoleculeEditableText(
                          text: item.internalCode,
                        ),
                        MoleculeEditableText(
                          text: item.fullName,
                        ),
                        MoleculeEditableText(
                          text: item.email,
                        ),
                        MoleculeEditableText(
                          text: item.fullPhoneNumber.reverseArabic(),
                        ),
                      ],
                    ),
                  );
                },
                mobileItemBuilder: (context, index, item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText.m(UtilsDate.formatDDMMYYYY(item.createdAt)),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.WALLET,
                                parameters: {"userId": item.id.toString()});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AtomLabelWithIcon(
                                label:
                                    '+${item.countryCode} ${item.phoneNumber}',
                                icon: Icons.phone_android,
                              ),
                              AtomLabelWithIcon(
                                label: item.email,
                                icon: Icons.alternate_email,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  EntityForm<User> entityForm() {
    return EntityForm<User>(
      icon: Icons.person_add,
      title: "addNew".tr,
      entityName: controller.selectedRole.value?.name.tr,
      fillControllersForItem: (User item) async {
        controller.fullName.text = item.fullName ?? "";
        controller.email.text = item.email ?? "";
        controller.phone.text = item.phoneNumber ?? "";
        controller.countryCode = item.countryCode ?? "";
      },
      onEdit: (item) async {
        return controller.addUpdateItem(oldItem: item);
      },
      onAdd: controller.addUpdateItem,
      itemsForm: [
        ItemForm(
          label: "fullName".tr,
          controller: controller.fullName,
        ),
        ItemForm(
          label: "email".tr,
          controller: controller.email,
          isRequired: false,
        ),
        ItemForm.phone(
          controller: controller.phone,
          label: "phone".tr,
          onChangeCountryCode: (newItem) {
            controller.countryCode = newItem;
          },
        ),
      ],
    );
  }

  Obx buildAction(RolesType role) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          key: UniqueKey(),
          onTap: () {
            if (controller.selectedRole.value != role) {
              controller.selectedRole.value = role;
              controller.loadData();
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  controller.selectedRole.value == role ? primaryColor : grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                  child: CustomText.l(
                "${role.name}s".tr,
                color: white,
              )),
            ),
          ),
        ),
      );
    });
  }

  void showUpdatePassword(User item) {
    GlobalKey<FormState> form = GlobalKey();
    Alert.showCustomDialog(
      title: "updatePassword".tr,
      content: Form(
        key: form,
        child: Column(
          children: [
            AtomTextField.simple(
              label: "newPassword".tr,
              controller: controller.newPassword,
              selectTextOnFocus: true,
              isObscureText: true,
            ),
            const SizedBox(height: 32),
            AtomButton(
              label: "update".tr,
              onPressed: () {
                if (form.currentState?.validate() ?? false) {
                  controller.updatePassword(item);
                }
              },
            ),
          ],
        ),
      ),
      onClose: () {
        Get.back();
      },
    );
  }
}

class UserDetailsDialog {
  static void show({
    required dynamic entity,
    required Function(User) onActivate,
    required Function(User) onBlock,
    required Function() onDownloadPdf,
  }) {
    final dateFormat = DateFormat('dd MMM yyyy');
    bool isClient = false;
    User? user;
    SubscriptionForm? subscriptionForm;

    // Determine what type of entity we're dealing with
    if (entity is SubscriptionForm) {
      isClient = true;
      subscriptionForm = entity;
      user = subscriptionForm.user;
    } else if (entity is User) {
      isClient = entity.isClient;
      user = entity;
    }

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600, // Fixed width for web platform
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user icon and profile picture
                Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: (user?.pathPicture != null &&
                                    user!.pathPicture!.isNotEmpty) ||
                                (isClient &&
                                    subscriptionForm?.user.pathPicture !=
                                        null &&
                                    subscriptionForm!
                                        .user.pathPicture!.isNotEmpty)
                            ? AtomSafeImageNetwork(
                                height: 150,
                                width: 150,
                                radius: 150,
                                path: isClient
                                    ? subscriptionForm?.user.pathPicture
                                    : user?.pathPicture,
                                headers: ApiProvider().getImageHeaders(),
                                host: hostUploadPhotoProfile,
                                isCircular: true,
                              )
                            : Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isClient
                                      ? Icons.person
                                      : Icons.admin_panel_settings,
                                  color: Colors.white,
                                  size: 56,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.xxl(
                            isClient ? "Client Details" : "Supervisor Details",
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText.m(
                            user?.fullName ?? "",
                          ),
                          if (user?.email != null && user!.email!.isNotEmpty)
                            CustomText.xs(
                              user!.email!,
                              color: Colors.grey.shade600,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Content based on role
                if (isClient && subscriptionForm != null) ...[
                  // Client with Subscription Form
                  _buildClientContent(
                      subscriptionForm: subscriptionForm,
                      dateFormat: dateFormat,
                      isActive: user?.isVerified ?? false,
                      onActivate: onActivate,
                      onBlock: onBlock,
                      user: user!,
                      isBlocked: user.isBlocked ?? false),

                  const SizedBox(height: 24),

                  // Download PDF button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.amber[100],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onDownloadPdf,
                        icon: const Icon(Icons.download, color: Colors.black),
                        label: Text(
                          "downloadPDF".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.blue[100],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Alert.showCustomDialog(
                            title: "receipt".tr,
                            content: Column(
                              children: [
                                const SizedBox(height: 16),
                                CustomText.m(
                                  "receipt".tr,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 16),
                                if ((subscriptionForm?.pathReceipt == null ||
                                        subscriptionForm!
                                            .pathReceipt!.isEmpty) &&
                                    (subscriptionForm?.pathPicture == null ||
                                        subscriptionForm!.pathPicture!.isEmpty))
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Icon(Icons.receipt_long,
                                            size: 48, color: Colors.grey[400]),
                                        const SizedBox(height: 8),
                                        Text(
                                          "noReceiptAvailable".tr,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  // Test with the correct URL structure
                                  Builder(
                                    builder: (context) {
                                      final filePath =
                                          subscriptionForm?.pathReceipt ??
                                              subscriptionForm?.pathPicture;

                                      // The route pattern is ':uploads/receipt' where :uploads is a parameter
                                      // So we need to provide an actual value for :uploads
                                      final correctUrl =
                                          "$hostPath$apiPrefix/v1/subscription-form/uploads/receipt?path=$filePath";

                                      print("Receipt path: $filePath");
                                      print("URL: $correctUrl");

                                      return Column(
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                correctUrl,
                                                headers: ApiProvider()
                                                    .getImageHeaders(),
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (context, error, stack) {
                                                  print("Image error: $error");
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.broken_image,
                                                          size: 48,
                                                          color: Colors.grey),
                                                      Text(
                                                          "Receipt not available",
                                                          textAlign:
                                                              TextAlign.center),
                                                      Text(
                                                          "Error: ${error.toString().substring(0, min(50, error.toString().length))}...",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                            onClose: () {
                              Get.back();
                            },
                          );
                        }, label:const Text( "download"),
                      ),
                    ],
                  ),
                ] else if (user != null) ...[
                  // Supervisor or any other role
                  _buildSupervisorContent(user, dateFormat),
                ],

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Client content with subscription details
  static Widget _buildClientContent({
    required SubscriptionForm subscriptionForm,
    required DateFormat dateFormat,
    required bool isActive,
    required User user,
    required bool isBlocked,
    Function(User)? onActivate,
    Function(User)? onBlock,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Two-column layout for web
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Information
                      _buildInfoSection(
                        title: "Member Information",
                        icon: Icons.person,
                        content: [
                          _buildInfoItem(
                              "Name", subscriptionForm.user.fullName ?? ""),
                          _buildInfoItem(
                              "Email", subscriptionForm.user.email ?? ""),
                          _buildInfoItem(
                              "Phone", subscriptionForm.user.fullPhoneNumber),
                          _buildInfoItem("Internal Code",
                              subscriptionForm.user.internalCode ?? ""),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // OLM Information
                      _buildInfoSection(
                        title: "OLM Information",
                        icon: Icons.location_on,
                        content: [
                          _buildInfoItem("Name", subscriptionForm.olm.name),
                          if (subscriptionForm.olm.olmZoneType != null)
                            _buildInfoItem(
                                "Zone",
                                subscriptionForm.olm.olmZoneType
                                    .toString()
                                    .split('.')
                                    .last),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Right column
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subscription Details
                      _buildInfoSection(
                        title: "Subscription Details",
                        icon: Icons.assignment,
                        content: [
                          _buildInfoItem(
                              "Type",
                              subscriptionForm
                                  .subscriptionOption.subscriptionType),
                          _buildInfoItem("Price",
                              "${subscriptionForm.subscriptionOption.price} CFA"),
                          _buildInfoItem(
                              "Position Type", subscriptionForm.positionType),
                          _buildInfoItem(
                              "Position Title", subscriptionForm.positionTitle),
                          if (subscriptionForm.roommates != null &&
                              subscriptionForm.roommates!.isNotEmpty)
                            _buildInfoItem(
                                "Roommates", subscriptionForm.roommates!),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Date Information
                      _buildInfoSection(
                        title: "Date Information",
                        icon: Icons.calendar_today,
                        content: [
                          _buildInfoItem("Created",
                              dateFormat.format(subscriptionForm.createdAt)),
                          _buildInfoItem("Updated",
                              dateFormat.format(subscriptionForm.updatedAt)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Status Controls
        Card(
          elevation: 0,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 18,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Account Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Switchers
                Row(
                  children: [
                    // Active switch
                    Expanded(
                        child: SwitchListTile(
                      title: Text("active".tr),
                      subtitle: Text("enableDisableAccount".tr),
                      value: isActive,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        isActive = value;
                        if (onActivate != null) {
                          onActivate(user);
                        }
                      },
                    )),

                    // Block switch
                    Expanded(
                        child: SwitchListTile(
                      title: Text("blocked".tr),
                      subtitle: Text("blockAccountAccess".tr),
                      value: isBlocked,
                      activeColor: Colors.red,
                      onChanged: (value) {
                        isBlocked = value;
                        if (onBlock != null) {
                          onBlock(user);
                        }
                      },
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Supervisor content with user details
  static Widget _buildSupervisorContent(User user, DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Two-column layout for web
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildInfoSection(
                        title: "basicInformation".tr,
                        icon: Icons.person,
                        content: [
                          _buildInfoItem("fullName".tr, user.fullName ?? ""),
                          _buildInfoItem(
                              "internalCode".tr, user.internalCode ?? ""),
                          _buildInfoItem("role".tr, user.role?.name ?? ""),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Additional Information
                      _buildInfoSection(
                        title: "systemInformation".tr,
                        icon: Icons.verified_user,
                        content: [
                          _buildInfoItem(
                              "createdDate".tr,
                              dateFormat
                                  .format(user.createdAt ?? DateTime.now())),
                          _buildInfoItem("language".tr, user.language ?? ""),
                          if (user.credit != null)
                            _buildInfoItem(
                                "creditBalance".tr, user.credit.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Right column
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Information
                      _buildInfoSection(
                        title: "contactInformation".tr,
                        icon: Icons.contact_mail,
                        content: [
                          _buildInfoItem("email".tr, user.email ?? ""),
                          _buildInfoItem("phone".tr, user.fullPhoneNumber),
                          _buildInfoItem(
                              "countryCode".tr, user.countryCode ?? ""),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // System Actions
                      _buildInfoSection(
                        title: "systemActions".tr,
                        icon: Icons.settings,
                        content: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.password, size: 18),
                                  label: Text("changePassword".tr),
                                  onPressed: () {
                                    Get.back();
                                    // Implement password change functionality
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: Text("editUser".tr),
                                  onPressed: () {
                                    Get.back();
                                    // Implement edit user functionality
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.blue[700],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ],
    );
  }

  static Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
