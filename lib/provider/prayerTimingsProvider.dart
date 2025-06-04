import 'dart:convert';
import 'dart:developer';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/prayerIcons.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/models/prayerConfigModel.dart';
import 'package:masjidhub/models/prayerDialModel.dart';
import 'package:masjidhub/utils/notificationUtils.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class PrayerTimingsProvider extends ChangeNotifier {
  PrayerTimingsProvider({this.setupProvider});
  final setupProvider;

  DateTime _selectedDate = DateTime.now();
  String _selectedHijriDate = '';

  // Alarms and Prayer times //
  List<AdhanTimeModel>? _prayerTimesList;
  List<AdhanTimeModel>? get prayerTimesList => _prayerTimesList;

  int? _alertTimeInMins = SharedPrefs().getCountdownTimer;
  int? get countdownTimer => _alertTimeInMins;
  int defaultAlertTimeInMins = 20;
  Future<void> setCountdownTimer(int? time) async {
    _alertTimeInMins = time;
    SharedPrefs().setCountdownTimer(time);
    getPrayerTimesData(true);
    notifyListeners();
  }

  int _madhabId = SharedPrefs().getSelectedMadhabId;
  int get getMadhabId => _madhabId;
  Future<void> setMadhabId(int id) async {
    _madhabId = id;
    SharedPrefs().setSelectedMadhabId(id);
    getPrayerTimesData(false);
    notifyListeners();
  }

  int _orgId = SharedPrefs().getSelectedOrgId;
  int get getOrgId => _orgId;
  Future<void> setOrgId(int id) async {
    _orgId = id;
    SharedPrefs().setSelectedOrgId(id);
    getPrayerTimesData(false);
    notifyListeners();
  }

  Future<void> setAlarmForAdhan(int adhanId) async {
    if (_prayerTimesList == null)
      _prayerTimesList = await SharedPrefs().getPrayerTimesList();
    final AdhanTimeModel adhan =
        _prayerTimesList!.firstWhere((adhan) => adhan.id == adhanId);
    final bool isAlarmDisabled = adhan.isAlarmDisabled;
    adhan.isAlarmDisabled = !isAlarmDisabled;
    await getPrayerTimesData(false);
    final isSelectedDateToday =
        PrayerUtils().selectedDateIsToday(_selectedDate);
    if (isSelectedDateToday)
      await SharedPrefs().setPrayerTimesList(prayerTimesList!);
    NotificationUtils().createNotification(prayerTimesList);

    notifyListeners();
  }

  final String georgianToHijriApi = 'https://api.aladhan.com/v1/gToH?date=';
  var dateFormat = DateFormat("dd-MM-y");

  DateTime get getSelectedDate => _selectedDate;
  String get getSelectedHijriDate => _selectedHijriDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    geoorgianToHijri();
    getPrayerTimes();
    notifyListeners();
  }


  Future<List<Map<String, dynamic>>> getNext30DaysPrayerTimes() async {
    List<Map<String, dynamic>> prayerTimesList = [];

    for (int i = 0; i < 30; i++) {
      DateTime currentDate = DateTime.now().add(Duration(days: i));
      List<AdhanTimeModel> prayers = await getPrayerTimes();

      List<DateTime> prayerTimes = prayers.map((prayer) {
        DateTime dateTime = DateFormat.jm().parse(prayer.time);
        return DateTime(currentDate.year, currentDate.month, currentDate.day, dateTime.hour, dateTime.minute);
      }).toList();
      prayerTimes.removeAt(1);
      prayerTimesList.add({
        'date': currentDate,
        'prayers': prayerTimes,
      });
    }

    return prayerTimesList;
  }
  Future<String> geoorgianToHijri() async {
    bool isOnline = await InternetConnectionChecker().hasConnection;
    if (!isOnline) {
      _selectedHijriDate = 'Offline';
      notifyListeners();
      return 'Offline';
    }
    final client = http.Client();
    var formattedDate = dateFormat.format(_selectedDate);
    final Uri request = Uri.parse('$georgianToHijriApi$formattedDate');
    final response = await client.get(request);
    if (response.statusCode == 200) {
      try {
        final responseBody = json.decode(response.body);
        var abbr = responseBody['data']['hijri']['designation']['abbreviated'];
        var year = responseBody['data']['hijri']['year'];
        var month = responseBody['data']['hijri']['month']['en'];
        var day = responseBody['data']['hijri']['day'];
        _selectedHijriDate = '$day $month, $year $abbr';
        notifyListeners();
        return _selectedHijriDate;
      } catch (e) {
        _selectedHijriDate = 'Error';
        notifyListeners();
        return Future.error('Error parsing Hijri date');
      }
    } else {
      _selectedHijriDate = 'Error';
      notifyListeners();
      return Future.error('Error fetching Hijri date');
    }
  }


  Future<void> initDates() async {
    geoorgianToHijri();
  }

  Future<int?> getCurrentPrayerId(PrayerTimes prayerTimes) async {
    Prayer currentPrayerEnum = prayerTimes.currentPrayer();

    final bool endOfDay = currentPrayerEnum == Prayer.none;
    if (endOfDay) return null;
    String currentPrayer = PrayerUtils().prayerEnumToString(currentPrayerEnum);
    return adhanIconsList
        .indexWhere((adhan) => adhan.title.toLowerCase() == currentPrayer);
  }

  Future<PrayerDialModel> getNextPrayerData(PrayerTimes prayerTimes) async {
    final Prayer currentPrayerEnum = prayerTimes.currentPrayer();
    final Prayer nextPrayerEnum = prayerTimes.nextPrayer();

    final bool endOfDay = nextPrayerEnum == Prayer.none;
    final bool newDay = currentPrayerEnum == Prayer.none;

    Prayer filteredNextPrayerEnum() {
      switch (nextPrayerEnum) {
        case Prayer.none:
          return Prayer.fajr;
        default:
          return nextPrayerEnum;
      }
    }

    Prayer filteredCurrentPrayerEnum() {
      switch (currentPrayerEnum) {
        case Prayer.none:
          return Prayer.isha;
        default:
          return currentPrayerEnum;
      }
    }

    final String nextPrayer =
        PrayerUtils().prayerEnumToString(filteredNextPrayerEnum());

    final String nextPrayerFiltered =
        PrayerUtils().filterPrayerTitle(nextPrayer);

    final DateTime? timeToCurrentPrayer = !newDay
        ? prayerTimes.timeForPrayer(filteredCurrentPrayerEnum())
        : prayerTimes
            .timeForPrayer(filteredCurrentPrayerEnum())!
            .subtract(Duration(days: 1));

    final DateTime? timeToNextPrayer = !endOfDay
        ? prayerTimes.timeForPrayer(filteredNextPrayerEnum())
        : prayerTimes
            .timeForPrayer(filteredNextPrayerEnum())!
            .add(Duration(days: 1));

    final int durationBetweenBothPrayers =
        timeToNextPrayer?.difference(timeToCurrentPrayer!).inSeconds ??
            Duration(hours: 3).inSeconds;

    final Duration durationLeft =
        PrayerUtils().timeLeftFromNow(timeToNextPrayer ?? DateTime.now());

    final int durationLeftInSeconds = PrayerUtils()
        .timeLeftFromNow(
            timeToNextPrayer ?? DateTime.now().add(Duration(hours: 2)))
        .inSeconds;

    final double relativeDuration =
        durationLeftInSeconds / durationBetweenBothPrayers;
    final double progressAngle = 360 * relativeDuration;

    return PrayerDialModel(
      prayerTitle: nextPrayerFiltered,
      timeToPrayer: durationLeft,
      progressAngle: progressAngle.toInt(),
      alertTimeInMins: _alertTimeInMins ?? defaultAlertTimeInMins,
    );
  }

  Future<PrayerConfigModel> getPrayerConfig() async {
    final cords = SharedPrefs().getUserCords;
    final userCords = Coordinates(cords!.lat, cords.lon);
    final prayerParams =
        PrayerUtils().getMethodFromId(getOrgId).getParameters();
    prayerParams.madhab = PrayerUtils().getMadhabFromId(getMadhabId);
    return PrayerConfigModel(cords: userCords, params: prayerParams);
  }

  Future<PrayerTimes> getPrayerTimesData(bool dial) async {
    final DateTime filteredDate = dial ? DateTime.now() : _selectedDate;
    final PrayerConfigModel config = await getPrayerConfig();
    return PrayerTimes(
      config.cords,
      DateComponents(filteredDate.year, filteredDate.month, filteredDate.day),
      config.params,
    );
  }

  Future<List<AdhanTimeModel>> getPrayerTimes() async {
    final PrayerTimes prayerTimesData = await getPrayerTimesData(false);
    final isSelectedDateToday =
        PrayerUtils().selectedDateIsToday(_selectedDate);

    List<String> prayerTimeTemp = [
      DateFormat.jm().format(prayerTimesData.fajr),
      DateFormat.jm().format(prayerTimesData.sunrise),
      DateFormat.jm().format(prayerTimesData.dhuhr),
      DateFormat.jm().format(prayerTimesData.asr),
      DateFormat.jm().format(prayerTimesData.maghrib),
      DateFormat.jm().format(prayerTimesData.isha),
    ];

    if (_prayerTimesList == null)
      _prayerTimesList = await SharedPrefs().getPrayerTimesList();

    List<AdhanTimeModel> tempPrayerTimesList = [
      for (var i = 0; i < 6; i++)
        AdhanTimeModel(
          id: i,
          time: prayerTimeTemp[i],
          isAlarmDisabled: _prayerTimesList != null
              ? _prayerTimesList![i].isAlarmDisabled
              : true,
          isCurrentPrayer: isSelectedDateToday &&
              await getCurrentPrayerId(prayerTimesData) == i,

        )
    ];
    _prayerTimesList = tempPrayerTimesList;
    updateNotification();
    return tempPrayerTimesList;
  }

  Future<PrayerDialModel> getPrayerDialDataList() async {
    final PrayerTimes prayerTimesData = await getPrayerTimesData(true);
    final PrayerDialModel prayerTime = await getNextPrayerData(prayerTimesData);
    return prayerTime;
  }

  // Update notification
  Future<void> updateNotification({
    bool notificationChannelChange = false,
  }) async {
    if (_prayerTimesList == null)
      _prayerTimesList = await SharedPrefs().getPrayerTimesList();
    final bool notificationLastToday =
        SharedPrefs().getNotificationLastUpdated == DateTime.now().day;

    final bool isNotificationLocationChanged =
        SharedPrefs().isNotificationLocationChanged();

    if (isNotificationLocationChanged) SharedPrefs().setNotificationLocation();

    bool updateNotification = !notificationLastToday ||
        notificationChannelChange ||
        isNotificationLocationChanged;

    if (updateNotification) {
      NotificationUtils().createNotification(_prayerTimesList);
      SharedPrefs().setNotificationUpdated();
    }
  }
}
