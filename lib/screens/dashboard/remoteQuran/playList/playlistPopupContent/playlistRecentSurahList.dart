import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/quranMeta.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItem.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class PlaylistRecentSurahList extends StatelessWidget {
  const PlaylistRecentSurahList({Key? key}) : super(key: key);

  static List<SurahModel> quranMeta =
      QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));

  Future<int> getRecentSurahId() async {
    return SharedPrefs().getRemoteOnRecentSurah;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRecentSurahId(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          final int remoteOnRecentSurah = snapshot.data ?? 0;
          final bool noRecentSurah = remoteOnRecentSurah == 0;

          if (noRecentSurah)
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                tr('noRecentSurah'),
                style: TextStyle(
                  color: CustomColors.blackPearl.withValues(alpha: 0.7),
                  fontSize: 20,
                  height: 1.3,
                ),
              ),
            );

          final SurahModel surah =
              quranMeta.firstWhere((el) => el.id == remoteOnRecentSurah);

          return SurahListItem(
            englishName: surah.englishName,
            verseCount: surah.numberOfAyahs,
            surahNumber: surah.id,
            isAudioSelected: false,
            revelationType: surah.revelationType,
            audioProgress: 0,
            onAudioButonPressed: (state) => {},
            isRemoteOn: true,
            scrollPosition: 0,
          );
        }
        return SizedBox(height: 0);
      },
    );
  }
}
