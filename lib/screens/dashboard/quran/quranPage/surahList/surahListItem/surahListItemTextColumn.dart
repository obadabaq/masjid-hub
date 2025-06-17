import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:masjidhub/theme/colors.dart';

class SurahListItemTextColumn extends StatelessWidget {
  const SurahListItemTextColumn({
    Key? key,
    required this.maxWidth,
    required this.englishName,
    required this.subText,
  }) : super(key: key);

  final double maxWidth;
  final String englishName;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: maxWidth - 190,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              englishName,
              style: TextStyle(
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: CustomColors.blackPearl,
              ),
              minFontSize: 12,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            AutoSizeText(
              subText,
              style: TextStyle(
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w400,
                color: CustomColors.blackPearl.withValues(alpha: 0.7),
              ),
              minFontSize: 10,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
