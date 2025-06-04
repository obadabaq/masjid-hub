import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/quran/surah/chapterIconWithNumber.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemTextColumn.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahPage.dart';

class RecentSurahItem extends StatelessWidget {
  const RecentSurahItem({
    Key? key,
    required this.state,
    required this.maxWidth,
    required this.surah,
  }) : super(key: key);

  final AudioPlayerStateModel state;
  final double maxWidth;
  final SurahModel surah;

  @override
  Widget build(BuildContext context) {
    Future<void> onSurahItemClick() async {
      await Provider.of<QuranProvider>(context, listen: false)
          .setSelectedSurah(surah.id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SurahPage(
                    contxt: context,
                    scrollToAyah: state.currentlyPlayingAyahId,
                  )));
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSurahItemClick(),
      child: Container(
        width: maxWidth,
        height: 86,
        padding: EdgeInsets.fromLTRB(40, 15, 0, 13),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChapterIconWithNumber(
                  text: surah.id.toString(),
                  size: 50,
                ),
                SurahListItemTextColumn(
                  maxWidth: maxWidth,
                  englishName: surah.englishName,
                  subText: 'Verse ${state.currentlyPlayingAyahId}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
