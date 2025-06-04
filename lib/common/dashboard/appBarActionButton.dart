import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class AppBarActionButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final bool isLeading;
  final bool isActive;
  final double? iconSize;

  const AppBarActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.isActive = false,
    this.isLeading = false,
    this.iconSize = 20.0,
  }) : super(key: key);

  static List<Color> greyIconGradient = <Color>[
    CustomColors.spindle,
    CustomColors.rockBlue,
  ];

  static List<Color> activeColor = <Color>[
    CustomColors.spindle,
    CustomColors.rockBlue,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(),
      child: Container(
        height: 50,
        width: 40,
        margin: isLeading
            ? EdgeInsets.fromLTRB(15, 20, 0, 20)
            : EdgeInsets.fromLTRB(0, 20, 20, 20),
        padding: EdgeInsets.all(3),
        decoration: isActive
            ? ConcaveDecoration(
                depth: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                colors: innerConcaveShadow,
                size: Size(40, 40),
              )
            : BoxDecoration(
                color: CustomColors.solitude,
                boxShadow: tertiaryShadowAppBar,
                borderRadius: BorderRadius.circular(15),
              ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: isActive
                  ? CustomColors.primaryIconGradient
                  : CustomColors.greyIconGradient,
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
