import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RemoteOnAudioControlsSeekButton extends StatelessWidget {
  const RemoteOnAudioControlsSeekButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          borderRadius: BorderRadius.circular(50),
          boxShadow: secondaryShadow,
          gradient: CustomColors.grey90,
        ),
        child: Icon(
          icon,
          size: 25,
          color: CustomColors.mischka,
        ),
      ),
    );
  }
}
