import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/audio/audioListItem.dart';
import 'package:masjidhub/common/buttons/adhanButtons.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/constants/adhans.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:sizer/sizer.dart';

class ChooseAdhanComponent extends StatefulWidget {
  const ChooseAdhanComponent({Key? key}) : super(key: key);

  @override
  _ChooseAdhanComponentState createState() => _ChooseAdhanComponentState();
}

class _ChooseAdhanComponentState extends State<ChooseAdhanComponent> {
  static int? selectedAzanId = SharedPrefs().getSelectedAdhanId;
  static int? selectedAzanAudioId;

  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache audioCache = AudioCache();

  Future<void> _onAdhanButtonClick(id) async {
    await Provider.of<PrayerTimingsProvider>(context, listen: false)
        .setAlarmForAdhan(id);
    setState(() {});
  }

  Future<void> _setAzanId(id) async {
    setState(() {
      if (selectedAzanId == id) return selectedAzanId = null;
      selectedAzanId = id;
    });
    await SharedPrefs().setSelectedAdhanId(selectedAzanId);
    await Provider.of<PrayerTimingsProvider>(context, listen: false)
        .updateNotification(notificationChannelChange: true);
  }

  Future<void> _setAzanAudio(id) async {
    if (selectedAzanAudioId == id) {
      audioPlayer.pause();
    } else {
      final String audioUrl = PrayerUtils().adhanRecitorIdToUrl(id);
      audioCache.load(audioUrl);
      audioPlayer.play(AssetSource(audioUrl));
    }
    setState(() {
      if (selectedAzanAudioId == id) return selectedAzanAudioId = null;
      selectedAzanAudioId = id;
    });
  }

  _onAzanItemPressed(int id) async {
    _setAzanId(id);
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

  Future<List<AdhanTimeModel>> _fetchPrayerTimes() async {
    var prayerTimesProvider =
        Provider.of<PrayerTimingsProvider>(context, listen: false);
    List<AdhanTimeModel> times = await SharedPrefs().getPrayerTimesList() ??
        await prayerTimesProvider.getPrayerTimes();

    return times;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final buttonWidth = (constraints.maxWidth / 2) - 30;

        return Column(
          children: [
            FutureBuilder(
              future: _fetchPrayerTimes(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<AdhanTimeModel>> snapshot) {
                if (snapshot.hasData)
                  return Wrap(
                    children: [
                      AdhanButton(
                        id: 0,
                        isSelected: !snapshot.data![0].isAlarmDisabled,
                        onClick: (id) => _onAdhanButtonClick(id),
                        height: 70,
                        width: buttonWidth,
                        text: tr('fajr'),
                        icon: AppIcons.fajrIcon,
                      ),
                      AdhanButton(
                        id: 1,
                        isSelected: !snapshot.data![1].isAlarmDisabled,
                        onClick: (id) => _onAdhanButtonClick(id),
                        height: 70,
                        width: buttonWidth,
                        text: tr('dhuhr'),
                        icon: AppIcons.duhrIcon,
                      ),
                      AdhanButton(
                        id: 2,
                        isSelected: !snapshot.data![2].isAlarmDisabled,
                        onClick: (id) => _onAdhanButtonClick(id),
                        height: 70,
                        width: buttonWidth,
                        text: tr('asr'),
                        icon: AppIcons.asrIcon,
                      ),
                      AdhanButton(
                        id: 3,
                        isSelected: !snapshot.data![3].isAlarmDisabled,
                        onClick: (id) => _onAdhanButtonClick(id),
                        height: 70,
                        width: buttonWidth,
                        text: tr('maghrib'),
                        icon: AppIcons.maghribIcon,
                      ),
                      AdhanButton(
                        id: 4,
                        isSelected: !snapshot.data![4].isAlarmDisabled,
                        onClick: (id) => _onAdhanButtonClick(id),
                        height: 70,
                        width: buttonWidth,
                        text: tr('isha'),
                        icon: AppIcons.ishaIcon,
                      ),
                    ],
                  );
                return Container(
                  margin: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Text(
                    tr('choose adhan'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: CustomColors.mischka,
                    ),
                  ),
                )
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 1.h),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: adhanList.length,
              itemBuilder: (BuildContext context, int index) {
                return AudioListItem(
                  id: adhanList[index].id,
                  title: tr(adhanList[index].title),
                  subTitle: tr(adhanList[index].subTitle),
                  isSelected: selectedAzanId == adhanList[index].id,
                  onPressed: (id) => _onAzanItemPressed(id),
                  onAudioPressed: (id) => _setAzanAudio(id),
                  isAudioSelected: selectedAzanAudioId == adhanList[index].id,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
