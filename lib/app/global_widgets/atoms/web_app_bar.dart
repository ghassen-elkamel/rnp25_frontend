import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:flutter/material.dart';

import '../../core/utils/language_helper.dart';
import '../../core/values/languages/language.dart';
import '../../data/services/user_service.dart';
import '../organisms/dropdown.dart';
import 'logo.dart';
class AtomWebAppBar extends StatelessWidget {
  const AtomWebAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: AtomLogo(
            height: 60,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80,
          child: OrganismDropdown.entity(
            init: Language.getElementByCode(
              LanguageHelper.language,
            ),
            isSearchable: false,
            isRequired: false,
            withBorder: false,
            simpleInput: true,
            objects: Language.list,
            onChange: (item) async {
              UserService userService = UserService();
              await userService.setLanguage(
                language: item.label.languageCode,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
