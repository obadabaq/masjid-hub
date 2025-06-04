import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/remoteOnSurahAudioButtons.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/volumeControlSlider.dart';

class RemoteOnSurahAudioControls extends StatelessWidget {
  const RemoteOnSurahAudioControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        RemoteOnSurahAudioButtons(),
        VolumeControlSliderComponent()
      ],
    );
  }
}
