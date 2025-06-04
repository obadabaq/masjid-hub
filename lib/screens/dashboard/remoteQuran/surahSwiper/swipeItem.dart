import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/quranUtils.dart';

class SwipeItem extends StatelessWidget {
  const SwipeItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    SurahModel surahInfo = QuranUtils().getSurahInfoFromId(id: index + 1);
    String surahName = surahInfo.englishName;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: CustomColors.solitude,
        boxShadow: tertiaryShadowAppBar,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Container(
          child: AutoSizeText(
            surahName,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: CustomColors.blackPearl,
            ),
            minFontSize: 25,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
