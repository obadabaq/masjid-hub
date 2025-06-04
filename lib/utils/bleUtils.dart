import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:masjidhub/constants/adhans.dart';
import 'package:masjidhub/constants/ayahsInQuran.dart';
import 'package:masjidhub/constants/surahsInQuran.dart';
import 'package:masjidhub/models/audio/remoteOnSelectionModel.dart';
import 'package:masjidhub/models/prayerConfigModel.dart';
import 'package:masjidhub/models/quranBox/quranBoxDevice.dart';
import 'package:masjidhub/utils/enums/bleErrors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

enum RemoteSelectionItem { startSurah, startAyah, endSurah, endAyah }

class BleUtils {
  Future<QuranBoxDevice> getSavedDevice() async {
    return await SharedPrefs().getQuranBoxDevice();
  }

  // As per what masjidhub device wants
  int sanitizeTimestamp(DateTime time, Duration offset) {
    final DateTime offsetedTime = time.add(offset);
    final double newTime = offsetedTime.millisecondsSinceEpoch / 1000;
    final int sanitizedTime = int.parse(newTime.toStringAsFixed(0));
    return sanitizedTime;
  }

  String getAdhanPath() {
    final int adhanId = SharedPrefs().getSelectedAdhanId;
    final String? adhanPath = adhanList.elementAt(adhanId).path;
    final String defaultPath = "/adhan/madina.mp3"; // incase of error
    return adhanPath ?? defaultPath;
  }

  int getCountdownlimit() {
    final int countdownTime = SharedPrefs().getCountdownTimer;
    final int countdownTimeInSeconds = countdownTime * 60;
    return countdownTimeInSeconds;
  }

  DateComponents getDateComponentsFromIsoDay(int day) {
    final int year = DateTime.now().year;

    final DateTime firstDayOfYear = DateTime(year, 1, 1);
    final DateTime date = firstDayOfYear.add(Duration(days: day));

    return DateComponents(year, date.month, date.day);
  }

  List<int> getAdhanTimeArray(int day, Duration offset) {
    final PrayerConfigModel config = PrayerUtils().getPrayerConfig();

    final DateComponents date = getDateComponentsFromIsoDay(day);

    final PrayerTimes prayerTimes =
        PrayerTimes(config.cords, date, config.params);

    final int fajr = sanitizeTimestamp(prayerTimes.fajr, offset);
    final int dhuhr = sanitizeTimestamp(prayerTimes.dhuhr, offset);
    final int asr = sanitizeTimestamp(prayerTimes.asr, offset);
    final int maghrib = sanitizeTimestamp(prayerTimes.maghrib, offset);
    final int isha = sanitizeTimestamp(prayerTimes.isha, offset);

    return [fajr, dhuhr, asr, maghrib, isha];
  }

  BluetoothCharacteristic getRxCharacterstic(BluetoothService service) {
    return service.characteristics
        .firstWhere((charc) => charc.properties.write == true);
  }

  BluetoothCharacteristic getTxCharacterstic(BluetoothService service) {
    return service.characteristics
        .firstWhere((charc) => charc.properties.write != true);
  }

  Future<void> setNotification(
      Function(String) callback, BluetoothService service) async {
    try {
      final BluetoothCharacteristic txCharacterstic =
          getTxCharacterstic(service);

      await txCharacterstic.setNotifyValue(true);
      txCharacterstic.value.listen((value) {
        final String notificationResult = utf8.decode(value);
        callback(notificationResult);
      });
    } catch (e) {
      return Future.error(BleError.sendingCommand.errMsg);
    }
  }

  Future<String> sendBlueCommand(
      Map<String, Object> cmd, BluetoothService service) async {
    try {
      final BluetoothCharacteristic rxCharacterstic =
          getRxCharacterstic(service);
      final BluetoothCharacteristic txCharacterstic =
          getTxCharacterstic(service);

      String payloadJson = jsonEncode(cmd);
      final List<int> payload = payloadJson.codeUnits;

      // Send Command
      await rxCharacterstic.write(payload);

      // Read response
      List<int> responseFromBle = await txCharacterstic.read();
      final String result = utf8.decode(responseFromBle);

      return result;
    } catch (e) {
      return Future.error(BleError.sendingCommand.errMsg);
    }
  }

  int getLastAyahIndexOfSurah(int surahIndex) =>
      ayahsInQuran.elementAt(surahIndex);

  String getLoopLabel(int loopCount) {
    switch (loopCount) {
      case 2:
        return 'Loop x2';
      case 1:
        return 'Loop';
      default:
        return 'Off';
    }
  }

  List<String> getSelectionLabels(RemoteOnSelectionModel selection) {
    String startSurahName = surahsInQuran.elementAt(
      selection.startSurah - 1, // -1 to compensate for array index
    );
    String surahLabel = "$startSurahName";
    String startAyahLabel = "${tr('ayah')} ${selection.startAyah}";
    String endAyahLabel = "${tr('ayah')} ${selection.endAyah}";

    return [surahLabel, startAyahLabel, endAyahLabel];
  }

  int getLastAyahNumberInSurah(int surahIndex) {
    return ayahsInQuran.elementAt(surahIndex - 1);
  }

  RemoteOnSelectionModel onSelectionChange({
    required int val,
    required RemoteSelectionItem type,
    required RemoteOnSelectionModel old,
  }) {
    bool sameSurahs = old.startSurah == old.endSurah;
    bool invalidValue =
        type == RemoteSelectionItem.endAyah && val < old.startAyah;

    switch (type) {
      case RemoteSelectionItem.startSurah:
        return RemoteOnSelectionModel(
          startSurah: val,
          endSurah: val,
          startAyah: 1,
          endAyah: getLastAyahNumberInSurah(val),
        );
      case RemoteSelectionItem.startAyah:
        return RemoteOnSelectionModel(
          startSurah: old.startSurah,
          endSurah: old.endSurah,
          startAyah: val,
          endAyah: getLastAyahNumberInSurah(old.startSurah),
        );
      case RemoteSelectionItem.endSurah:
        return RemoteOnSelectionModel(
          startSurah: old.startSurah,
          endSurah: val + old.startSurah - 1,
          startAyah: old.startAyah,
          endAyah: getLastAyahNumberInSurah(val + old.startSurah - 1),
        );
      case RemoteSelectionItem.endAyah:
        return RemoteOnSelectionModel(
          startSurah: old.startSurah,
          endSurah: old.endSurah,
          startAyah: old.startAyah,
          endAyah: sameSurahs && invalidValue ? old.startAyah : val,
        );
    }
  }
}
