import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/theme/colors.dart';

class ChapterIconWithNumber extends StatelessWidget {
  const ChapterIconWithNumber({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          AppIcons.chapterNumber,
          size: size,
          color: CustomColors.blackPearl,
        ),
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return AutoSizeText(
                text,
                style: TextStyle(
                  fontSize: size * 0.4,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.blackPearl,
                ),
                maxFontSize: size * 0.5,
                maxLines: 1,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ],
    );
  }
}
