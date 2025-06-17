import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/utils/audioUtils.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/models/audio/surahAudioState.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';
import 'package:masjidhub/common/quran/surah/chapterIconWithNumber.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/lineraProgressIndicator.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemActionButton/surahListItemActionButton.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemTextColumn.dart';

class SurahListItemContent extends StatelessWidget {
  const SurahListItemContent({
    Key? key,
    required this.surahNumber,
    required this.englishName,
    required this.onAudioButonPressed,
    required this.isAudioSelected,
    required this.audioProgress,
    required this.maxWidth,
    required this.subText,
    required this.isRecent,
    this.isAudioPlayerMode = false, // snapped audio player on surah list
    this.hidePlayButton = false,
  }) : super(key: key);

  final int surahNumber;
  final String englishName;
  final Function(SurahListActionButtonState) onAudioButonPressed;
  final bool isAudioSelected;
  final int audioProgress;
  final double maxWidth;
  final String subText;
  final bool isRecent;
  final bool isAudioPlayerMode;
  final bool? hidePlayButton;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AudioProvider>(context, listen: false)
          .initQuranAudioState(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Selector<AudioProvider, List<SurahAudioState>>(
          selector: (_, select) => select.quranAudioState,
          shouldRebuild: (p, n) =>
              AudioUtils().shouldRebuild(p, n, surahNumber),
          builder: (ctx, audioStateList, _) {
            final SurahAudioState audioState =
                AudioUtils().getState(surahNumber, audioStateList);

            Future<void> handlePress() async {
              BleProvider bleProvider =
                  Provider.of<BleProvider>(context, listen: false);
              bool isRemoteOn = bleProvider.isRemoteOn;

              if (isRemoteOn) {
                Navigator.pop(context);
                bleProvider.onPlaylistPlayPress(surahNumber, 0, 10);
              } else if (isRecent) {
                onAudioButonPressed(audioState.state);
              } else {
                // if (isAudioPlayerMode) {
                //   Provider.of<QuranProvider>(context, listen: false)
                //       .setAudioItemVisibility(
                //           true); // slide out the bottom player on surah list
                // }
                Provider.of<AudioProvider>(context, listen: false)
                    .onAudioActionPressed(surahNumber);
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ChapterIconWithNumber(
                          text: surahNumber.toString(),
                          size: 50,
                        ),
                        SurahListItemTextColumn(
                          maxWidth: maxWidth,
                          englishName: englishName,
                          subText: subText,
                        ),
                      ],
                    ),
                    if (hidePlayButton == null || hidePlayButton == false)
                      SurahListItemActionButton(
                        surahNumber: surahNumber,
                        onAudioButonPressed: handlePress,
                        audioState: audioState,
                        isRecent: isRecent,
                      )
                  ],
                ),
                if (isAudioSelected)
                  LineraProgressIndicator(
                    audioProgress: audioProgress,
                    width: maxWidth - 100,
                  )
              ],
            );
          },
        );
      },
    );
  }
}
