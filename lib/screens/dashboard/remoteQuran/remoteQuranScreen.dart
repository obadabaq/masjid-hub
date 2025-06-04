import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/remoteQuran/sliderComponent/audioControls/remoteOnSurahAudioControls.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/surahSwiper/surahSwiper.dart';

class RemoteQuranScreen extends StatelessWidget {
  const RemoteQuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        return Column(
          children: [
            SurahSwiper(maxWidth: maxWidth),
            RemoteOnSurahAudioControls()
          ],
        );
      },
    );
  }
}
