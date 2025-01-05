import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:eco_trans/app/core/values/languages/language.dart';
import 'package:eco_trans/app/data/models/item_select.dart';
import 'package:eco_trans/app/data/services/user_service.dart';
import 'package:eco_trans/app/global_widgets/organisms/dropdown.dart';
import '../../core/theme/text.dart';
import '../../core/utils/constant.dart';
import '../../core/utils/language_helper.dart';
import '../../core/utils/screen.dart';
import '../../core/values/colors.dart';

class AtomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? customTitle;
  final bool centerTitle;
  final bool withCloseIcon;
  final void Function()? onTapIcon;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool withMenu;
  final IconData? icon;
  final List<Widget> actions;

  const AtomAppBar({
    super.key,
    this.title,
    this.customTitle,
    this.centerTitle = true,
    this.withCloseIcon = true,
    this.onTapIcon,
    this.scaffoldKey,
    this.icon,
    this.withMenu = true,
    required this.actions,
  });

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      automaticallyImplyLeading: false,
      toolbarHeight: appBarHeight,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: kIsWeb ? white : primaryColor),
      ),
      actions: [
        ...actions,
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: IconButton(
              color: white,
              icon: Icon(icon),
              onPressed: onTapIcon,
            ),
          ),
        if(!isMobile(context))
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: SizedBox(
              width: 60,
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
      ],
      leading: withCloseIcon
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : !withMenu
              ? null
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: white,
                    ),
                    onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                  ),
                ),
      leadingWidth: 90,
      title: customTitle ??
          CustomText.xl(
            title,
            color: white,
          ),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, appBarHeight);
}
