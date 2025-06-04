import 'package:masjidhub/utils/enums/audioEnums.dart';

class SurahAudioState {
  final int surah;
  double downloadProgress;
  SurahListActionButtonState state;

  SurahAudioState({
    required this.surah,
    required this.downloadProgress,
    required this.state,
  });
}
