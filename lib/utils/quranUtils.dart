import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/languages.dart';
import 'package:masjidhub/constants/quran.dart';
import 'package:masjidhub/constants/quranMeta.dart';
import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/models/ayahModel.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/models/quran/editionModel.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/models/quranChapterModel.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';

class QuranUtils {
  String editionQueryToString(EditionModel edition) {
    return 'format=${edition.language}&&';
  }

  List<EditionModel> parseEditions(String responseBody) {
    final result = json.decode(responseBody);
    return result['data']
        .map<EditionModel>((edition) => EditionModel(
              identifier: edition['identifier'],
              name: edition['englishName'],
              language: edition['language'],
              format: edition['format'],
            ))
        .toList();
  }

  bool isEndOfRuku(nextRukuNumber, currentRukuNumber) =>
      nextRukuNumber != currentRukuNumber;

  List<AyahModel> parseAyahData({
    required dynamic surah,
    required List<BookmarkModel> bookMarks,
    required int chapterId,
  }) {
    final quranTextList = surah[0]['ayahs'];
    final quranTranslation = surah[1]['ayahs'];

    return [
      for (int i = 0; i < quranTextList.length; i++)
        AyahModel(
          id: quranTextList[i]['number'],
          text: quranTextList[i]['text'],
          translation: quranTranslation[i]['text'],
          hasRuku: i == quranTextList.length - 1
              ? false
              : isEndOfRuku(
                  quranTextList[i + 1]['ruku'], quranTextList[i]['ruku']),
          hasSajda: quranTextList[i]['sajda'] != false,
          ayahNumberInSurah: quranTextList[i]['numberInSurah'],
        )
    ];
  }

  QuranChapterModel parseChapterData({
    required String quranTextData,
    required String quranTranslationData,
    required int quranRecitorId,
    required int chapterId,
    required List<BookmarkModel> bookMarks,
  }) {
    final int chapterIndex = chapterId - 1;

    final parsedQuranText = json.decode(quranTextData);
    final surah = parsedQuranText['data']['surahs'][chapterIndex];

    final parsedQuranTranslation = json.decode(quranTranslationData);
    final surahTranslation =
        parsedQuranTranslation['data']['surahs'][chapterIndex];

    final List<AyahModel> ayahs = parseAyahData(
      surah: [surah, surahTranslation],
      bookMarks: bookMarks,
      chapterId: chapterId,
    );

    return QuranChapterModel(
      id: surah['number'],
      chapterName: surah['englishName'],
      chapterNameMeaning: surah['englishNameTranslation'],
      ayahs: ayahs,
      quranRecitorId: quranRecitorId,
    );
  }

  List<SurahModel> parseQuranMeta(String responseBody) {
    final result = json.decode(responseBody);
    final List surahList = result['data']['surahs']['references'];
    final List<SurahModel> finalList = [];

    // initial Ayah number
    int cummulativeAyahs = 1;

    for (var i = 0; i < numberOfSurahs; i += 1) {
      cummulativeAyahs = i != 0
          ? cummulativeAyahs + surahList[i - 1]['numberOfAyahs'] as int
          : cummulativeAyahs;

      finalList.add(
        SurahModel(
          id: surahList[i]['number'] as int,
          revelationType: surahList[i]['revelationType'] as String,
          name: surahList[i]['name'] as String,
          englishName: surahList[i]['englishName'] as String,
          englishNameTranslation:
              surahList[i]['englishNameTranslation'] as String,
          numberOfAyahs: surahList[i]['numberOfAyahs'] as int,
          startAyahNumber: cummulativeAyahs,
        ),
      );
    }

    return finalList;
  }

  int getSurahPercentage(
          int currentAyahPlaying, int startAyahNumber, int totalAyahs) =>
      ((currentAyahPlaying + 1) - startAyahNumber) * 100 ~/ totalAyahs;

