import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/constants/shadows.dart';

class SurahListItemActionButtonPaused extends StatelessWidget {
  const SurahListItemActionButtonPaused({
    Key? key,
    required this.onAudioButonPressed,
  }) : super(key: key);

  final Function onAudioButonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onAudioButonPressed(),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          borderRadius: BorderRadius.circular(50),
          boxShadow: secondaryShadow,
          gradient: CustomColors.grey90,
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: CustomColors.greyIconGradient,
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Icon(
            CupertinoIcons.play_fill,
            size: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
