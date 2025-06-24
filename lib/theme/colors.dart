import 'package:flutter/material.dart';

class CustomColors {
  static const Map<int, Color> primary = const {
    050: const Color(0xFFE0F7FA),
    100: const Color(0xFFB2EBF2),
    200: const Color(0xFF80DEEA),
    300: const Color(0xFF4DD0E1),
    400: const Color(0xFF26C6DA),
    500: const Color(0xFF00BCD4),
    600: const Color(0xFF00ACC1),
    700: const Color(0xFF0097A7),
    800: const Color(0xFF00838F),
    900: const Color(0xFF006064),
  };

  // Names derived from https://www.color-blindness.com/color-name-hue/
  static const Color solitude = const Color(0xFFECF0F3);
  static const Color turquoise = const Color(0xFF33DBD6);
  static const Color turquoise1 = const Color(0xFF1BC9CF);
  static const Color turquoise2 = const Color(0xFF00B4C7);
  static const Color irisBlue = const Color(0xFF01B5C7);
  static const Color zircon = const Color(0xFFDEE3E6);
  static const Color periwinkle = const Color(0xFFD1D9E6);
  static const Color spindle = const Color(0xFFBBC6D8);
  static const Color blackPearl = const Color(0xFF1C212B);
  static const Color mischka = const Color(0xFFACB0B6);
  static const Color darkMischka = const Color(0xFFA1A7AE);
  static const Color rockBlue = const Color(0xFF8C99B1);
  static const Color scarlet = const Color(0xFFFAC1B07);
  static const Color nightRider = const Color(0xFFF2F2F2F);
  static const Color mildGrey = const Color(0xFFF6C6E71);
  static const Color nero = const Color(0xFFF202020);
  static const Color gunPowder = const Color(0xFFF505052);
  static const Color greyColor = const Color(0xFFECF0F3);

  // Gradients
  static const LinearGradient primary180 =
      const LinearGradient(colors: [turquoise, turquoise2]);
  // Gradients
  static const LinearGradient primary180Pressed = const LinearGradient(colors: [
    turquoise,
    turquoise1,
    turquoise2,
  ]);

  static const LinearGradient primary90 = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [turquoise, irisBlue]);

  static const LinearGradient grey90 = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [solitude, zircon],
  );

  static const List<Color> greyIconGradient = <Color>[
    CustomColors.spindle,
    CustomColors.rockBlue,
  ];

  static const List<Color> greyIconGradientTwo = <Color>[
    CustomColors.periwinkle,
    CustomColors.rockBlue,
  ];

  static const List<Color> primaryIconGradient = <Color>[
    CustomColors.turquoise,
    CustomColors.irisBlue,
  ];
}
