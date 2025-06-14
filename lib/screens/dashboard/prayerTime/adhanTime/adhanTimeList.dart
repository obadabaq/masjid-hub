import 'dart:async';

import 'package:flutter/material.dart';
import 'package:masjidhub/common/scrollable_main_screen.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/constants/prayerIcons.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/adhanTime/adhanTimeListItem.dart';

class AdhanTimeList extends StatefulWidget {
  const AdhanTimeList({Key? key}) : super(key: key);

  @override
  _AdhanTimeListState createState() => _AdhanTimeListState();
}

class _AdhanTimeListState extends State<AdhanTimeList> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<List<AdhanTimeModel>> _fetchPrayerTimes() async {
    if (SharedPrefs().getUserCords == null)
      await Provider.of<LocationProvider>(context, listen: false).locateUser();
    List<AdhanTimeModel> times =
        await Provider.of<PrayerTimingsProvider>(context, listen: false)
            .getPrayerTimes();
    return times;
  }

  void onAlarmButtonToggle(int prayerId) async {
    await Provider.of<PrayerTimingsProvider>(context, listen: false)
        .setAlarmForAdhan(prayerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxHeight = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxWidth: 350, maxHeight: maxHeight),
        child: Consumer<PrayerTimingsProvider>(
          builder: (ctx, prayerTimeProvider, _) => SizedBox(
            child: ScrollableMainScreen(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _fetchPrayerTimes(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<AdhanTimeModel>> snapshot) {
                        if (snapshot.hasData)
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10, bottom: 150),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int i) {
                              final filterPrayerTitle = PrayerUtils()
                                  .filterPrayerTitle(adhanIconsList[i].title);
                              return AdhanTimeListItem(
                                id: snapshot.data![i].id,
                                title: filterPrayerTitle,
                                icon: adhanIconsList[i].icon,
                                time: snapshot.data![i].time,
                                isCurrentPrayer:
                                    snapshot.data![i].isCurrentPrayer,
                                isAlarmDisabled:
                                    snapshot.data![i].isAlarmDisabled,
                                onAlarmButtonClick: (id) =>
                                    onAlarmButtonToggle(id),
                              );
                            },
                          );
                        return Container(
                          margin: EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
