import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masjidhub/common/buttons/mediaButton/mediaButton.dart';
import 'package:masjidhub/provider/audioProvider.dart';

class SurahPageMediaPlayerButtons extends StatelessWidget {
  const SurahPageMediaPlayerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Consumer<AudioProvider>(
        builder: (ctx, audio, _) {
          bool isAudioPlaying = audio.audioPlayer.state == PlayerState.playing;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MediaButton(
                      type: MediaButtonType.previous,
                      onPressed: audio.playPreviousSurah,
                      isDisabled: audio.audioState.isFirstAyah,
                    ),
                    if (isAudioPlaying)
                      MediaButton(
                        type: MediaButtonType.pause,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        onPressed: () => audio.pauseSurahWhileReadingMode(),
                        state: MediaButtonState.active,
                      ),
                    if (!isAudioPlaying)
                      MediaButton(
                        type: MediaButtonType.play,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        onPressed: () => audio.resumeSurah(),
                      ),
                    MediaButton(
                      type: MediaButtonType.next,
                      onPressed: audio.playNextSurah,
                      isDisabled: audio.audioState.isLastAyah,
                    ),
                  ],
                ),
                MediaButton(
                  type: MediaButtonType.scroll,
                  onPressed: () => audio.toggleAutoScroll(),
                  state: audio.autoScrollActive
                      ? MediaButtonState.pressed
                      : MediaButtonState.normal,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
