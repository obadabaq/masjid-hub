import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/Audio/surahAudioStateListData.dart';
import 'package:masjidhub/models/audio/surahAudioState.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/utils/audioUtils.dart';
import 'package:masjidhub/utils/ayahUtils.dart';
import 'package:masjidhub/utils/downloaderUtils.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class AudioProvider extends ChangeNotifier {
  bool isQuranAlreadyInit = false;
  bool downloadInProgress = false;
  int currentlyPlayingSurah = 999; // No surah is played, refactor in future

  Duration legthOfAudioSelected = Duration();
  List<SurahAudioState> quranAudioState = surahAudioStateList;
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> updateQuranAudioState(List<SurahAudioState> newList) async {
    quranAudioState = [...newList];
    notifyListeners();
  }

  Future<void> initQuranAudioState() async {
    if (!isQuranAlreadyInit) {
      final List<SurahAudioState> newList =
          await AudioUtils().retrieveSurahAudioStateList();
      updateQuranAudioState(newList);
      isQuranAlreadyInit = true;
    }
  }

  // Timings
  late List<List<int>> _surahTimings;
  List<List<int>> get surahTimings => _surahTimings;

  Future<List<List<int>>> getSurahTimings() async {
    try {
      final String timingString =
          await rootBundle.loadString('assets/quran/timing/meshari.json');
      final result = AyahUtils().parsetTimingsString(timingString);
      return result;
    } catch (e) {
      return Future.error(tr('error extracting timings'));
    }
  }

  Future<void> initSurahTimings() async {
    _surahTimings = await getSurahTimings();
  }

  Future<void> downloadAudio(SurahAudioState state) async {
    final surah = state.surah;

    if (downloadInProgress) await cancelDownload();

    await Future.delayed(Duration(milliseconds: 200));
    downloadInProgress = true;

    updateQuranAudioState(
        AudioUtils().setIsDownloading(quranAudioState, state));

    DownloaderUtils().downloadSurah(surah);
  }

  Future<void> cancelDownload() async {
    downloadInProgress = false;
    await DownloaderUtils().cancelDownloads();
    await updateQuranAudioState(
      AudioUtils().cancelDownload(quranAudioState),
    );
  }

  Future<void> completeDownload() async {
    downloadInProgress = false;
    await updateQuranAudioState(
      AudioUtils().completeDownload(quranAudioState),
    );
  }

  Future<void> playSurah(
    int surah,
    SurahAudioState state, {
    int ayah = 1,
    forcePlayFromAyah = false,
  }) async {
    if (currentlyPlayingSurah != 999) {
      pauseSurah(
          currentlyPlayingSurah,
          quranAudioState
              .firstWhere((element) => element.surah == currentlyPlayingSurah));
    }

    final List<int> surahTimeStamp = surahTimings[surah];

    currentlyPlayingSurah = surah;
    await AudioUtils().playSurah(
      surah,
      audioPlayer,
      pausedAudioState,
      ayah,
      surahTimeStamp,
      forcePlayFromAyah:forcePlayFromAyah,
    );

    await Future.delayed(Duration(
        milliseconds:
            200)); // Audioplayer doesnt allow get duration right away.

    legthOfAudioSelected = (await audioPlayer.getDuration())!;

    await updateQuranAudioState(
      AudioUtils().notifyPlayMode(quranAudioState, state),
    );
    setAudioState(AudioPlayerStateModel(surahId: surah));
  }

  Future<void> resumeSurah() async {
    await AudioUtils().resumeSurah(audioPlayer);
    await updateQuranAudioState(
      AudioUtils().notifyPlayMode(
          quranAudioState,
          SurahAudioState(
            downloadProgress: 1,
            surah: currentlyPlayingSurah,
            state: SurahListActionButtonState.playing,
          )),
    );
    setAudioState(AudioPlayerStateModel(surahId: currentlyPlayingSurah));
  }

  Future<void> pauseSurahWhileReadingMode() async {
    AudioUtils().pauseSurah(audioPlayer);
    await updateQuranAudioState(
      AudioUtils().notifyPauseMode(
          quranAudioState,
          SurahAudioState(
            surah: currentlyPlayingSurah,
            downloadProgress: 100,
            state: SurahListActionButtonState.paused
          )),
    );
    setAudioState(AudioPlayerStateModel(surahId: 999));
  }

  Future<void> pauseSurah(int surah, SurahAudioState state) async {
    currentlyPlayingSurah = 999;
    AudioUtils().pauseSurah(audioPlayer);
    await updateQuranAudioState(
      AudioUtils().notifyPauseMode(quranAudioState, state),
    );
    setAudioState(AudioPlayerStateModel(surahId: 999));
  }

  Future<void> onAudioActionPressed(int surahNumber) async {
    final SurahAudioState audioState =
        AudioUtils().getState(surahNumber, quranAudioState.toList());
    final SurahListActionButtonState buttonState = audioState.state;
    switch (buttonState) {
      case SurahListActionButtonState.preDownload:
        return downloadAudio(audioState);
      case SurahListActionButtonState.downloading:
        return cancelDownload();
      case SurahListActionButtonState.paused:
        return playSurah(audioState.surah, audioState);
      case SurahListActionButtonState.playing:
        return pauseSurah(audioState.surah, audioState);
    }
  }

  static AudioPlayerStateModel _audioState = AudioPlayerStateModel();
  AudioPlayerStateModel get audioState => _audioState;
  void setAudioState(AudioPlayerStateModel state) {
    _audioState = state;
    notifyListeners();
  }

  static Duration _currentDuration = Duration.zero;
  static AudioPlayerStateModel? _pausedAudioState;
  AudioPlayerStateModel? get pausedAudioState => _pausedAudioState;
  void setPausedAudioState(AudioPlayerStateModel? state) {
    _pausedAudioState = state;
  }

  void resetAudioState() {
    _audioState = AudioPlayerStateModel();
    notifyListeners();
  }

  void setLengthOfSelectedAudio() async {
    // milli seconds
    legthOfAudioSelected = (await audioPlayer.getDuration())!;
  }

  void addAudioListeners() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      if (s == PlayerState.completed) {
        pauseSurah(
            currentlyPlayingSurah,
            quranAudioState.firstWhere(
                (element) => element.surah == currentlyPlayingSurah));
        setPausedAudioState(null);
      }
      if (s == PlayerState.paused) {
        setPausedAudioState(AudioPlayerStateModel(
            surahId: currentlyPlayingSurah, dur: _currentDuration));
      }
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      int dur = p.inMilliseconds;
      _currentDuration = p;

      if (legthOfAudioSelected != 0) {
        bool shouldReRender =
            AudioUtils().progressChangeIsNotMinimal(audioState.dur, p);

        if (shouldReRender) {
          int percentage = ((dur / legthOfAudioSelected.inMicroseconds) * 100).toInt();
          final List<int> surahTimeStamp = surahTimings[currentlyPlayingSurah];

          int currentlyPlayingAyahId =
              surahTimeStamp.indexWhere((ayahStartTime) => ayahStartTime > dur);

          int currentlyPlayingAyahIndex = currentlyPlayingAyahId - 1;

          int prevAyahId = currentlyPlayingAyahIndex != 0
              ? currentlyPlayingAyahIndex - 1
              : 0;

          int lastAyahIndex = surahTimeStamp.length - 1;
          int nextAyahId = currentlyPlayingAyahIndex < lastAyahIndex
              ? currentlyPlayingAyahIndex + 1
              : currentlyPlayingAyahIndex;

          setAudioState(AudioPlayerStateModel(
            surahId: currentlyPlayingSurah,
            surahAudioCompletionPercentatge: percentage,
            currentlyPlayingAyahId: currentlyPlayingAyahId,
            prevAyahTimestamp: surahTimeStamp[prevAyahId],
            nextAyahTimestamp: surahTimeStamp[nextAyahId],
            isFirstAyah: currentlyPlayingAyahIndex == 0,
            isLastAyah: lastAyahIndex == currentlyPlayingAyahId,
            dur: p,
          ));
        }
      }
    });
  }

  // Surah reading mode Bottom Media player
  bool _autoScrollActive = false;
  bool get autoScrollActive => _autoScrollActive;
  Future<void> toggleAutoScroll() async {
    _autoScrollActive = !_autoScrollActive;
    notifyListeners();
  }

  Future<void> switchOffAutoScroll() async {
    _autoScrollActive = false;
    notifyListeners();
  }

  // Quran Recitation Speed
  double quranPlaybackRate = SharedPrefs().getPlaybackRate;
  Future<void> onQuranPlaybackRateChanged(double rate) async {
    quranPlaybackRate = rate;
    audioPlayer.setPlaybackRate(rate);
    SharedPrefs().setPlaybackRate(rate);
    notifyListeners();
  }

  void playNextSurah() async {
    await audioPlayer
        .seek(Duration(milliseconds: audioState.nextAyahTimestamp));
  }

  void playPreviousSurah() async {
    await audioPlayer
        .seek(Duration(milliseconds: audioState.prevAyahTimestamp));
  }

  void playAyah(int surahNumber, int ayah) async {
    final SurahAudioState audioState =
        AudioUtils().getState(surahNumber, quranAudioState.toList());

    playSurah(
      audioState.surah,
      audioState,
      ayah: ayah,
      forcePlayFromAyah: true,
    );
  }
}
