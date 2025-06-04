import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItem.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:tuple/tuple.dart';

class SnappedAudioPlayer extends StatelessWidget {
  const SnappedAudioPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AudioProvider, Tuple2<AudioPlayerStateModel, int>>(
      selector: (_, select) =>
          Tuple2(select.audioState, select.currentlyPlayingSurah),
      shouldRebuild: (p, n) => p.item2 != 999 && n.item2 != 999,
      builder: (ctx, audioState, _) {
        final AudioPlayerStateModel state = audioState.item1;
        SurahModel surah =
            QuranUtils().getSurahInfoFromId(id: audioState.item2);

        int quranReciter = 0;
        String quranRecitorName = quranRecitations.elementAt(quranReciter).name;

        return SurahListItem(
          englishName: surah.englishName,
          verseCount: surah.numberOfAyahs,
          surahNumber: surah.id,
          isAudioSelected: true,
          revelationType: surah.revelationType,
          audioProgress: state.surahAudioCompletionPercentatge,
          isAudioPlayerMode: true,
          onAudioButonPressed: (state) => {},
          quranRecitorName: quranRecitorName,
        );
      },
    );
  }
}
