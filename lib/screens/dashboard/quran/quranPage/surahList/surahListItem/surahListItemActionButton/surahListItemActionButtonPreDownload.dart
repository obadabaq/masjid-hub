import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/theme/colors.dart';

class SurahListItemActionButtonPreDownload extends StatelessWidget {
  const SurahListItemActionButtonPreDownload({
    Key? key,
    required this.onAudioButonPressed,
  }) : super(key: key);

  final Function onAudioButonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onAudioButonPressed(),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: CustomColors.greyIconGradient,
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Icon(
            CupertinoIcons.cloud_download,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
