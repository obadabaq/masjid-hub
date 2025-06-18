import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/constants/quranMeta.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahList.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/screens/dashboard/quran/bookmarksPage/noBookmarks.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({Key? key}) : super(key: key);

  static List<SurahModel> quranMeta =
      QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => FutureBuilder(
        future: quran.getBookmarks(),
        initialData: quran.bookmarks,
        builder: (BuildContext context,
            AsyncSnapshot<List<BookmarkModel>> snapshot) {
          if (snapshot.data!.isEmpty) return NoBookmarks();

          if (snapshot.hasData) {
            List<SurahModel> surahList =
                snapshot.data!.map<SurahModel>((bookmark) {
              SurahModel oldSurah =
                  quranMeta.firstWhere((el) => el.id == bookmark.surah);

              SurahModel newSurah =
                  QuranUtils().createNewSurahWithbookmark(bookmark, oldSurah);
              return newSurah;
            }).toList();

            return Padding(
              padding: EdgeInsets.only(bottom: 10, top: 50),
              child: SurahList(
                list: surahList,
                quranRecitorId: quran.quranReciter,
                surahCompleted: quran.surahCompleted,
                audioPlayer: quran.audioPlayer,
                hidePlayButton: true,
              ),
            );
          }

          return Container(
            margin: EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
