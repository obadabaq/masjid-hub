import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.solitude,
      scaffoldBackgroundColor: CustomColors.solitude,
      fontFamily: 'SFProText',
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.grey[500]), colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: CustomColors.primary[500]).copyWith(background: CustomColors.solitude),
    );
  }
}
