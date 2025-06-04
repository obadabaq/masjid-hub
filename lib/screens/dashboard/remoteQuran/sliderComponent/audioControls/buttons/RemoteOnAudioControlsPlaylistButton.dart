import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RemoteOnAudioControlsPlaylistButton extends StatelessWidget {
  const RemoteOnAudioControlsPlaylistButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: CustomTheme.lightTheme.colorScheme.background,
          borderRadius: BorderRadius.circular(50),
          boxShadow: secondaryShadow,
          gradient: CustomColors.grey90,
        ),
        child: Icon(
          Icons.playlist_play,
          size: 25,
          color: CustomColors.mischka,
        ),
      ),
    );
  }
}
