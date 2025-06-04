import 'package:flutter/material.dart';

import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerCalendar/calendarNavButtons.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerCalendar/calendarText.dart';
import 'package:masjidhub/utils/enums/deviceScale.dart';
import 'package:provider/provider.dart';

class PrayerCalendar extends StatelessWidget {
  const PrayerCalendar({
    Key? key,
    this.scale = DeviceScale.normal,
  }) : super(key: key);

  final DeviceScale scale;

  static final todayDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var dateProvider =
        Provider.of<PrayerTimingsProvider>(context, listen: false);

    Future<void> onLeftButtonClick() async {
      DateTime selectedDate = dateProvider.getSelectedDate;
      DateTime newDate = selectedDate.subtract(Duration(days: 1));
      dateProvider.setSelectedDate(newDate);
    }

    Future<void> onRightButtonClick() async {
      DateTime selectedDate = dateProvider.getSelectedDate;
      DateTime newDate = selectedDate.add(Duration(days: 1));
      dateProvider.setSelectedDate(newDate);
    }

    return Container(
      padding: scale == DeviceScale.normal
          ? EdgeInsets.symmetric(vertical: 10)
          : EdgeInsets.only(top: 8),
      constraints: BoxConstraints(maxWidth: 320),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CalendarNavButtons(
            orientation: NavButtonOrientation.left,
            onLeftButtonClick: onLeftButtonClick,
            scale: scale,
          ),
          CalendarText(scale: scale),
          CalendarNavButtons(
            orientation: NavButtonOrientation.right,
            onRightButtonClick: onRightButtonClick,
            scale: scale,
          ),
        ],
      ),
    );
  }
}
