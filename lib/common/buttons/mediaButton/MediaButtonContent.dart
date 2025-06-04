import 'package:flutter/material.dart';

import 'package:masjidhub/common/buttons/mediaButton/mediaButton.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class MediaButtonContent extends StatelessWidget {
  const MediaButtonContent({
    Key? key,
    required this.icon,
    required this.state,
    this.margin = EdgeInsets.zero,
    required this.onPressed,
    required this.isDisabled,
  }) : super(key: key);

  final IconData icon;
  final EdgeInsets margin;
  final MediaButtonState state;
  final Function onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    bool isActive = state == MediaButtonState.active;
    bool isPressed = state == MediaButtonState.pressed;
    Color backgroundColor = CustomTheme.lightTheme.colorScheme.background;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(),
      child: Container(
        margin: margin,
        decoration: !isPressed
            ? BoxDecoration(
                color: backgroundColor,
                boxShadow: tertiaryShadow,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30),
                gradient: isActive ? CustomColors.primary180 : null,
              )
            : ConcaveDecoration(
                depth: 9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                colors: innerConcaveShadow,
                size: Size(50, 50),
              ),
        height: 50,
        width: 50,
        child: isActive
            ? Icon(
                icon,
                size: 25,
                color: backgroundColor,
              )
            : Opacity(
                opacity: isDisabled ? 0.3 : 1,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: isPressed
                          ? CustomColors.primaryIconGradient
                          : CustomColors.greyIconGradient,
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    icon,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
