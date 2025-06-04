import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/recentSurahUtils.dart';
import 'package:masjidhub/provider/ayahListProvider.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/recentSurah/recentSurahItem.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/utils/quranUtils.dart';

class RecentSurah extends StatelessWidget {
  const RecentSurah({
    required this.isSearchActive,
    required this.maxWidth,
    Key? key,
  }) : super(key: key);

  final bool isSearchActive;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AyahListProvider>(context, listen: false)
            .getRecentSurahAudioState(),
        builder: (BuildContext context,
            AsyncSnapshot<AudioPlayerStateModel> snapshot) {
          bool showRecentSurah = false;
          late SurahModel surah;

          if (snapshot.hasData) {
            AudioPlayerStateModel recentState = snapshot.data!;

            int ayahPlaying = recentState.currentlyPlayingAyahId;
            int progress = recentState.surahAudioCompletionPercentatge;

            if (ayahPlaying != 0) {
              surah = QuranUtils().getSurahInfoFromId(id: recentState.surahId);
              int numberOfAyahsInSurah = surah.numberOfAyahs;

              showRecentSurah = RecentSurahUtils().shouldShowRecentSurah(
                ayahPlaying,
                progress,
                numberOfAyahsInSurah,
              );
            }

            if (showRecentSurah && !isSearchActive)
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 40, bottom: 0),
                          child: Text(
                            tr('recent'),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: CustomColors.mischka,
                            ),
                          ),
                        ),
                        RecentSurahItem(
                          state: recentState,
                          maxWidth: maxWidth,
                          surah: surah,
                        ),
                      ],
                    )
                  ],
                ),
              );
          }

          return SizedBox(height: 0);
        });
  }
}
