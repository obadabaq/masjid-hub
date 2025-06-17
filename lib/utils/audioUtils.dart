import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:path_provider/path_provider.dart';

import 'package:masjidhub/constants/Audio/surahAudioStateListData.dart';
import 'package:masjidhub/models/audio/surahAudioState.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class AudioUtils {
  SurahAudioState getState(int surah, List<SurahAudioState> list) =>
      list.firstWhere((el) => el.surah == surah);

  bool shouldRebuild(
      List<SurahAudioState> prev, List<SurahAudioState> next, surah) {
    final prevAudioState = getState(surah, prev);
    final nextAudioState = getState(surah, next);

    bool hasActionStateChanged = prevAudioState.state != nextAudioState.state;
    bool hasDownloadChanged =
        prevAudioState.downloadProgress != nextAudioState.downloadProgress;

    return hasActionStateChanged || hasDownloadChanged;
  }

  SurahAudioState cloneState(SurahAudioState st) => SurahAudioState(
      downloadProgress: st.downloadProgress, state: st.state, surah: st.surah);

  List<SurahAudioState> updateActionState(
    List<SurahAudioState> oldList,
    SurahAudioState oldSurahState,
    SurahListActionButtonState newActionState,
  ) {
    SurahAudioState localState = cloneState(oldSurahState);
    localState.state = newActionState;
    return [localState, ...oldList];
  }

  List<SurahAudioState> setIsDownloading(
          List<SurahAudioState> oldList, SurahAudioState oldSurahState) =>
      updateActionState(
          oldList, oldSurahState, SurahListActionButtonState.downloading);

  List<SurahAudioState> setDownloadComplete(
          List<SurahAudioState> oldList, SurahAudioState oldSurahState) =>
      updateActionState(
          oldList, oldSurahState, SurahListActionButtonState.paused);

  List<SurahAudioState> cancelDownload(List<SurahAudioState> oldList) {
    final int oldStateIndex = oldList
        .indexWhere((el) => el.state == SurahListActionButtonState.downloading);

    bool nothingBeingDownloaded = oldStateIndex == -1;
    if (nothingBeingDownloaded) return oldList;

    return updateActionState(
      oldList,
      oldList[oldStateIndex],
      SurahListActionButtonState.preDownload,
    );
  }

  List<SurahAudioState> completeDownload(List<SurahAudioState> oldList) {
    final int oldStateIndex = oldList
        .indexWhere((el) => el.state == SurahListActionButtonState.downloading);

    bool nothingBeingDownloaded = oldStateIndex == -1;
    if (nothingBeingDownloaded) return oldList;

    SharedPrefs().setDownloadedSurahs(oldList[oldStateIndex].surah);

    return updateActionState(
      oldList,
      oldList[oldStateIndex],
      SurahListActionButtonState.paused,
    );
  }

  List<SurahAudioState> setDownloadProgress(
    List<SurahAudioState> oldList,
    SurahAudioState oldSurahState,
    double prog,
  ) {
    SurahAudioState localState = cloneState(oldSurahState);
    localState.downloadProgress = prog;
    localState.state = SurahListActionButtonState.downloading;
    return [localState, ...oldList];
  }

  Future<List<SurahAudioState>> retrieveSurahAudioStateList() async {
    final List<SurahAudioState> defaultList = surahAudioStateList;
    final List<int> downloadedSurahs =
        await SharedPrefs().getDownloadedSurahs();
    if (downloadedSurahs.length == 0) return defaultList;
    for (var i = 0; i < downloadedSurahs.length; i++) {
      defaultList.firstWhere((el) => el.surah == downloadedSurahs[i]).state =
          SurahListActionButtonState.paused;
    }
    return defaultList;
  }

  Future<void> setPlaybackRate(audioPlayer) async {
    double playbackRate = SharedPrefs().getPlaybackRate;
    audioPlayer.setPlaybackRate(playbackRate: playbackRate);
  }

  Future<void> playSurah(
    int surah,
    AudioPlayer audioPlayer,
    AudioPlayerStateModel? pausedState,
    int ayah,
    List<int> timeStamp, {
    bool forcePlayFromAyah = false,
  }) async {
    bool shouldPlayFromPreviouslyPaused = pausedState != null &&
        pausedState.surahId == surah &&
        !forcePlayFromAyah;

    final bool isAndroid = Platform.isAndroid;
    final downloadDir = isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String localPath = "${downloadDir!.path}/$surah.mp3";

    Duration initialDuration =
        ayah == 1 ? Duration.zero : Duration(milliseconds: timeStamp[ayah - 1]);

    try {
      await audioPlayer.play(AssetSource(localPath),
          position: shouldPlayFromPreviouslyPaused
              ? pausedState.dur
              : initialDuration);
      setPlaybackRate(audioPlayer);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> resumeSurah(
    AudioPlayer audioPlayer,
  ) async {
    try {
      await audioPlayer.resume();
      setPlaybackRate(audioPlayer);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> pauseSurah(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      return Future.error(e);
    }
  }

  List<SurahAudioState> notifyPlayMode(
          List<SurahAudioState> oldList, SurahAudioState oldSurahState) =>
      updateActionState(
          oldList, oldSurahState, SurahListActionButtonState.playing);

  List<SurahAudioState> notifyPauseMode(
          List<SurahAudioState> oldList, SurahAudioState oldSurahState) =>
      updateActionState(
          oldList, oldSurahState, SurahListActionButtonState.paused);

  bool progressChangeIsNotMinimal(Duration oldDur, Duration newDur) {
    final int difference = newDur.inSeconds - oldDur.inSeconds;
    return difference >= 1 || difference <= -1;
  }

  bool shouldTriggerVisibilityChange(
      double oldVisibility, double newVisibilty) {
    bool isPreviouslyVisible = oldVisibility > 0;
    bool isNowVisible = newVisibilty > 0;
    bool isVisibilityChanged = (isPreviouslyVisible && !isNowVisible) ||
        (!isPreviouslyVisible && isNowVisible);
    return isVisibilityChanged;
  }

  Future<bool> isSurahDownloaded(int surahId) async {
    final bool isAndroid = Platform.isAndroid;
    final downloadDir = isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String localPath = "${downloadDir!.path}/$surahId.mp3";

    return File(localPath).exists();
  }
}
