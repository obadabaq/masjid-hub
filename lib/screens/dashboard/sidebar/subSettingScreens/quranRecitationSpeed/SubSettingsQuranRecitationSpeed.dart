import 'package:flutter/material.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/Audio/playbackRateList.dart';
import 'package:masjidhub/models/radioListModel.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:provider/provider.dart';

class SubSettingsQuranRecitationSpeed extends StatefulWidget {
  const SubSettingsQuranRecitationSpeed({
    Key? key,
  }) : super(key: key);

  @override
  _QuranRecitationSpeedState createState() => _QuranRecitationSpeedState();
}

class _QuranRecitationSpeedState
    extends State<SubSettingsQuranRecitationSpeed> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < playbackRateOptions.length; i++)
        RadioListModel(id: i, title: playbackRateOptions[i].title),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Consumer<AudioProvider>(
        builder: (ctx, audio, _) =>
            LayoutBuilder(builder: (context, constraints) {
          return RadioList(
            list: list,
            onItemPressed: (id) =>
                audio.onQuranPlaybackRateChanged(playbackRateOptions[id].rate),
            itemSelected: playbackRateOptions
                .indexWhere((option) => option.rate == audio.quranPlaybackRate),
            width: constraints.maxWidth,
          );
        }),
      ),
    );
  }
}
