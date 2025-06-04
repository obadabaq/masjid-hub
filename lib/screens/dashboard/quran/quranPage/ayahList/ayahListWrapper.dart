import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/models/ayahModel.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/common/loader/loader.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/ayahList.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/tooltip/ayahTooltip.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:tuple/tuple.dart';

class AyahListWrapper extends StatefulWidget {
  const AyahListWrapper({
    required this.list,
    required this.quranRecitorId,
    required this.ayahFont,
    required this.translationFont,
    required this.surahName,
    required this.surahNumber,
    required this.surahPageScrollController,
    required this.scrollToAyah,
    Key? key,
  }) : super(key: key);

  final List<AyahModel> list;
  final int quranRecitorId;
  final FontSize ayahFont;
  final FontSize translationFont;
  final String surahName;
  final int surahNumber;
  final ScrollController surahPageScrollController;
  final int scrollToAyah;

  @override
  State<AyahListWrapper> createState() => _AyahListWrapperState();
}

class _AyahListWrapperState extends State<AyahListWrapper> {
  double _tooltipPosY = 100;
  void setTooltip(double posY) => setState(() => _tooltipPosY = posY);

  int _selectedAyah = -1;
  late BookmarkModel _selectedBookmark;

  void selectAyah(int ayahId, int surahNumber) {
    final BookmarkModel bookm = BookmarkModel(
      ayah: ayahId,
      surah: surahNumber,
      scrollPosition: widget.surahPageScrollController.position.pixels,
    );
    setState(() {
      _selectedAyah = ayahId;
      _selectedBookmark = bookm;
    });
  }

  List<BookmarkModel> bookmarks = [];

  void addBookmarks() {
    List<BookmarkModel> newList =
        QuranUtils().sanitizeAndAddBookmark(_selectedBookmark, bookmarks);
    setState(() => bookmarks = newList);
    Provider.of<QuranProvider>(context, listen: false).setBookmarkList(newList);
  }

  void initBookmarks() async {
    List<BookmarkModel> bookmarksList =
        await Provider.of<QuranProvider>(context, listen: false).getBookmarks();
    setState(() => bookmarks = bookmarksList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initBookmarks();
  }

  Future<Tuple2<List<BookmarkModel>, String>>
      getBookMarksAndBissmillahText() async {
    final QuranProvider quranProvider =
        Provider.of<QuranProvider>(context, listen: false);

    final bismillahTranslationText = quranProvider.getBismillahText;

    if (bookmarks.length == 0) {
      List<BookmarkModel> bookmarksfromProvider =
          await Provider.of<QuranProvider>(context, listen: false)
              .getBookmarks();
      return Tuple2(bookmarksfromProvider, bismillahTranslationText);
    } else {
      return Tuple2(bookmarks, bismillahTranslationText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: getBookMarksAndBissmillahText(),
          builder: (BuildContext context,
              AsyncSnapshot<Tuple2<List<BookmarkModel>, String>> snapshot) {
            if (snapshot.hasData)
              return AyahList(
                list: widget.list,
                quranRecitorId: widget.quranRecitorId,
                ayahFont: widget.ayahFont,
                translationFont: widget.translationFont,
                surahNumber: widget.surahNumber,
                surahName: widget.surahName,
                setTooltip: setTooltip,
                onAyahSelect: selectAyah,
                selectedAyah: _selectedAyah,
                bookmarks: snapshot.data!.item1,
                bismillahTranslationText: snapshot.data!.item2,
                scrollToAyah: widget.scrollToAyah,
                surahPageScrollController: widget.surahPageScrollController,
              );

            return Loader();
          },
        ),
        Visibility(
          visible: _selectedAyah > 0,
          child: AyahTooltip(
            posY: _tooltipPosY,
            onAddBookmark: addBookmarks,
            surahNumber: widget.surahNumber,
            ayah: _selectedAyah,
          ),
        )
      ],
    );
  }
}
