import 'package:flutter/material.dart';
import '../../../app/core/values/colors.dart';


class AppThemes {
  static final light = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    textTheme: const TextTheme(),
    appBarTheme: const AppBarTheme(
      color: primaryColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor:  primaryColor,
    ),
    secondaryHeaderColor: primaryColor,
      colorScheme: const ColorScheme.light().copyWith(
          primary: primaryColor
      )

  );
  static final dark = ThemeData.dark().copyWith(

  );
}