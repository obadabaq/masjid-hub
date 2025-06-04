import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/buttons/tooltipBookmark.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/buttons/tooltipCopy.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/buttons/tooltipDivider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/buttons/tooltipPlay.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/buttons/tooltipShare.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/tooltipWrapper.dart';
import 'package:masjidhub/theme/colors.dart';

class AyahTooltip extends StatelessWidget {
  const AyahTooltip({
    Key? key,
    required this.posY,
    required this.onAddBookmark,
    required this.surahNumber,
    required this.ayah,
  }) : super(key: key);

  final double posY;
  final Function() onAddBookmark;
  final int surahNumber;
  final int ayah;

  @override
  Widget build(BuildContext context) {
    return TooltipWrapper(
      posY: posY,
      tooltip: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.nero,
        ),
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: 50,
        child: Row(
          children: [
            TooltipPlay(surahNumber: surahNumber, ayah: ayah),
            TooltipDivider(),
            TooltipBookmark(onAddBookmark: onAddBookmark),
            TooltipDivider(),
            TooltipCopy(),
            TooltipDivider(),
            TooltipShare(),
          ],
        ),
      ),
    );
  }
}
