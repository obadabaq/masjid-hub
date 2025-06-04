import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemContent.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahPage.dart';

class SurahListItem extends StatelessWidget {
  const SurahListItem({
    Key? key,
    required this.englishName,
    required this.verseCount,
    required this.surahNumber,
    required this.isAudioSelected,
    required this.onAudioButonPressed,
    required this.revelationType,
    this.isAudioPlayerMode = false,
    this.audioProgress = 0,
    this.quranRecitorName = '',
    this.bookmarkedAyah,
    this.scrollPosition = 0,
    this.isRecent = false,
    this.currentlyPlayedAyah = 0,
    this.isRemoteOn = false,
    this.hidePlayButton = false,
  }) : super(key: key);

  final String englishName;
  final int verseCount;
  final int surahNumber;
  final bool isAudioSelected;
  final String revelationType;
  final Function(SurahListActionButtonState) onAudioButonPressed;
  final int audioProgress;
  final bool isAudioPlayerMode;
  final String quranRecitorName;
  final int? bookmarkedAyah;
  final double scrollPosition;
  // For Recent Ayah
  final bool isRecent;
  final int currentlyPlayedAyah;
  final bool? isRemoteOn;
  final bool? hidePlayButton;

  @override
  Widget build(BuildContext context) {
    Future<void> onSurahItemClick() async {
      if (!isRemoteOn!) {
        await Provider.of<QuranProvider>(context, listen: false)
            .setSelectedSurah(surahNumber);

        final bool isAudioPlaying =
            Provider.of<AudioProvider>(context, listen: false)
                    .audioPlayer
                    .state ==
                PlayerState.playing;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SurahPage(
                      contxt: context,
                      scrollPosition: scrollPosition,
                      showSurahPageMediaPlayer: isAudioPlaying,
                    )));
      }
    }

    bool isBookMarkMode = bookmarkedAyah != null;

    String getSubText() {
      if (isAudioPlayerMode) {
        return tr(quranRecitorName);
      } else if (isBookMarkMode) {
        return 'verse'.tr(args: ['$bookmarkedAyah']);
      } else if (isRecent) {
        return 'verse'.tr(args: ['$currentlyPlayedAyah']);
      } else {
        return 'verses'
            .tr(args: ['$revelationType', '${verseCount.toString()}']);
      }
    }

    final BoxDecoration decoration = isAudioSelected
        ? BoxDecoration(
            color: CustomTheme.lightTheme.colorScheme.background,
            borderRadius: BorderRadius.circular(25),
            boxShadow: secondaryShadow,
          )
        : BoxDecoration();

    final double bottomPadding = isAudioSelected ? 0 : 13;
    final double topMargin = isAudioSelected ? 5 : 10;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: 86,
          decoration: decoration,
          padding: EdgeInsets.fromLTRB(20, 15, 20, bottomPadding),
          margin: EdgeInsets.fromLTRB(20, topMargin, 20, 10),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: !isAudioPlayerMode ? () => onSurahItemClick() : null,
            child: SurahListItemContent(
              surahNumber: surahNumber,
              englishName: englishName,
              onAudioButonPressed: onAudioButonPressed,
              isAudioSelected: isAudioSelected,
              audioProgress: audioProgress,
              maxWidth: constraints.maxWidth,
              subText: getSubText(),
              isRecent: isRecent,
              isAudioPlayerMode: isAudioPlayerMode,
              hidePlayButton: hidePlayButton,
            ),
          ),
        );
      },
    );
  }
}
