import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/enums/deviceScale.dart';
import 'package:masjidhub/utils/layoutUtils.dart';
import 'package:provider/provider.dart';

class CalendarText extends StatefulWidget {
  const CalendarText({
    Key? key,
    this.scale = DeviceScale.normal,
  }) : super(key: key);

  final DeviceScale scale;

  @override
  _CalendarTextState createState() => _CalendarTextState();
}

class _CalendarTextState extends State<CalendarText> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var _dateFormat = DateFormat("EEEE, d MMM y");

    final double titlePadding = widget.scale == DeviceScale.normal ? 5 : 3;
    final double calendarTitleFontSize =
        LayoutUtils().getCalendarTextFontSize(widget.scale, 19);
    final double calendarSubTitleFontSize =
        LayoutUtils().getCalendarTextFontSize(widget.scale, 16);

    void showCalendar(onDateChange) {
      return DatePicker.showDatePicker(context,
          minDateTime: DateTime.now().subtract(Duration(days: 15)),
          maxDateTime: DateTime.now().add(Duration(days: 15)),
          initialDateTime: date,
          dateFormat: 'dd',
          locale: DateTimePickerLocale.en_us,
          pickerMode: DateTimePickerMode.datetime,
          pickerTheme: DateTimePickerTheme(
            showTitle: true,
            title: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              color: CustomTheme.lightTheme.colorScheme.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Day',
                    style: TextStyle(
                      fontSize: 25,
                      color: CustomColors.blackPearl,
                    ),
                  ),
                ],
              ),
            ),
            titleHeight: 80,
            itemTextStyle: TextStyle(
              fontSize: 40,
              color: CustomTheme.lightTheme.colorScheme.secondary,
            ),
            itemHeight: 55,
            backgroundColor: CustomTheme.lightTheme.colorScheme.background,
          ),
          onCancel: () {},
          onChange: (dateTime, List<int> index) => setState(() {
                date = dateTime;
              }),
          onClose: () => onDateChange(date));
    }

    return Consumer<PrayerTimingsProvider>(
      builder: (ctx, dateProvider, _) => GestureDetector(
        onTap: () => showCalendar((date) => dateProvider.setSelectedDate(date)),
        behavior: HitTestBehavior.translucent,
        child: Container(
          child: Column(
            children: [
              Text(
                _dateFormat.format(dateProvider.getSelectedDate),
                style: TextStyle(
                  color: CustomColors.blackPearl,
                  fontSize: calendarTitleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: titlePadding),
              FutureBuilder(
                future: dateProvider.geoorgianToHijri(),
                initialData: '',
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    snapshot.hasData ? snapshot.data : '',
                    style: TextStyle(
                      color: CustomColors.blackPearl,
                      fontSize: calendarSubTitleFontSize,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
