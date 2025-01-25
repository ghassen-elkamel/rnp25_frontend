import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnp_front/app/core/theme/text.dart';
import 'package:rnp_front/app/core/values/colors.dart';
import 'package:rnp_front/app/data/enums/button_type.dart';
import 'package:rnp_front/app/data/models/form/entity_form.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';

import '../../core/utils/screen.dart';
import '../../global_widgets/atoms/app_bar.dart';
import '../../global_widgets/atoms/floating_action_button.dart';
import '../atoms/drawer_content.dart';
import '../atoms/search.dart';
import '../atoms/web_app_bar.dart';
import '../molecules/drawer.dart';

class AppScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Widget body;
  final EdgeInsets? padding;
  final AtomFloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool withMenu;
  final Color? backgroundColor;
  final bool withCloseIcon;
  final String? title;
  final Widget? customTitle;
  final bool centerTitle;
  final int? selectedIndex;
  final void Function()? onTapIcon;
  final IconData? icon;
  final List<Widget> actions;
  final bool withBackgroundImage;
  final List<EntityForm> entityForms;
  final bool floatingFormsAdd;
  final bool withAppBar;
  final void Function(String value)? onSearch;
  final void Function()? clearSearch;
  final void Function()? onTapSearch;
  final bool stackedSearch;

  AppScaffold({
    super.key,
    required this.body,
    this.withMenu = true,
    this.withCloseIcon = false,
    this.backgroundColor,
    this.title,
    this.centerTitle = true,
    this.floatingActionButton,
    this.selectedIndex,
    this.icon,
    this.onTapIcon,
    this.actions = const [],
    this.withBackgroundImage = false,
    this.floatingFormsAdd = false,
    this.padding,
    this.withAppBar = true,
    this.onSearch,
    this.clearSearch,
    this.onTapSearch,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.startFloat,
    this.entityForms = const [],
    this.stackedSearch = false,
  }) : customTitle = null;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (kIsWeb && title != null)
              DecoratedBox(
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border(bottom: BorderSide(color: secondColor))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: CustomText.xl(title),
                ),
              ),
            Expanded(child: getTopBtnAdd(context)),
          ],
        ),
        if (!stackedSearch && onSearch != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AtomSearch(
              onChanged: onSearch,
              clearSearch: clearSearch,
              onTap: onTapSearch,
              fillColor: white,
              borderRadius: 20,
            ),
          ),
        Expanded(
          child: body,
        ),
      ],
    );
    return Scaffold(
      appBar: withAppBar && isMobile(context)
          ? AtomAppBar(
              title: title,
              customTitle: customTitle,
              centerTitle: centerTitle,
              scaffoldKey: _scaffoldKey,
              withMenu: withMenu,
              withCloseIcon: withCloseIcon,
              icon: icon,
              onTapIcon: onTapIcon,
              actions: actions,
            )
          : null,
      key: _scaffoldKey,
      backgroundColor: white,
      drawer: !withMenu || withCloseIcon || !isMobile(context)
          ? null
          : MoleculeDrawer(
              selectedIndex: selectedIndex,
            ),
      body: DecoratedBox(
        decoration: BoxDecoration(
            image: withBackgroundImage
                ? const DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  )
                : null),
        child: Column(
          children: [
            if (!isMobile(context)) const AtomWebAppBar(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (withMenu && !withCloseIcon && !isMobile(context))
                    AtomDrawerContent(
                      selectedIndex: selectedIndex,
                    ),
                  Expanded(
                    child: ColoredBox(
                      color: background,
                      child: Padding(
                        padding: padding ??
                            const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                        child: stackedSearch
                            ? Stack(
                                children: [
                                  content,
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 70, left: 16.0, right: 16),
                                    child: Row(
                                      children: [
                                        if (withMenu &&
                                            !withAppBar &&
                                            isMobile(context))
                                          AtomFloatingActionButton(
                                            onPressed: () {
                                              _scaffoldKey.currentState
                                                  ?.openDrawer();
                                            },
                                            icon: Icons.menu,
                                          ),
                                        const SizedBox(width: 8),
                                        if (onSearch != null)
                                          Expanded(
                                            child: AtomSearch(
                                              onChanged: onSearch,
                                              clearSearch: clearSearch,
                                              onTap: onTapSearch,
                                              fillColor: white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : content,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: getFloatingBtnAdd(context) ?? floatingActionButton,
    );
  }

  Widget? getFloatingBtnAdd(context) {
    if (!floatingFormsAdd) {
      return null;
    }
    List<Widget> buttonsAdd = [];

    for (EntityForm entityForm in entityForms) {
      buttonsAdd.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AtomFloatingActionButton(
            key: UniqueKey(),
            onPressed: () => entityForm.showAddUpdateModal(context: context),
            icon: entityForm.icon,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...buttonsAdd,
        if (floatingActionButton != null) floatingActionButton!
      ],
    );
  }

  Widget getTopBtnAdd(context) {
    if (floatingFormsAdd) {
      return const SizedBox();
    }
    List<Widget> buttonsAdd = [];

    for (EntityForm entityForm in entityForms) {
      buttonsAdd.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AtomButton(
            isSmall: true,
            radius: 16,
            buttonColor: ButtonColor.second,
            key: UniqueKey(),
            onPressed: () => entityForm.showAddUpdateModal(context: context),
            label: entityForm.title ?? "addNew".tr,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttonsAdd,
    );
  }
}
