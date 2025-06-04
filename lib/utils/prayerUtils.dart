import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:location/location.dart';
import 'dart:io' show Platform;

import 'package:masjidhub/constants/adhans.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/constants/organisations.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/models/prayerConfigModel.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class PrayerUtils {
  String prayerEnumToString(Prayer prayerEnum) =>
      prayerEnum.toString().split('.').last;

  String prayerDurationFormat(Duration duration) {
    final hour = duration.inHours;
    final min = duration.inMinutes - (hour * 60);
    if (hour < 1) {
      if (min < 1) return '1 min';
      return '$min min';
    }
    return '${hour}h:${min}m';
  }

  Duration timeLeftFromNow(DateTime timeInFuture) =>
      timeInFuture.difference(DateTime.now());

  String encodePrayerTimingsList(List<AdhanTimeModel> list) {
    List<Map<String, dynamic>> encodedList =
        list.map((e) => e.toJson()).toList();
    return jsonEncode(encodedList);
  }

  List<AdhanTimeModel>? decodePrayerTimingsList(String? json) {
    if (json == null) return null;
    List encodedList = jsonDecode(json);
    return encodedList
        .map<AdhanTimeModel>((json) => AdhanTimeModel(
              id: json['id'] as int,
              time: json['time'] as String,
              isAlarmDisabled: json['isAlarmDisabled'] as bool,
              isCurrentPrayer: json['isCurrentPrayer'] as bool,
            ))
        .toList();
  }

  bool selectedDateIsToday(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  Madhab getMadhabFromId(int id) =>
      madhabList.firstWhere((e) => e.id == id).param;

  String getMadhabTitleFromId(int id) =>
      madhabList.firstWhere((e) => e.id == id).title;

  CalculationMethod getMethodFromId(int id) =>
      organisationList.firstWhere((e) => e.id == id).param;

  String getOrgNameFromId(int id) =>
      organisationList.firstWhere((e) => e.id == id).title;

  List<SurahModel>? decodeQuranMeta(String? json) {
    if (json == null) return null;
    List encodedList = jsonDecode(json);
    return encodedList
        .map<SurahModel>((json) => SurahModel(
              id: json['id'] as int,
              name: json['name'] as String,
              englishName: json['englishName'] as String,
              englishNameTranslation: json['englishNameTranslation'] as String,
              revelationType: json['revelationType'] as String,
              numberOfAyahs: json['numberOfAyahs'] as int,
              startAyahNumber: json['startAyahNumber'] as int,
            ))
        .toList();
  }

  String slugToUrl(String urlSLug) => 'audios/adhans/$urlSLug.mp3';

  String slugToSource(String urlSLug) {
    final source = 'resource://raw/res_$urlSLug';

    if (Platform.isAndroid) {
      final androidSlug = urlSLug.replaceAll('-', '_');
      final androidSource = 'resource://raw/res_$androidSlug';
      return androidSource;
    }

    return source;
  }

  String adhanRecitorIdToUrl(int id) => slugToUrl(adhanList[id].urlSlug);
  String adhanRecitorIdToSource(int id) => slugToSource(adhanList[id].urlSlug);

  String filterPrayerTitle(String prayerTitle) {
    final bool isTodayFriday = DateTime.now().weekday == 5;
    final isPrayerDhuhr = prayerTitle.toLowerCase() == 'dhuhr';
    if (isTodayFriday && isPrayerDhuhr) return 'Jummah';
    return prayerTitle;
  }

  PrayerConfigModel getPrayerConfig() {
    final cords = SharedPrefs().getUserCords;
    final userCords = Coordinates(cords!.lat, cords.lon);

    int orgId = SharedPrefs().getSelectedOrgId;
    int madhabId = SharedPrefs().getSelectedMadhabId;

    // Add latitude here
    final CalculationParameters prayerParams =
        PrayerUtils().getMethodFromId(orgId).getParameters();
    prayerParams.madhab = PrayerUtils().getMadhabFromId(madhabId);

    return PrayerConfigModel(cords: userCords, params: prayerParams);
  }

  Future<void> getAltitude() async {
    Location location = new Location();
    final LocationData _locationData =
        await location.getLocation().timeout(Duration(seconds: 3));
    final double _altitude = _locationData.altitude ?? 0;
    SharedPrefs().setAltitude(_altitude);
  }
}
