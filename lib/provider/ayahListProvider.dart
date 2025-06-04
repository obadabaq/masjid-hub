import 'package:flutter/material.dart';

import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/utils/recentSurahUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class AyahListProvider extends ChangeNotifier {
  static AudioPlayerStateModel _ayahAudioState = AudioPlayerStateModel();
  AudioPlayerStateModel get ayahAudioState => _ayahAudioState;

  void setAyahAudioState(AudioPlayerStateModel state) {
    _ayahAudioState = state;
    notifyListeners();
    setRecentSurahAudioState(state);
  }

  // Recent Surahs
  static AudioPlayerStateModel _recentSurahAudioState = AudioPlayerStateModel();
  AudioPlayerStateModel get recentSurahAudioState => _recentSurahAudioState;

  void setRecentSurahAudioState(AudioPlayerStateModel state) {
    bool shouldUpdateRecentAudioState = RecentSurahUtils()
        .shouldUpdateRecentSurahs(recentSurahAudioState, state);

    if (shouldUpdateRecentAudioState) {
      SharedPrefs().setRecentSurah(state);
      _recentSurahAudioState = state;
      notifyListeners();
    }
  }

  Future<AudioPlayerStateModel> getRecentSurahAudioState() async {
    return await SharedPrefs().getRecentSurah();
  }

  int _currentlyScrollingIntoViewAyah = 0;
  int get getCurrentlyScrollingIntoViewAyah => _currentlyScrollingIntoViewAyah;
  Future<void> setCurrentlyScrollingIntoViewAyah(int ayah) async {
    _currentlyScrollingIntoViewAyah = ayah;
  }
}
