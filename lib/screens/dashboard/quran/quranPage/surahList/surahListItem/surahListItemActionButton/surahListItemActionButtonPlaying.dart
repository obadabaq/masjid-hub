import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/constants/shadows.dart';

class SurahListItemActionButtonPlaying extends StatelessWidget {
  const SurahListItemActionButtonPlaying({
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
            boxShadow: shadowNeuPressed,
            gradient: CustomColors.primary90,
          ),
          child: Icon(
            Icons.pause,
            size: 23,
            color: Colors.white,
          )),
    );
  }
}
