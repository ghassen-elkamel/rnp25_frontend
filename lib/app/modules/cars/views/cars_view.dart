import 'package:eco_trans/app/data/enums/car_status.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';
import 'package:eco_trans/app/data/models/entities/user.dart';
import 'package:eco_trans/app/data/models/form/item_action.dart';
import 'package:eco_trans/app/data/models/form/item_form.dart';
import 'package:eco_trans/app/data/models/item_header.dart';
import 'package:eco_trans/app/global_widgets/molecules/build_list.dart';
import 'package:eco_trans/app/global_widgets/molecules/editable_text.dart';
import 'package:eco_trans/app/global_widgets/organisms/dropdown.dart';
import 'package:eco_trans/app/global_widgets/templates/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/alert.dart';
import '../../../core/values/colors.dart';
import '../../../data/models/entities/car.dart';
import '../../../data/models/form/entity_form.dart';
import '../../../global_widgets/atoms/button.dart';
import '../../../global_widgets/atoms/search.dart';
import '../controllers/cars_controller.dart';

class CarsView extends GetView<CarsController> {
  const CarsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'cars'.tr,
      selectedIndex: 7,
      padding: const EdgeInsets.all(16.0),
      withMenu: true,
      withCloseIcon: Navigator.canPop(context),
      body: MoleculeBuildList<Car>.rx(
        form: entityForm(),
        itemsRx: controller.items,
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
            "model".tr,
            onChangeOrder: (order) {
              controller.orderByFullName(order);
            },
          ),
          ItemHeader("registrationNumber".tr),
          ItemHeader("type".tr),
          ItemHeader("status".tr),
          ItemHeader("drivers".tr),
        ],
        onDelete: (item) async {
          controller.deleteItem(item);
        },
        otherActions: [
          ItemAction(
            label: "affectTo".tr,
            icon: Icons.person,
            onPressed: (Car item) {
              showUpdateDriver(item);
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
          return Row(
            children: [
              MoleculeEditableText(
                text: item.internalCode,
              ),
              MoleculeEditableText(
                text: item.fullName,
              ),
              MoleculeEditableText(
                text: item.registrationNumber,
              ),
              MoleculeEditableText(
                text: item.carType.toString(),
              ),
              MoleculeEditableText(
                text: item.status.toString(),
              ),
              MoleculeEditableText(
                text: item.carDrivers.map((carDriver) => carDriver.driver?.user,).join('\n'),
              ),
            ],
          );
        },
      ),
    );
  }

  EntityForm<Car> entityForm() {
    return EntityForm<Car>(
      icon: Icons.person_add,
      title: "addNew".tr,
      entityName: "car".tr,
      fillControllersForItem: (Car item) async {
        controller.brand.text = item.brand ?? "";
        controller.model.text = item.model ?? "";
        controller.registrationNumber.text = item.registrationNumber ?? "";
        controller.selectedCarStatus.value = item.status ?? CarStatus.available;
        controller.selectedCarType.value = item.carType ?? CarType.taxi;
      },
      onEdit: (item) async {
        return controller.addUpdateItem(oldItem: item);
      },
      onAdd: controller.addUpdateItem,
      itemsForm: [
        ItemForm(
          label: "brand".tr,
          controller: controller.brand,
        ),
        ItemForm(
          label: "model".tr,
          controller: controller.model,
        ),
        ItemForm(
          label: "registrationNumber".tr,
          controller: controller.registrationNumber,
        ),
        ItemForm.select(
          label: "type".tr,
          initValue: controller.selectedCarType,
          items: carTypes,
          onChange: (newItem) {
            controller.selectedCarType.value = newItem;
          },
        ),
        ItemForm.select(
          label: "status".tr,
          initValue: controller.selectedCarStatus,
          items: carStatus,
          onChange: (newItem) {
            controller.selectedCarStatus.value = newItem;
          },
        ),
      ],
    );
  }

  void showUpdateDriver(Car item) {
    GlobalKey<FormState> form = GlobalKey();
    Alert.showCustomDialog(
      title: "updateAffectedDriver".tr,
      content: Form(
        key: form,
        child: Column(
          children: [
            OrganismDropdown<User>.multiselect(
              label: "drivers".tr,
              init: item.carDrivers.map((e) => e.driver?.user,).whereType<User>().toList(),
              objects: controller.users.value,
              onChangeSelectedItems: (items) {
                controller.selectedDrivers = items;
              },
            ),
            const SizedBox(height: 32),
            AtomButton(
              label: "update".tr,
              onPressed: () {
                if (form.currentState?.validate() ?? false) {
                  controller.updateAffectedDriver(item);
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
