class AudioPlayerStateModel {
  final int surahId;
  final int currentlyPlayingAyahId;
  final int surahAudioCompletionPercentatge;
  final int prevAyahTimestamp;
  final int nextAyahTimestamp;
  final bool isLastAyah;
  final bool isFirstAyah;
  final Duration dur;

  AudioPlayerStateModel({
    this.surahId = 0,
    this.currentlyPlayingAyahId = 0,
    this.surahAudioCompletionPercentatge = 0,
    this.prevAyahTimestamp = 0,
    this.nextAyahTimestamp = 0,
    this.dur = Duration.zero,
    this.isLastAyah = false,
    this.isFirstAyah = false,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'currentlyPlayingAyahId': currentlyPlayingAyahId,
        'surahAudioCompletionPercentatge': surahAudioCompletionPercentatge,
        'dur': dur.inMilliseconds,
      };

  factory AudioPlayerStateModel.fromJson(Map<String, dynamic> json) {
    return AudioPlayerStateModel(
      surahId: json['surahId'] as int,
      currentlyPlayingAyahId: json['currentlyPlayingAyahId'] as int,
      surahAudioCompletionPercentatge:
          json['surahAudioCompletionPercentatge'] as int,
      dur: Duration(milliseconds: json['dur'] as int),
    );
  }
}
