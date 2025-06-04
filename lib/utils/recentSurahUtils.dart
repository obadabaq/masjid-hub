import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';

class RecentSurahUtils {
  bool shouldUpdateRecentSurahs(
      AudioPlayerStateModel oldState, AudioPlayerStateModel newState) {
    return newState.currentlyPlayingAyahId != 0;
  }

  bool shouldShowRecentSurah(
    int ayahPlaying,
    int progress,
    int numberOfAyahsInSurah,
  ) {
    bool isLastAyah = numberOfAyahsInSurah == ayahPlaying;
    if (isLastAyah) return false;

    bool isValidSurah = ayahPlaying != 0;
    bool isInProgress = progress > 0 && progress < 98;
    return isValidSurah || isInProgress;
  }
}
