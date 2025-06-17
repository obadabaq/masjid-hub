import 'package:flutter/material.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/theme/colors.dart';

class DownloadingQuran extends StatelessWidget {
  const DownloadingQuran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // todo find alternative
        // LinearProgressIndicator(color: CustomColors.irisBlue),
        SizedBox(height: 50),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: CustomColors.greyIconGradient,
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Icon(
            AppIcons.quranIcon,
            size: 100.0,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, bottom: 15),
          child: Text(
            'Downloading Quran',
            style: TextStyle(
              color: CustomColors.blackPearl,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          'This will help you read quran offline',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CustomColors.blackPearl.withValues(alpha: 0.7),
            fontSize: 20,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
