import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:eco_trans/app/data/models/entities/branch.dart';
import 'package:eco_trans/app/data/models/form/entity_form.dart';
import 'package:eco_trans/app/global_widgets/atoms/spinner_progress_indicator.dart';
import 'package:eco_trans/app/global_widgets/templates/app_scaffold.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/date.dart';
import '../../../data/models/form/item_form.dart';
import '../../../global_widgets/atoms/list_view_builder.dart';
import '../controllers/branch_controller.dart';

class BranchView extends GetView<BranchController> {
  const BranchView({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "branches".tr,
      selectedIndex: 5,
      withMenu: true,
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const AtomSpinnerProgressIndicator();
        }
        return AtomListViewBuilder<Branch>(
          items: controller.branches.value,
          itemBuilder: (context, index, item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.sm(
                        item.company?.name,
                        isGradient: true,
                      ),
                      CustomText.m(
                        UtilsDate.formatDDMMYYYY(item.createdAt),
                      ),
                    ],
                  ),

                  CustomText.xl(
                    item.name,
                    isGradient: true,
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        );
      }),
      entityForms: [
        addDealerForm(context),
      ],
    );
  }

  EntityForm addDealerForm(context) {
    return EntityForm(
      icon: Icons.location_on,
      itemsForm: [
        ItemForm.rxSelect(
          label: "country".tr,
          onChange: controller.onSelectCountry,
          rxItems: controller.countries,
        ),
        ItemForm.rxSelect(
          controller: controller.region,
          label: "region".tr,
          onChange: (newItem) {
            controller.selectedRegion = newItem;
            controller.branchName.text =
            "${"branch".tr} ${controller.selectedRegion?.name ?? ""}";
          },
          rxItems: controller.regions,
        ),
        ItemForm(
          label: "name".tr,
          controller: controller.branchName,
        ),
        ItemForm(
          label: "branchPosition".tr,
          controller: controller.branchPosition,
          readOnly: true,
          isRequired: false,
          onTap: () => controller.selectPosition(context),
          suffix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.map),
          ),
        ),
        ItemForm.rxSelect(
          label: "companies".tr,
          onChange: (newItem) {
            controller.selectedCompany = newItem;
          },
          rxItems: controller.companies,
        ),
      ],
      onAdd: controller.addItem,
    );
  }
}
