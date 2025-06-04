import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopup.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/buttons/RemoteOnAudioControlsLoopButton.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/buttons/remoteOnAudioControlsPlayButton.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/buttons/remoteOnAudioControlsSeekButton.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/buttons/RemoteOnAudioControlsPlaylistButton.dart';

class RemoteOnSurahAudioButtons extends StatelessWidget {
  const RemoteOnSurahAudioButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> onFailure() async {
      await Provider.of<BleProvider>(context, listen: false)
          .toggleRemote(false);
    }

    Future<void> handleCmd(Future<void> Function() func) async {
      try {
        await func();
      } catch (e) {
        AppSnackBar().showSnackBar(context, e, onTap: onFailure);
      }
    }

    return Consumer<BleProvider>(
      builder: (ctx, ble, _) {
        bool isPlaying = ble.isRemotePlaying;

        return Container(
          transform: Matrix4.translationValues(0.0, -8.0, 0.0),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RemoteOnAudioControlsPlaylistButton(
                  onPressed: () => _showPlaylistPopup(context)),
              RemoteOnAudioControlsSeekButton(
                icon: CupertinoIcons.backward_end_fill,
                onPressed: () => handleCmd(ble.playPreviousAyah),
              ),
              RemoteOnAudioControlsPlayButton(
                onPressed: isPlaying
                    ? () => handleCmd(ble.pauseSurah)
                    : () => handleCmd(ble.playRemoteSurah),
                isPlaying: isPlaying,
              ),
              RemoteOnAudioControlsSeekButton(
                icon: CupertinoIcons.forward_end_fill,
                onPressed: () => handleCmd(ble.playNextAyah),
              ),
              RemoteOnAudioControlsLoopButton(
                loopCount: ble.remoteOnSurahLoopCount,
                onPressed: () => ble.toggleRemoteOnSurahLoopCount(),
              ),
            ],
          ),
        );
      },
    );
  }
}

_showPlaylistPopup(BuildContext context) =>
    Navigator.push(context, PopupLayout(child: PlaylistPopup()));
