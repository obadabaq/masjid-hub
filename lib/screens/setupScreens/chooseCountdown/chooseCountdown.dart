import 'package:flutter/material.dart';
import 'package:masjidhub/common/counter/counter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/chooseCountdown/countdownTimerAudioList.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:sizer/sizer.dart';

class ChooseCountdown extends StatefulWidget {
  final PageController pageController;

  ChooseCountdown({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChooseCountdownState createState() => _ChooseCountdownState();
}

class _ChooseCountdownState extends State<ChooseCountdown> {
  static int alertTime = SharedPrefs().getCountdownTimer;
  static int alertTimeChangeInterval = 5;
  static int alertTimeChangeMaxInterval = 100;

  Future<void> _updateNotification() async {
    Provider.of<PrayerTimingsProvider>(context, listen: false)
        .updateNotification(notificationChannelChange: true);
  }

  Future<void> _incrementAlertTime() async {
    if (alertTime == alertTimeChangeMaxInterval) return null;
    setState(() {
      alertTime = alertTime + alertTimeChangeInterval;
    });
    await SharedPrefs().setCountdownTimer(alertTime);
    await _updateNotification();
  }

  Future<void> _decrementAlertTime() async {
    if (alertTime == alertTimeChangeInterval) return null;
    setState(() {
      alertTime = alertTime - alertTimeChangeInterval;
    });
    await SharedPrefs().setCountdownTimer(alertTime);
    await _updateNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: SetupHeaderImage(image: countdownSetupImage),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.5.h),
                      child: Text(
                        tr('countdown alert'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          color: CustomColors.blackPearl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.5.h, left: 30, right: 30),
                      child: Text(
                        tr('selectCountdownText'),
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Counter(
                      count: alertTime,
                      padding: EdgeInsets.only(top: 2.h, left: 30, right: 30),
                      onIncrementPressed: () => _incrementAlertTime(),
                      onDecrementPressed: () => _decrementAlertTime(),
                      lowerLimit: 5,
                      label: tr('minutes'),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.h, left: 30),
                        child: Text(
                          tr('choose alert'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            color: CustomColors.mischka,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: CountdownTimerAudioList(),
                    ),
                    SetupFooter(
                      currentPage: 2,
                      margin: EdgeInsets.only(bottom: 30),
                      buttonText: tr('next'),
                      controller: widget.pageController,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
