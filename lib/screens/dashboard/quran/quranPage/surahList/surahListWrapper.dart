import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahList.dart';

class SurahListWrapper extends StatelessWidget {
  const SurahListWrapper({
    Key? key,
    this.isRemoteOn = false,
  }) : super(key: key);

  final bool? isRemoteOn;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => SingleChildScrollView(
        child: Column(
          children: [
            SurahList(
              list: quran.quranMeta,
              quranRecitorId: quran.quranReciter,
              surahCompleted: quran.surahCompleted,
              audioPlayer: quran.audioPlayer,
              isRemoteOn: isRemoteOn,
            ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
