import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/extensions/string/language.dart';
import 'package:rnp_front/app/data/models/form/entity_form.dart';
import 'package:rnp_front/app/data/models/form/item_action.dart';
import 'package:rnp_front/app/data/models/item_header.dart';
import 'package:rnp_front/app/global_widgets/atoms/search.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../core/utils/date.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/role_type.dart';
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
                      Get.toNamed(Routes.WALLET,
                          parameters: {"userId": item.id.toString()});
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
                                textDirection: TextDirection.ltr,
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
            controller.selectedRole.value = role;
            controller.loadData();
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
