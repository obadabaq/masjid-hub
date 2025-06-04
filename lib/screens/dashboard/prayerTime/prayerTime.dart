import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:masjidhub/utils/enums/deviceScale.dart';
import 'package:masjidhub/utils/layoutUtils.dart';
import 'package:provider/provider.dart';
import '../../../provider/locationProvider.dart';
import '../../../provider/prayerTimingsProvider.dart';
import '../../../provider/providerList.dart';
import '../../../provider/wathc_provider.dart';
import '../../../utils/sharedPrefs.dart';
import 'adhanTime/adhanTimeList.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerCalendar/prayerCalendar.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerDial/prayerDial.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({Key? key}) : super(key: key);

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  Timer? _timer;
  Timer? _timer2;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double deviceHeight = MediaQuery.of(context).size.height;
          final DeviceScale scale = LayoutUtils().getShrinkScale(deviceHeight);
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              PrayerDial(scale: scale),
              PrayerCalendar(scale: scale),
              Expanded(child: AdhanTimeList()),
            ],
          );
        },
      ),
    );
  }
}
