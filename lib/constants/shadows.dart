import 'package:masjidhub/theme/colors.dart';
import 'package:flutter/material.dart';

final List<BoxShadow> shadowNeu = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 15.0,
    spreadRadius: 5.0,
    offset: Offset(
      -9.0,
      -9.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 15.0,
    spreadRadius: 5.0,
    offset: Offset(
      9.0,
      9.0,
    ),
  ),
]);

final List<BoxShadow> shadowNeuSecondary = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 10.0,
    spreadRadius: 2.0,
    offset: Offset(
      -9.0,
      -9.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 10.0,
    spreadRadius: 2.0,
    offset: Offset(
      9.0,
      9.0,
    ),
  ),
]);

final List<BoxShadow> secondaryShadow = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 10.0,
    spreadRadius: 5.0,
    offset: Offset(
      -5.0,
      -5.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 10.0,
    spreadRadius: 5.0,
    offset: Offset(
      5.0,
      5.0,
    ),
  ),
]);

final List<BoxShadow> tertiaryShadow = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 10.0,
    spreadRadius: 1.0,
    offset: Offset(
      -5.0,
      -5.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 10.0,
    spreadRadius: 1.0,
    offset: Offset(
      5.0,
      5.0,
    ),
  ),
]);

final List<BoxShadow> tesbihInnerConcaveShadow = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 10.0,
    spreadRadius: 1.0,
    offset: Offset(
      -2.0,
      -2.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 10.0,
    spreadRadius: 1.0,
    offset: Offset(
      2.0,
      2.0,
    ),
  ),
]);

final List<BoxShadow> tertiaryShadowAppBar = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.9),
    blurRadius: 5.0,
    spreadRadius: 1.0,
    offset: Offset(
      -3.0,
      -3.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 5.0,
    spreadRadius: 1.0,
    offset: Offset(
      3.0,
      3.0,
    ),
  ),
]);

final List<BoxShadow> shadowNeuPressed = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 15.0,
    spreadRadius: 5.0,
    offset: Offset(
      -3.0,
      -3.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 2.0,
    spreadRadius: 0.1,
    offset: Offset(
      3.0,
      3.0,
    ),
  ),
]);

final List<BoxShadow> shadowDotActive = ([
  BoxShadow(
    color: Colors.white.withValues(alpha: 0.75),
    blurRadius: 5.0,
    spreadRadius: 0.1,
    offset: Offset(
      -2.0,
      -2.0,
    ),
  ),
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 5.0,
    spreadRadius: 0.1,
    offset: Offset(
      2.0,
      2.0,
    ),
  ),
]);

final List<Color> innerConcaveShadow = ([
  Colors.white,
  CustomColors.spindle,
]);

final List<Color> tabBarInnerShadow = ([
  Color(0xFF006064).withValues(alpha: 0.4),
  CustomColors.irisBlue,
]);

List<BoxShadow> bottomNavShadow(Color color) => ([
      BoxShadow(
        color: color.withValues(alpha: 0.75),
        blurRadius: 20.0,
        spreadRadius: 1.0,
        offset: Offset(
          -3.0,
          -10.0,
        ),
      )
    ]);

final List<BoxShadow> shadowTesbihDot = ([
  BoxShadow(
    color: CustomColors.periwinkle,
    blurRadius: 0.5,
    spreadRadius: 0.1,
    offset: Offset(
      1.0,
      1.0,
    ),
  ),
]);
