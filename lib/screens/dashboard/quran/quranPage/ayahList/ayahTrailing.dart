import 'package:flutter/material.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:masjidhub/common/icons/app_icons.dart';

class AyahTrailing extends StatelessWidget {
  const AyahTrailing({
    Key? key,
    required this.ayahNumber,
    required this.hasSajda,
    required this.hasRuku,
    required this.color,
  }) : super(key: key);

  final int ayahNumber;
  final bool hasSajda;
  final bool hasRuku;
  final Color color;

  @override
  Widget build(BuildContext context) {
    ArabicNumbers arabicNumber = ArabicNumbers();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (hasRuku)
          Container(
            width: 30,
            margin: EdgeInsets.only(right: hasSajda ? 0 : 10, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.ruku,
                  size: 15,
                  color: color,
                ),
              ],
            ),
          ),
        Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: hasSajda ? 0 : 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: color),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 3),
              child: AutoSizeText(
                arabicNumber.convert(ayahNumber),
                style: TextStyle(color: color),
                maxFontSize: 20,
                minFontSize: 5,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
