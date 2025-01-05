import 'package:flutter/material.dart';
import '../../core/theme/text_theme.dart';
import '../../core/utils/constant.dart';
import '../../core/values/colors.dart';
import 'package:get/get.dart';
import '../../core/values/languages/language.dart';
import '../../data/providers/storage_provider.dart';
class AtomChooseLanguage extends StatelessWidget {
  final String label;
  final String? pathImage;

  const AtomChooseLanguage({
    super.key,
    required this.label,
    required this.pathImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => chooseLanguage(context),
      child: SizedBox(
        key: key,
        height: 51,
        width: double.infinity,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if(pathImage != null)
                    Image.asset(pathImage!),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(label, style: styleBlack90FontRobotoW400Size16),
                    ),
                  ],
                ),
                Image.asset("assets/icons/keyboard_arrow_down.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseLanguage(context){
    Rx<Locale> locale = Get.locale?.obs ?? const Locale("fr_FR").obs;
    showBottomSheet(
      context: context,
      builder: (context) {
      return ColoredBox(
        color: white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("cancel".tr, style: styleBlack2FontRobotoW500Size16,),
                      )
                  ),
                  InkWell(
                      onTap: () async {
                        Get.updateLocale(locale.value);
                        StorageHelper storage = StorageHelper();
                        await storage.saveItem(key:storageLocaleKey,item: locale.value.toString());
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("ok".tr, style: styleBlack2FontRobotoW500Size16,),
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            ...Language.list.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                  return Opacity(
                    opacity: locale.value.toString() == e.code ? 1 : 0.5,
                    child: InkWell(
                      onTap: () {
                        locale.value = Locale(e.code);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: locale.value.toString() == e.code ? grey : white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(e.path),
                              const SizedBox(width: 12,),
                              Text(e.code.tr, style: styleBlack90FontRobotoW500Size20,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            )),
            const SizedBox(height: 24,)
          ],
        ),
      );
    },);
  }

}
