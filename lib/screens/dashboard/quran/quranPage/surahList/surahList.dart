import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/utils/audioUtils.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListItem/surahListItem.dart';

class SurahList extends StatefulWidget {
  const SurahList({
    required this.list,
    required this.quranRecitorId,
    this.isRecent = false,
    required this.surahCompleted,
    required this.audioPlayer,
    this.isRemoteOn = false,
    this.hidePlayButton = false,
    Key? key,
  }) : super(key: key);

  final List<SurahModel> list;
  final int quranRecitorId;
  final bool isRecent;
  final bool surahCompleted;
  final AudioPlayer audioPlayer;
  final bool? isRemoteOn;
  final bool? hidePlayButton;

  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  static double oldVisibility = 1;

  void onItemVisibilityChange(double visbility, bool isAudioPlaying) {
    if (isAudioPlaying &&
        AudioUtils().shouldTriggerVisibilityChange(oldVisibility, visbility) &&
        mounted) {
      setState(() => oldVisibility = visbility);
      bool isVisible = visbility > 0;
      QuranProvider quranProvider =
          Provider.of<QuranProvider>(context, listen: false);
      if (!isVisible) {
        quranProvider.setAudioItemVisibility(isVisible);
      } else {
        quranProvider.setAudioItemVisibility(isVisible);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AudioProvider>(context, listen: false).addAudioListeners();
  }

  @override
  void dispose() {
    widget.audioPlayer.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.list.length,
      itemBuilder: (BuildContext context, int i) {
        final SurahModel surah = widget.list[i];

        return Selector<AudioProvider, Tuple2<int, int>>(
          selector: (_, select) => Tuple2(
            select.audioState.surahId,
            select.audioState.surahAudioCompletionPercentatge,
          ),
          shouldRebuild: (previous, next) =>
              surah.id == next.item1 || surah.id == previous.item1,
          builder: (ctx, audioState, _) {
            bool isAudioSelected = audioState.item1 == surah.id;
            return VisibilityDetector(
                key: Key(surah.englishName),
                onVisibilityChanged: (v) =>
                    onItemVisibilityChange(v.visibleFraction, isAudioSelected),
                child: SurahListItem(
                  englishName: surah.englishName,
                  verseCount: surah.numberOfAyahs,
                  surahNumber: surah.id,
                  isAudioSelected: isAudioSelected,
                  revelationType: surah.revelationType,
                  audioProgress: audioState.item2,
                  onAudioButonPressed: (state) => {},
                  isRemoteOn: widget.isRemoteOn,
                  bookmarkedAyah: surah.bookmarkedAyah,
                  scrollPosition: surah.bookmarkedScrollPosition ?? 0,
                  hidePlayButton: widget.hidePlayButton,
                ));
          },
        );
      },
    );
  }
}
