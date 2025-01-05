import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/core/utils/constant.dart';
import 'app/core/utils/language_helper.dart';
import 'app/core/values/colors.dart';
import 'app/core/values/languages/language.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(!kIsWeb) {
   // ConfigFirebase.init();
  }
  //Stripe.publishableKey = stripePublishableKey;

  LanguageHelper.language = await LanguageHelper.getLanguage();
  AuthService authService = AuthService();
  authService.isAppLoggedIn();
  initializeDateFormatting();
  runApp(
    GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: Language(),
      theme: ThemeData().copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
      ),
      locale: Locale(LanguageHelper.language.languageCode),
      builder: EasyLoading.init(),
    ),
  );
}
