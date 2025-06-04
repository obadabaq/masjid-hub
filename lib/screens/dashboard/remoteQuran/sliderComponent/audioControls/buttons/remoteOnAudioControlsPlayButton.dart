import 'package:flutter/cupertino.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RemoteOnAudioControlsPlayButton extends StatelessWidget {
  const RemoteOnAudioControlsPlayButton({
    Key? key,
    required this.onPressed,
    required this.isPlaying,
  }) : super(key: key);

  final Function() onPressed;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          borderRadius: BorderRadius.circular(50),
          boxShadow: secondaryShadow,
          gradient: CustomColors.grey90,
        ),
        child: Icon(
          isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
          size: 30,
          color: CustomColors.mischka,
        ),
      ),
    );
  }
}
