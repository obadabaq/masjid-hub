import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/models/ayahModel.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/ayahList/ayahTrailing.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/provider/ayahListProvider.dart';
import 'package:masjidhub/utils/ayahUtils.dart';

class AyahListItem extends StatefulWidget {
  const AyahListItem({
    Key? key,
    required this.ayahListKey,
    required this.index,
    required this.ayah,
    required this.onBookMarkButtonPressed,
    required this.isAudioPlaying,
    required this.ayahFont,
    required this.translationFont,
    required this.surahName,
    required this.surahNumber,
    required this.setTooltip,
    required this.onAyahSelect,
    required this.isAyahSelected,
    required this.isBookmarked,
    required this.scrollToAyah,
    required this.surahPageScrollController,
    this.isBismillah =
        false, // Only true for Bismillah of Surahs other then Al Fatiha
  }) : super(key: key);

  final int index;
  final AyahModel ayah;
  final bool isAudioPlaying;
  final Function onBookMarkButtonPressed;
  final FontSize ayahFont;
  final FontSize translationFont;
  final String surahName;
  final int surahNumber;
  final GlobalKey ayahListKey;
  final Function(double) setTooltip;
  final Function(int, int) onAyahSelect;
  final bool isAyahSelected;
  final bool isBookmarked;
  final int scrollToAyah;
  final ScrollController surahPageScrollController;
  final bool isBismillah;

  @override
  State<AyahListItem> createState() => _AyahListItemState();
}

class _AyahListItemState extends State<AyahListItem> {
  //ScreenshotController _screenshotController = ScreenshotController();
  GlobalKey ayahItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void clearTimeout(Timer t) => t.cancel();
  Timer setTimeout(callback, [int duration = 200]) =>
      Timer(Duration(milliseconds: duration), callback);

  void showTooltip() {
    RenderBox childBox =
        ayahItemKey.currentContext!.findRenderObject() as RenderBox;
    RenderBox parentBox =
        widget.ayahListKey.currentContext!.findRenderObject() as RenderBox;
    double tooltipPosY = QuranUtils().getTooltipPosY(parentBox, childBox);
    widget.setTooltip(tooltipPosY);
  }

  void shareAyah() async {
    try {
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;
      String fileName = 'ayah-screenshot';
      String path = '$appDocPath';

      String socialSharingText = QuranUtils().getSocialShareText(
        ayahNumber: widget.ayah.ayahNumberInSurah,
        surahNumber: widget.surahNumber,
        surahName: widget.surahName,
      );

      String copyClipboardText = QuranUtils().getCopyClipboardTest(
        ayahText: widget.ayah.text,
        ayahTranslation: widget.ayah.translation,
        ayahNumber: widget.ayah.ayahNumberInSurah,
        surahNumber: widget.surahNumber,
        surahName: widget.surahName,
      );

      // await _screenshotController.captureAndSave(path, fileName: fileName).then(
      //   (imagePath) {
      //     QuranProvider quranProvider =
      //         Provider.of<QuranProvider>(context, listen: false);
      //     quranProvider.setSocialSharingText(socialSharingText);
      //     quranProvider.setCopyClipboardAyah(copyClipboardText);
      //     quranProvider.setSocialSharingImagePath(imagePath!);
      //   },
      // );
    } catch (e) {
      print(e);
    }
  }

  void onLongPress() async {
    selectAyah();
    showTooltip();
    shareAyah();
  }

  void onShortPress() {
    deSelectAyah();
  }

  void selectAyah() =>
      widget.onAyahSelect(widget.ayah.ayahNumberInSurah, widget.surahNumber);
  void deSelectAyah() => widget.onAyahSelect(-1, widget.surahNumber);

