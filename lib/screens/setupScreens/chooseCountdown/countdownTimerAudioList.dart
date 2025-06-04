import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/audio/audioListItem.dart';
import 'package:masjidhub/constants/timerAudio.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class CountdownTimerAudioList extends StatefulWidget {
  CountdownTimerAudioList({Key? key}) : super(key: key);

  @override
  _CountdownTimerAudioListState createState() =>
      _CountdownTimerAudioListState();
}

class _CountdownTimerAudioListState
    extends State<CountdownTimerAudioList> {
  static int? selectedAzanId = SharedPrefs().getSelectedCountdownAudioId;
  static int? selectedAzanAudioId;

  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache audioCache = AudioCache();

  Future<void> _setAzanId(id) async {
    setState(() {
      if (selectedAzanId == id) return selectedAzanId = null;
      selectedAzanId = id;
    });
    await Provider.of<PrayerTimingsProvider>(context, listen: false)
        .updateNotification(notificationChannelChange: true);

    SharedPrefs().setCountdownAudioId(id);
  }

  Future<void> _setAzanAudio(id) async {
    if (selectedAzanAudioId == id) {
      audioPlayer.pause();
    } else {
      final String audioUrl = PrayerUtils().adhanRecitorIdToUrl(id);
      audioCache.load(audioUrl);
    }
    setState(() {
      if (selectedAzanAudioId == id) return selectedAzanAudioId = null;
      selectedAzanAudioId = id;

    });
  }

  _onAzanItemPressed(int id) {
    _setAzanId(id);
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: timerAudioList.length,
        itemBuilder: (BuildContext context, int index) {
          return AudioListItem(
            id: timerAudioList[index].id,
            title: timerAudioList[index].title,
            subTitle: timerAudioList[index].subTitle,
            isSelected: selectedAzanId == timerAudioList[index].id,
            onPressed: (id) => _onAzanItemPressed(id),
            onAudioPressed: (id) => _setAzanAudio(id),
            isAudioSelected: selectedAzanAudioId == timerAudioList[index].id,

          );
        },
      ),
    );
  }
}
