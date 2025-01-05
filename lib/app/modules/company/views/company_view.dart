import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:eco_trans/app/core/utils/file_picker.dart';
import 'package:eco_trans/app/data/models/form/entity_form.dart';
import 'package:eco_trans/app/data/models/form/item_form.dart';
import 'package:eco_trans/app/data/providers/external/api_provider.dart';
import 'package:eco_trans/app/data/providers/external/src/api_provider_helper.dart';
import 'package:eco_trans/app/global_widgets/atoms/spinner_progress_indicator.dart';
import 'package:eco_trans/app/global_widgets/templates/app_scaffold.dart';
import '../../../core/theme/text.dart';
import '../../../core/utils/constant.dart';
import '../../../core/utils/date.dart';
import '../../../global_widgets/atoms/list_view_builder.dart';
import '../controllers/company_controller.dart';

class CompanyView extends GetView<CompanyController> {
  const CompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "company".tr,
      selectedIndex: 4,
      withMenu: true,
      onSearch: (value) {

      },
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const AtomSpinnerProgressIndicator();
        }
        return AtomListViewBuilder(
          items: controller.companies.value,
          itemBuilder: (context, index, item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: CustomText.m(
                      UtilsDate.formatDDMMYYYY(item.createdAt),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.imagePath != null)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: CachedNetworkImage(
                            width: 50,
                            imageUrl: "$hostCompanyPhotos?path=${item.imagePath}",
                            fit: BoxFit.contain,
                            httpHeaders: ApiProvider().getImageHeaders(),
                          ),
                        ),
                      CustomText.xl(
                        item.name,
                        isGradient: true,
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        );
      }),
      entityForms: [
        addForm(context),
      ],
    );
  }

  EntityForm addForm(context) {
    return EntityForm(
      icon: Icons.add_business_sharp,
      itemsForm: [
        ItemForm(
          onTap: () async {
            controller.selectedFile = await CustomFilePicker.showPicker(context: context);
            controller.imagePath.text = controller.selectedFile?.fileName ?? "";
          },
          label: "logo".tr,
          controller: controller.imagePath,
          isRequired: false,
          suffix: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () async {
                controller.selectedFile = await CustomFilePicker.showPicker(context: context);
                controller.imagePath.text = controller.selectedFile?.fileName ?? "";
              }),
        ),
        ItemForm(
          label: "companyName".tr,
          controller: controller.companyName,
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
          label: "country".tr,
          onChange: controller.onSelectCountry,
          rxItems: controller.countries,
        ),
        ItemForm.rxSelect(
          controller: controller.region,
          label: "region".tr,
          onChange: (newItem) {
            controller.selectedRegion = newItem;
            controller.branchName.text = "${"branch".tr} ${controller.selectedRegion?.name ?? ""}";
          },
          rxItems: controller.regions,
        ),
        ItemForm(
          label: "branchName".tr,
          controller: controller.branchName,
        ),
        ItemForm.phone(
          label: "phone".tr,
          isRequired: false,
          controller: controller.phoneNumber,
          onChangeCountryCode: (countryCode) async {
            controller.countryCode = countryCode;
          },
        ),
        ItemForm(
          label: "firstName".tr,
          controller: controller.firstName,
        ),
        ItemForm(
          label: "lastName".tr,
          controller: controller.lastName,
        ),
      ],
      onAdd: controller.addItem,
    );
  }
}