  SurahModel getSurahInfoFromId({int id = 1}) {
    int tempId = id == 999 ? 1 : id; // This is a hacky fix
    List<SurahModel> quranMeta =
        QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));

    return quranMeta.firstWhere((list) => list.id == tempId);
  }

  int getUpcomingSurahId(ToggleAction action, int surahId) {
    final bool isLastSurah = surahId == lastSurahId;
    final bool isFirstSurah = surahId == firstSurahId;

    if (action == ToggleAction.next) {
      return isLastSurah ? 1 : surahId + 1;
    } else {
      return isFirstSurah ? lastSurahId : surahId - 1;
    }
  }

  FontSize? parseSurahFontSize(int? id) {
    if (id == null) return null;
    return FontSize.values.elementAt(id);
  }

  String getSocialShareText({
    required int ayahNumber,
    required int surahNumber,
    required String surahName,
  }) {
    return '$surahName, Ayah $ayahNumber ($surahNumber:$ayahNumber)   MasjidHub by Takva';
  }

  String getCopyClipboardTest({
    required String ayahText,
    required String ayahTranslation,
    required int ayahNumber,
    required int surahNumber,
    required String surahName,
  }) {
    return '$ayahText' +
        "\n\n" +
        '$ayahTranslation' +
        "\n\n" +
        '$surahName, Ayah $ayahNumber ($surahNumber:$ayahNumber)' +
        "\n\n" +
        'MasjidHub by Takva';
  }

  double getTooltipPosY(RenderBox parent, RenderBox child) {
    Offset childPos = child.localToGlobal(Offset.zero);
    double childPosY = childPos.dy;

    Offset parentPos = parent.localToGlobal(Offset.zero);
    double parentPosY = parentPos.dy;

    return childPosY - parentPosY;
  }

  List<BookmarkModel>? decodeBookmarks(String? jsonList) {
    if (jsonList == null) return null;
    final result = json.decode(jsonList);
    return result
        .map<BookmarkModel>((bookmark) => BookmarkModel(
              surah: bookmark['surah'],
              ayah: bookmark['ayah'],
              scrollPosition: bookmark['scrollPosition'],
            ))
        .toList();
  }

  List<BookmarkModel> sanitizeAndAddBookmark(
      BookmarkModel bookmark, List<BookmarkModel> list) {
    final List<BookmarkModel> newList = list;
    int duplicateBookmarkIndex = list.indexWhere(
        (el) => el.ayah == bookmark.ayah && el.surah == bookmark.surah);

    bool isBookMarkDuplicate = !duplicateBookmarkIndex.isNegative;

    if (isBookMarkDuplicate) {
      newList.removeAt(duplicateBookmarkIndex);
      return newList;
    }

    newList.insert(0, bookmark);
    return newList;
  }

  SurahModel createNewSurahWithbookmark(
      BookmarkModel bookmark, SurahModel oldSurah) {
    return SurahModel(
      bookmarkedAyah: bookmark.ayah,
      id: oldSurah.id,
      name: oldSurah.name,
      englishName: oldSurah.englishName,
      englishNameTranslation: oldSurah.englishNameTranslation,
      numberOfAyahs: oldSurah.numberOfAyahs,
      revelationType: oldSurah.revelationType,
      startAyahNumber: oldSurah.startAyahNumber,
      bookmarkedScrollPosition: bookmark.scrollPosition,
    );
  }

  bool isAyahBookMarked({
    required int surahNumber,
    required int ayahInSurah,
    required List<BookmarkModel> bookmarks,
  }) {
    return bookmarks.any(
        (bookm) => bookm.surah == surahNumber && bookm.ayah == ayahInSurah);
  }

  List<int>? decodeDownloadedSurahs(String? jsonList) {
    if (jsonList == null) return null;
    final result = json.decode(jsonList);
    return result.map<int>((el) => el as int).toList();
  }

  String getLocalePath(String edition) => 'assets/quran/$edition.json';

  String getQuranTranslationPath(String currentLocale) {
    switch (currentLocale.toUpperCase()) {
      case 'TR':
        return getLocalePath('tr.diyanet');
      case 'DE':
        return getLocalePath('de.aburida');
      case 'FR':
        return getLocalePath('fr.hamidullah');
      case 'US':
      default:
        return getLocalePath('en.asad');
    }
  }

  String getRemoteOffRecitor(int id) {
    // int recitorId = SharedPrefs().getSelectedQuranRecitor;
    return quranRecitations.elementAt(id).name;
  }

  String getBissmillahText(String surahTranslationLanguage) {
    switch (surahTranslationLanguage.toUpperCase()) {
      case 'TR':
        return "Rahman ve Rahim olan Allah'ın adıyla:";
      case 'DE':
        return "Im Namen Allahs, des Allerbarmers, des Barmherzigen!";
      case 'FR':
        return "Au nom d’Allah, le Tout Clément, le Tout Miséricordieux.";
      case 'US':
      default:
        return "In the name of God, the Most Gracious, the Most Merciful";
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String getSurahTranslationName(String surahTranslationLanguage) {
    final String name = languages
        .firstWhere((el) => el.locale.countryCode == surahTranslationLanguage)
        .title;

    return capitalize(name);
  }
}
