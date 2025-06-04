import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/models/audio/surahAudioState.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';

import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemActionButton/surahListItemActionButtonDownloading.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemActionButton/surahListItemActionButtonPaused.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemActionButton/surahListItemActionButtonPlaying.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItemActionButton/surahListItemActionButtonPreDownload.dart';
import 'package:provider/provider.dart';

class SurahListItemActionButton extends StatelessWidget {
  const SurahListItemActionButton({
    Key? key,
    required this.onAudioButonPressed,
    required this.surahNumber,
    required this.audioState,
    required this.isRecent,
  }) : super(key: key);

  final Function onAudioButonPressed;
  final int surahNumber;
  final SurahAudioState audioState;
  final bool isRecent;

  Widget getActionButton(SurahAudioState itemState, BuildContext context) {
    BleProvider bleProvider = Provider.of<BleProvider>(context, listen: false);
    bool isRemoteOn = bleProvider.isRemoteOn;

    if (isRemoteOn) {
      return SurahListItemActionButtonPaused(
        onAudioButonPressed: onAudioButonPressed,
      );
    }

    switch (itemState.state) {
      case SurahListActionButtonState.paused:
        return SurahListItemActionButtonPaused(
          onAudioButonPressed: onAudioButonPressed,
        );

      case SurahListActionButtonState.playing:
        if (isRecent)
          return SurahListItemActionButtonPaused(
            onAudioButonPressed: onAudioButonPressed,
          );
        return SurahListItemActionButtonPlaying(
          onAudioButonPressed: onAudioButonPressed,
        );

      case SurahListActionButtonState.preDownload:
        return SurahListItemActionButtonPreDownload(
          onAudioButonPressed: onAudioButonPressed,
        );

      case SurahListActionButtonState.downloading:
        return SurahListItemActionButtonDownloading(
          onAudioButonPressed: onAudioButonPressed,
          downloadProgress: itemState.downloadProgress,
          surahNumber: surahNumber,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getActionButton(audioState, context);
  }
}
