import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/extensions/string/language.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/utils/constant.dart';
import '../../core/utils/language_helper.dart';
import '../../core/utils/screen.dart';
import '../../core/values/languages/language.dart';
import '../../data/enums/role_type.dart';
import '../../data/models/item_select.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../routes/app_pages.dart';
import '../organisms/dropdown.dart';
import 'menu_item.dart';

class AtomDrawerContent extends StatelessWidget {
  final int? selectedIndex;

  const AtomDrawerContent({
    super.key,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IntrinsicWidth(
        child: Column(
          children: [
            if (isMobile(context))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 80,
                  child: OrganismDropdown(
                    initValue: Language.getElementForSelect(
                      LanguageHelper.language,
                    ),
                    isSearchable: false,
                    isRequired: false,
                    withBorder: false,
                    simpleInput: true,
                    items: Language.list
                        .map((element) => ItemSelect(
                              label: element.code,
                              pathPicture: element.path,
                              value: element,
                            ))
                        .toList(),
                    onChange: (item) async {
                      UserService userService = UserService();
                      await userService.setLanguage(
                        language: item.label.languageCode,
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(
              height: 10.0,
            ),
            AtomMenuItem(
              label: "home".tr,
              isSelected: selectedIndex == 1,
              icon: Icons.home_outlined,
              onTap: () => Get.offAllNamed(Routes.HOME),
            ),
            if (AuthService.isClient())
              AtomMenuItem(
                label: "myWallet".tr,
                isSelected: selectedIndex == 2,
                icon: Icons.wallet,
                onTap: () => Get.offAllNamed(Routes.WALLET),
              ),
            if (AuthService.access?.role == RolesType.admin)
              AtomMenuItem(
                label: "users".tr,
                isSelected: selectedIndex == 3,
                icon: Icons.group,
                onTap: () => Get.offAllNamed(Routes.USERS),
              ),
            if (AuthService.isAdmin())
              AtomMenuItem(
                label: 'events',
                icon: Icons.event,
                isSelected: selectedIndex == 7,
                onTap: () {
                  Get.offAllNamed(Routes.EVENTS);
                },
              ),
            if (AuthService.isAppManager())
              AtomMenuItem(
                label: "companies".tr,
                isSelected: selectedIndex == 4,
                icon: Icons.business_sharp,
                onTap: () => Get.offAllNamed(Routes.COMPANY),
              ),

            AtomMenuItem(
              isSelected: selectedIndex == 6,
              label: "termsOfUse".tr,
              icon: Icons.content_paste_search,
              onTap: () async {
                if (await canLaunchUrlString(termsOfUseUrl)) {
                  await launchUrlString(termsOfUseUrl,
                      mode: LaunchMode.externalApplication);
                }
              },
            ),
            AtomMenuItem(
              label: 'logout'.tr,
              icon: Icons.logout,
              onTap: () {
                AuthService().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
