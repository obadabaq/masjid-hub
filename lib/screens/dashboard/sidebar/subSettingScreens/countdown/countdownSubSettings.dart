import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/counter/counter.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/chooseCountdown/countdownTimerAudioList.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:provider/provider.dart';

class SubSettingCountDown extends StatefulWidget {
  const SubSettingCountDown({Key? key}) : super(key: key);

  @override
  _SubSettingCountDownState createState() => _SubSettingCountDownState();
}

class _SubSettingCountDownState extends State<SubSettingCountDown> {
  static int alertTimeChangeInterval = 5;
  static int alertTimeChangeMaxInterval = 100;

  @override
  Widget build(BuildContext context) {
    int alertTime = Provider.of<PrayerTimingsProvider>(context, listen: false)
            .countdownTimer ??
        0;

    Future<void> _incrementAlertTime(PrayerTimingsProvider provider) async {
      if (alertTime == alertTimeChangeMaxInterval) return null;
      setState(() {
        alertTime = alertTime + alertTimeChangeInterval;
      });
      await provider.setCountdownTimer(alertTime);
      await provider.updateNotification(notificationChannelChange: true);
    }

    Future<void> _decrementAlertTime(PrayerTimingsProvider provider) async {
      if (alertTime == alertTimeChangeInterval) return null;
      setState(() {
        alertTime = alertTime - alertTimeChangeInterval;
      });
      await provider.setCountdownTimer(alertTime);
      await provider.updateNotification(notificationChannelChange: true);
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 30),
          child: Text(
            tr('selectCountdownSettingsText'),
            style: TextStyle(
              fontSize: 16.0,
              height: 1.3,
              color: CustomColors.blackPearl.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Consumer<PrayerTimingsProvider>(
          builder: (ctx, prayerTimeProvider, _) => Counter(
            count: alertTime,
            padding: EdgeInsets.fromLTRB(34, 0, 34, 0),
            onIncrementPressed: () => _incrementAlertTime(prayerTimeProvider),
            onDecrementPressed: () => _decrementAlertTime(prayerTimeProvider),
            label: tr('minutes'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: CountdownTimerAudioList(),
        ),
      ],
    );
  }
}
