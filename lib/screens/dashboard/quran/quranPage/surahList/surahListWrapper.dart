import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahList.dart';

class SurahListWrapper extends StatelessWidget {
  const SurahListWrapper({
    Key? key,
    this.isRemoteOn = false,
    this.topWidget,
    this.scrollController,
  }) : super(key: key);

  final bool? isRemoteOn;
  final Widget? topWidget;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => SurahList(
        list: quran.quranMeta,
        quranRecitorId: quran.quranReciter,
        surahCompleted: quran.surahCompleted,
        audioPlayer: quran.audioPlayer,
        isRemoteOn: isRemoteOn,
        scrollController: scrollController,
        topWidget: topWidget,
      ),
    );
  }
}
