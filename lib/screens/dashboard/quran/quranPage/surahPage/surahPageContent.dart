import 'package:flutter/material.dart';
import 'package:masjidhub/provider/quranFontProvider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/models/quranChapterModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/header/surahPageHeader.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/ayahListWrapper.dart';
import 'package:masjidhub/common/loader/loader.dart';

class SurahPageContent extends StatefulWidget {
  const SurahPageContent({
    Key? key,
    this.scrollPosition = 0,
    required this.scrollToAyah,
    required this.onSurahChanged,
  }) : super(key: key);

  final double scrollPosition;
  final int scrollToAyah;
  final Function onSurahChanged;

  @override
  State<SurahPageContent> createState() => _SurahPageContentState();
}

class _SurahPageContentState extends State<SurahPageContent> {
  ScrollController surahPageScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    surahPageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AudioProvider>(context, listen: false).switchOffAutoScroll();
      surahPageScrollController.animateTo(
        widget.scrollPosition,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });

    Future<QuranChapterModel> getSurah(int surah) async =>
        await Provider.of<QuranProvider>(context, listen: false)
            .getChapterData(id: surah, context: context);

    return Selector<QuranProvider, Tuple2<int, String>>(
      selector: (_, selector) =>
          Tuple2(selector.getSelectedSurah, selector.quranTranslationText),
      builder: (ctx, selectedSurah, _) {
        return ListView(
          controller: surahPageScrollController,
          children: [
            FutureBuilder(
              future: getSurah(selectedSurah.item1),
              builder: (BuildContext context,
                  AsyncSnapshot<QuranChapterModel> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done)
                  return Column(
                    children: [
                      SurahPageHeader(
                        chapter: snapshot.data,
                        onSurahChanged: widget.onSurahChanged,
                      ),
                      Consumer<QuranFontProvider>(
                        builder: (ctx, font, _) => AyahListWrapper(
                          list: snapshot.data!.ayahs,
                          quranRecitorId: snapshot.data!.quranRecitorId,
                          ayahFont: font.surahFontSize,
                          translationFont: font.translationFontSize,
                          surahNumber: snapshot.data!.id,
                          surahName: snapshot.data!.chapterName,
                          surahPageScrollController: surahPageScrollController,
                          scrollToAyah: widget.scrollToAyah,
                        ),
                      ),
                    ],
                  );

                return Loader();
              },
            ),
          ],
        );
      },
    );
  }
}
