import 'package:masjidhub/models/audio/surahAudioState.dart';
import 'package:masjidhub/utils/enums/audioEnums.dart';

final List<SurahAudioState> surahAudioStateList = [
  for (var i = 1; i < 115; i++)
    SurahAudioState(
      surah: i,
      downloadProgress: 0,
      state: SurahListActionButtonState.preDownload,
    )
];
