import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:masjidhub/models/ayahModel.dart';
import 'package:masjidhub/constants/quran.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/models/quran/editionModel.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/ayahListItem.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';
import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/utils/quranUtils.dart';

class AyahList extends StatefulWidget {
  const AyahList({
    required this.list,
    required this.quranRecitorId,
    required this.ayahFont,
    required this.translationFont,
    required this.surahName,
    required this.surahNumber,
    required this.setTooltip,
    required this.onAyahSelect,
    required this.selectedAyah,
    required this.bookmarks,
    required this.scrollToAyah,
    required this.surahPageScrollController,
    this.bismillahTranslationText,
    Key? key,
  }) : super(key: key);

  final List<AyahModel> list;
  final int quranRecitorId;
  final FontSize ayahFont;
  final FontSize translationFont;
  final String surahName;
  final int surahNumber;
  final Function(double) setTooltip;
  final Function(int, int) onAyahSelect;
  final int selectedAyah;
  final List<BookmarkModel> bookmarks;
  final int scrollToAyah;
  final ScrollController surahPageScrollController;
  final String? bismillahTranslationText;

  @override
  _AyahListState createState() => _AyahListState();
}

class _AyahListState extends State<AyahList> {
  GlobalKey ayahListKey = GlobalKey();

  static int? selectedSurahAudioId;
  static AudioPlayer audioPlayer = AudioPlayer();

  // Maybe this is deprecated
  Future<void> onBookMarkButtonPressed(id) async {
    if (selectedSurahAudioId == id) {
      audioPlayer.pause();
    } else {
      final EditionModel audioDetails =
          quranRecitations.elementAt(widget.quranRecitorId);
      final recitor = audioDetails.identifier;
      final bitrate = audioDetails.bitrate;
      audioPlayer.play(AssetSource('$quranAudioApiBaseUrl/$bitrate/$recitor/$id.mp3'));
    }
    setState(() {
      if (selectedSurahAudioId == id) return selectedSurahAudioId = null;
      selectedSurahAudioId = id;
    });
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        selectedSurahAudioId = null;
      });
    });

    return ListView.builder(
        key: ayahListKey,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 200),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int i) {
          final bool isSurahFatiha = widget.list[i].id == 1;

          final String quranText = widget.list[i].text;

          // This was a bug from the Quran text api, it usually starts with Bissmillah before first Ayah text.
          final bool containsBissmillah = quranText.contains(bismillah);

          if (i == 0)
            return Column(
              children: [
                AyahListItem(
                  ayahListKey: ayahListKey,
                  index: isSurahFatiha ? 0 : -1,
                  onBookMarkButtonPressed: (id) => onBookMarkButtonPressed(1),
                  ayah: AyahModel(
                    id: widget.list[i].id,
                    text: bismillah,
                    translation: widget.bismillahTranslationText ??
                        tr("bismillahTranslation"),
                    hasRuku: widget.list[i].hasRuku,
                    hasSajda: widget.list[i].hasSajda,
                    ayahNumberInSurah: isSurahFatiha ? 1 : 0,
                  ),
                  isAudioPlaying: selectedSurahAudioId == 1,
                  ayahFont: widget.ayahFont,
                  translationFont: widget.translationFont,
                  surahNumber: widget.surahNumber,
                  surahName: widget.surahName,
                  setTooltip: widget.setTooltip,
                  onAyahSelect: widget.onAyahSelect,
                  isAyahSelected:
                      isSurahFatiha ? (widget.selectedAyah - 1) == i : false,
                  isBookmarked: isSurahFatiha
                      ? QuranUtils().isAyahBookMarked(
                          surahNumber: widget.surahNumber,
                          ayahInSurah: 1,
                          bookmarks: widget.bookmarks,
                        )
                      : false,
                  scrollToAyah: widget.scrollToAyah,
                  surahPageScrollController: widget.surahPageScrollController,
                  isBismillah: isSurahFatiha
                      ? false
                      : true, // Only true for Bismillah of Surahs other then Al Fatiha
                ),
                if (!isSurahFatiha)
                  AyahListItem(
                    ayahListKey: ayahListKey,
                    index: i,
                    onBookMarkButtonPressed: (id) =>
                        onBookMarkButtonPressed(id),
                    ayah: AyahModel(
                      id: widget.list[i].id,
                      text: containsBissmillah
                          ? quranText.split(bismillah)[1]
                          : quranText,
                      translation: widget.list[i].translation.trim(),
                      hasRuku: widget.list[i].hasRuku,
                      hasSajda: widget.list[i].hasSajda,
                      ayahNumberInSurah: 1,
                    ),
                    isAudioPlaying: widget.list[i].id == selectedSurahAudioId,
                    ayahFont: widget.ayahFont,
                    translationFont: widget.translationFont,
                    surahNumber: widget.surahNumber,
                    surahName: widget.surahName,
                    setTooltip: widget.setTooltip,
                    onAyahSelect: widget.onAyahSelect,
                    isAyahSelected: (widget.selectedAyah - 1) == i,
                    isBookmarked: QuranUtils().isAyahBookMarked(
                      surahNumber: widget.surahNumber,
                      ayahInSurah: 1,
                      bookmarks: widget.bookmarks,
                    ),
                    scrollToAyah: widget.scrollToAyah,
                    surahPageScrollController: widget.surahPageScrollController,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(thickness: 1.5),
                ),
              ],
            );

          return Column(
            children: [
              AyahListItem(
                ayahListKey: ayahListKey,
                index: i,
                onBookMarkButtonPressed: (id) => onBookMarkButtonPressed(id),
                ayah: AyahModel(
                  id: widget.list[i].id,
                  text: quranText,
                  translation: widget.list[i].translation,
                  hasRuku: widget.list[i].hasRuku,
                  hasSajda: widget.list[i].hasSajda,
                  ayahNumberInSurah: widget.list[i].ayahNumberInSurah,
                ),
                isAudioPlaying: widget.list[i].id == selectedSurahAudioId,
                ayahFont: widget.ayahFont,
                translationFont: widget.translationFont,
                surahNumber: widget.surahNumber,
                surahName: widget.surahName,
                setTooltip: widget.setTooltip,
                onAyahSelect: widget.onAyahSelect,
                isAyahSelected: (widget.selectedAyah - 1) == i,
                isBookmarked: QuranUtils().isAyahBookMarked(
                  surahNumber: widget.surahNumber,
                  ayahInSurah: widget.list[i].ayahNumberInSurah,
                  bookmarks: widget.bookmarks,
                ),
                scrollToAyah: widget.scrollToAyah,
                surahPageScrollController: widget.surahPageScrollController,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(thickness: 1.5),
              ),
            ],
          );
        });
  }
}