  void scrollToHighlightedAyah(BuildContext context) {
    final AyahListProvider provider =
        Provider.of<AyahListProvider>(context, listen: false);

    final bool isAutoScrollOn =
        Provider.of<AudioProvider>(context, listen: false).autoScrollActive;

    final bool _isScrolling =
        provider.getCurrentlyScrollingIntoViewAyah == widget.ayah.id;

    if (!_isScrolling && isAutoScrollOn) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        alignment: 0.25,
      );
      provider.setCurrentlyScrollingIntoViewAyah(widget.ayah.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ayah.id == widget.scrollToAyah)
        AyahUtils().scrollToAyah(ayahItemKey, widget.surahPageScrollController);
    });

    return SizedBox();
    // return GestureDetector(
    //   behavior: HitTestBehavior.translucent,
    //   onLongPress: onLongPress,
    //   onTap: onShortPress,
    //   child: Screenshot(
    //     controller: _screenshotController,
    //     child: Container(
    //       key: ayahItemKey,
    //       padding: EdgeInsets.fromLTRB(10, widget.isBismillah ? 0 : 20, 25, 20),
    //       width: MediaQuery.of(context).size.width,
    //       decoration: widget.isAyahSelected
    //           ? BoxDecoration(
    //               color: CustomTheme.lightTheme.colorScheme.background,
    //               borderRadius: BorderRadius.circular(20),
    //               boxShadow: secondaryShadow,
    //             )
    //           : BoxDecoration(),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Selector<AyahListProvider, Tuple2<int, int>>(
    //             selector: (_, select) => Tuple2(
    //               select.ayahAudioState.currentlyPlayingAyahId,
    //               select.ayahAudioState.surahId,
    //             ),
    //             shouldRebuild: (previous, next) =>
    //                 previous.item1 == widget.ayah.ayahNumberInSurah ||
    //                 next.item1 == widget.ayah.ayahNumberInSurah,
    //             builder: (ctx, audioStateAyah, _) {
    //               final bool isHighLighted =
    //                   audioStateAyah.item1 == widget.ayah.ayahNumberInSurah &&
    //                       audioStateAyah.item2 == widget.surahNumber;
    //
    //               final Color textColor = isHighLighted
    //                   ? CustomColors.irisBlue
    //                   : CustomColors.nightRider;
    //
    //               final double fontSize =
    //                   widget.isBismillah ? 25 : widget.ayahFont.size;
    //
    //               final TextStyle quranTextStyle = TextStyle(
    //                 color: textColor,
    //                 fontSize: fontSize,
    //                 fontFamily: 'Kitab',
    //               );
    //
    //               if (isHighLighted) scrollToHighlightedAyah(context);
    //
    //               return Padding(
    //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                 child: widget.isBismillah
    //                     ? Container(
    //                         margin: EdgeInsets.only(left: 15),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(
    //                               widget.ayah.text,
    //                               maxLines: 1,
    //                               textDirection: TextDirection.rtl,
    //                               style: quranTextStyle,
    //                             ),
    //                           ],
    //                         ),
    //                       )
    //                     : RichText(
    //                         textDirection: TextDirection.rtl,
    //                         text: TextSpan(
    //                           children: [
    //                             TextSpan(
    //                               text: widget.ayah.text,
    //                               style: quranTextStyle,
    //                             ),
    //                             if (widget.isBookmarked)
    //                               WidgetSpan(
    //                                 alignment: PlaceholderAlignment.middle,
    //                                 child: Container(
    //                                   width: 20,
    //                                   margin: EdgeInsets.only(right: 5),
    //                                   child: Icon(
    //                                     CupertinoIcons.bookmark_fill,
    //                                     size: 20,
    //                                     color: CustomColors.scarlet,
    //                                   ),
    //                                 ),
    //                               ),
    //                             if (widget.index != -1)
    //                               WidgetSpan(
    //                                 alignment: PlaceholderAlignment.middle,
    //                                 child: AyahTrailing(
    //                                   ayahNumber: widget.index + 1,
    //                                   hasRuku: widget.ayah.hasRuku,
    //                                   hasSajda: widget.ayah.hasRuku,
    //                                   color: textColor,
    //                                 ),
    //                               ),
    //                           ],
    //                         ),
    //                       ),
    //               );
    //             },
    //           ),
    //           if (!widget.isBismillah)
    //             Container(
    //               alignment: Alignment.centerLeft,
    //               padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
    //               child: Text(
    //                 widget.ayah.translation,
    //                 textAlign: TextAlign.start,
    //                 style: TextStyle(
    //                   color: CustomColors.mildGrey,
    //                   fontSize: widget.translationFont.translationSize,
    //                   height: 1.6,
    //                   fontWeight: FontWeight.w200,
    //                 ),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
