import 'package:flutter/cupertino.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class RemoteOnAudioControlsLoopButton extends StatelessWidget {
  const RemoteOnAudioControlsLoopButton({
    Key? key,
    required this.loopCount,
    required this.onPressed,
  }) : super(key: key);

  final int loopCount;
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
          loopCount == 2 ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat,
          size: 25,
          color: loopCount == 0 ? CustomColors.mischka : CustomColors.irisBlue,
        ),
      ),
    );
  }
}
