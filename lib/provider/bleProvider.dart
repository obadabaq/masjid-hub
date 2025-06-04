import 'dart:convert';
import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:masjidhub/constants/quran.dart';
import 'package:masjidhub/constants/remoteConnectStates.dart';
import 'package:masjidhub/constants/remoteOnRecitors.dart';
import 'package:masjidhub/constants/surahsInQuran.dart';
import 'package:masjidhub/models/audio/remoteOnSelectionModel.dart';
import 'package:masjidhub/models/prayerConfigModel.dart';
import 'package:masjidhub/utils/bleUtils.dart';
import 'package:masjidhub/bleUuid.dart';
import 'package:masjidhub/utils/enums/bleErrors.dart';
import 'package:masjidhub/utils/enums/quranBoxConnectionState.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

const STOP_NOTIFICATION = 'p'; // as per hardware specs

class BleProvider extends ChangeNotifier {
  QuranBoxConnectionState state = QuranBoxConnectionState.disconnected;

  // Remote Settings
  bool isRemoteOn = false;

  Future<void> toggleRemote(bool isSwitchedOn) async {
    isRemoteOn = isSwitchedOn;
    notifyListeners();
  }

  Future<void> setState(QuranBoxConnectionState connectionState) async {
    state = connectionState;
    notifyListeners();
  }

  int _bleTries = 0;
  Future<bool> isBluetoothSwitchedOn() async {
    _bleTries = _bleTries + 1;
    if (_bleTries > 10) return false;

    // Check if BLE is on! https://github.com/boskokg/flutter_blue_plus/issues/206
    // hacky workaround
    bool isOn = await FlutterBluePlus.isOn;
    if (isOn) {
      return true;
    }
    await Future.delayed(Duration(milliseconds: 500));
    return isBluetoothSwitchedOn();
  }

  Future<void> listenToScan() async {
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name == homeMasjid) {
          await r.device.connect(autoConnect: false);
        }
      }
    });
  }

  // This is called when the last command on sendNextCommand succeeds
  // This means that synchronization is completed
  void onConnectionSuccess() async {
    SharedPrefs().setHomeMasjidSyncStatus('offlinePrayerTimes');
    setState(QuranBoxConnectionState.connected);
    toggleRemote(true);
  }

  static Duration connectionDelay = Duration(seconds: 4);

  Future<void> startScan(Function successCallback) async {
    log("messageasdasdasdasda");
    setState(QuranBoxConnectionState.connecting);
    await FlutterBluePlus.startScan(timeout: connectionDelay);
    await listenToScan();

    // to give time for device to connect
    await Future.delayed(Duration(seconds: 1));

    final bool isConnected = await isAlreadyConnected();
    if (isConnected) {
      return synchronizeInitialDataWithMasjidHubDevice(successCallback);
    } else {
      setState(QuranBoxConnectionState.deviceNotFound);
    }
  }

  Future<bool> isAlreadyConnected() async {
    final List<BluetoothDevice> devices = await FlutterBluePlus.connectedDevices;
    final bool isConnected = devices.length != 0;
    return isConnected;
  }

  Future<BluetoothService> getService() async {
    final List<BluetoothDevice> devices = await FlutterBluePlus.connectedDevices;
    final bool isDisconnected = devices.isEmpty;
    if (isDisconnected) return Future.error(BleError.service.errMsg);

    final BluetoothDevice masjidHubDevice = devices[0];
    List<BluetoothService> services = await masjidHubDevice.discoverServices();
    final BluetoothService service =
        services.firstWhere((service) => service.uuid == Guid(bleServiceUuid));

    return service;
  }

  Future<void> onBleCommsError(e) {
    return Future.error(e);
  }

  Future<void> setBleNotification(notificationResponse) async {
    if (notificationResponse == STOP_NOTIFICATION) {
      print("logg:: end of surah");
      _lastPlayedSurah = 0;
      setRemotePlaying(false);
    }
  }

  Future<void> setBleNotificationForOfflinePrayerTimesComplete(
    String notificationResponse,
  ) async {
    print("logg:: $notificationResponse");
    if (notificationResponse.contains(CALCULATING_OFFLINE_PRAYER_TIMES_MSG)) {
      print("logg:: OFFLINE SUCCESS");
      SharedPrefs().setHomeMasjidSyncStatus('offlinePrayerTimes');
      setState(QuranBoxConnectionState.OfflinePrayerTimesSyncComplete);
    }
  }

  Future<void> synchronizeInitialDataWithMasjidHubDevice(
      Function successCallback) async {
    // This is the first command we send that triggers a chain reaction
    // the commands are followed by sendNextCommand

    final BluetoothService service = await getService();
    await BleUtils().setNotification(setBleNotification, service);

    await setSdModeWithService(service);

    final bool shouldSync = await SharedPrefs().shouldSyncHomeMasjid();

    if (shouldSync) {
      print("logg:: Start inital Sync");
      await sendTimeStamp(service);
    } else {
      successCallback();
    }
  }

  Future<void> synchronizeAdhanTimesWithMasjidHubDevice() async {
    // This is the first command we send that triggers a chain reaction
    // the commands are followed by sendNextCommand
    final BluetoothService service = await getService();
    await sendFirstAdhanTime(service);
  }

  Future<void> disconnect() async {
    setState(QuranBoxConnectionState.disconnected);
    FlutterBluePlus.turnOff();
    toggleRemote(false);
  }

  Future<void> sendTimeStamp(BluetoothService service) async {
    final Duration timezoneOffset = DateTime.now().timeZoneOffset;
    final int timestamp = BleUtils().sanitizeTimestamp(
      DateTime.now(),
      timezoneOffset,
    );
    print("logg:: Sending timestamp");
    Map<String, Object> cmd = {"cmd": "setTimestamp", "timestamp": timestamp};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      await sendNextCommand(response, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> sendAdhanAudioPath(BluetoothService service) async {
    final String path = BleUtils().getAdhanPath();
    Map<String, Object> cmd = {"cmd": "setAdhanAudio", "path": path};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      await sendNextCommand(response, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> sendCountdownLimit(BluetoothService service) async {
    final int limit = BleUtils().getCountdownlimit();
    Map<String, Object> cmd = {
      "cmd": "setCountdownLimit",
      "countdownLimit": limit
    };

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      await sendNextCommand(response, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  // Only the first day of the year
  Future<void> sendFirstAdhanTime(BluetoothService service) async {
    print("logg:: SENDING PRAYER TIME DAY 1");
    final Duration timezoneOffset = DateTime.now().timeZoneOffset;
    int firstDayOfYear = 1;

    Map<String, Object> cmd = {
      "cmd": "setAdhanTime",
      "year": DateTime.now().year,
      "dayOfTheYear": firstDayOfYear,
      "AdhanTimes": BleUtils().getAdhanTimeArray(firstDayOfYear, timezoneOffset)
    };

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      dynamic prevCommandObject = resJson['cmdIn'];
      await sendAdhanTimes(prevCommandObject, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> sendAdhanTimes(
    dynamic prevCommandObject,
    BluetoothService service,
  ) async {
    final int prevDayOfYear = prevCommandObject["dayOfTheYear"];

    bool isLasDay = prevDayOfYear == 365;

    if (!isLasDay) {
      int dayOfYear = prevDayOfYear + 1;
      print("logg:: SENDING PRAYER TIME DAY $dayOfYear");
      final Duration timezoneOffset = DateTime.now().timeZoneOffset;

      Map<String, Object> cmd = {
        "cmd": "setAdhanTime",
        "year": DateTime.now().year,
        "dayOfTheYear": dayOfYear,
        "AdhanTimes": BleUtils().getAdhanTimeArray(dayOfYear, timezoneOffset)
      };

      try {
        final response = await BleUtils().sendBlueCommand(cmd, service);
        final dynamic resJson = jsonDecode(response);
        dynamic prevCmd = resJson['cmdIn'];
        await sendAdhanTimes(prevCmd, service);
      } catch (e) {
        return onBleCommsError(e);
      }
    } else {
      SharedPrefs().setHomeMasjidSyncStatus('onlinePrayerTimes');
      setState(QuranBoxConnectionState.prayerTimesSyncComplete);
    }
  }

  // After masjid hub connects, to synchronize all data
  // We need to send the basic commands like
  // timestamp, adhan audio, countdown timer, prayer times
  Future<void> sendNextCommand(
      String prevResponse, BluetoothService service) async {
    final dynamic resJson = jsonDecode(prevResponse);
    final String resCode = resJson['rsp'];
    final isGetVolume = resCode == 'getVolume';

    bool isFailure = resCode != 'ok' &&
        !isGetVolume; // TODO fix get volume command convention, Request Hardware team

    if (isFailure) {
      return Future.error(BleError.response.errMsg);
    }

    dynamic prevCommandObject =
        !isGetVolume ? resJson['cmdIn'] : {"cmd": "getVolume"};

    String prevCommand = prevCommandObject["cmd"];

    switch (prevCommand) {
      case "setTimestamp": // Set Adhan audio after seting timestamp
        return await sendAdhanAudioPath(service);

      case "setAdhanAudio": // Set countdown timer after seting Adhan audio
        return await sendCountdownLimit(service);

      case "setCountdownLimit": // Set device volume after seting countdown timer
        return getVolume(service);

      case "getVolume": // Delete old prayer times
        return deleteOldPrayerTimes(service);

      case "deleteAdhanTimes":
        return onConnectionSuccess();
      default:
        return;
    }
  }

  int _remoteSurahInView = 1;
  int get getRemoteSurahInView => _remoteSurahInView;

  bool _remotePlaying = false;
  bool get isRemotePlaying => _remotePlaying;

  int _lastPlayedSurah = 0;
  int get getLastPlayedSurah => _lastPlayedSurah;

  Future<void> setLastPlayedSurah(int surahId) async {
    _lastPlayedSurah = surahId;
  }

  Future<void> setRemotePlaying(bool isPlaying) async {
    _remotePlaying = isPlaying;
    notifyListeners();
  }

  void setRemoteSurahInView(int surahId) {
    _remoteSurahInView = surahId;
  }

  // Remote Quran Controls
  Future<void> playRemoteSurah({
    int ayahIndex = 0,
    bool goNextOrPrevAyah = false,
  }) async {
    final int surahId = getRemoteSurahInView;
    setRemotePlaying(true);

    final int lastPlayedSurah = getLastPlayedSurah;
    final bool shouldResumePreviousPlayState =
        lastPlayedSurah == surahId && !goNextOrPrevAyah;

    BluetoothService service = await getService();

    Map<String, Object> cmd;

    if (shouldResumePreviousPlayState) {
      //..
      cmd = {"cmd": "sdPlayControl", "action": 1};
      //..
    } else if (remoteOnSurahLoopCount == 0) {
      cmd = {
        "cmd": "playSurah",
        "prefix": "${remoteRecitorPrefix}_",
        "surahIndex": surahId,
        "ayatIndex": ayahIndex,
        "isAutoNext": true
      };
    } else {
      final int endIndex = BleUtils().getLastAyahIndexOfSurah(surahId);
      cmd = {
        "cmd": "playQuranPart",
        "prefix": "${remoteRecitorPrefix}_",
        "surahIndex": surahId,
        "startIndex": 0,
        "endIndex": endIndex,
        "loopCount": remoteOnSurahLoopCount
      };
    }

    SharedPrefs().setRemoteOnRecentSurah(surahId);
    setLastPlayedSurah(surahId);

    try {
      await BleUtils().sendBlueCommand(cmd, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> pauseSurah() async {
    setRemotePlaying(false);
    BluetoothService service = await getService();
    Map<String, Object> cmd = {"cmd": "sdPlayControl", "action": 0};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      print("logg:: $resJson");
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  double _remoteVolume = 0; // volume 1 to 10
  double get getRemoteVoume => _remoteVolume == 0
      ? SharedPrefs().getRemoteVol.toDouble()
      : _remoteVolume;

  Future<void> setRemoteVolume(double volume) async {
    print("logg:: setting volume $volume");
    _remoteVolume = volume;
    SharedPrefs().setRemoteVol(volume.toInt());
    notifyListeners();
  }

  Future<void> getVolume(BluetoothService service) async {
    BluetoothService service = await getService();
    Map<String, Object> cmd = {"cmd": "getVolume"};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      int deviceVolume = resJson['volume'];
      print("logg:: volume $deviceVolume");
      setRemoteVolume(deviceVolume.toDouble());
      await sendNextCommand(response, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> changeVolume(double volume) async {
    print("logg:: changing volume $volume");
    BluetoothService service = await getService();
    int roundedVolume = volume.ceil();
    Map<String, Object> cmd = {"cmd": "setVolume", "volume": roundedVolume};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      print("logg:: volume $resJson");
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> playNextAyah() async {
    if (!isRemotePlaying) return;

    BluetoothService service = await getService();

    Map<String, Object> cmd = {
      "cmd": "getCurrentAudio",
    };

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);

      String prevPlayedFile = resJson['fileName'];
      String ayahNumber = prevPlayedFile.substring(7, 8);
      print("logg:: ayahNumberInt $ayahNumber");
      int ayahNumberInt = int.tryParse(ayahNumber) ?? 0;
      print("logg:: ayahNumberInt $ayahNumberInt");

      int nextAyahNumber = ayahNumberInt;
      // because the device expects the command that start with ayah index 0
      await playRemoteSurah(ayahIndex: nextAyahNumber, goNextOrPrevAyah: true);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> playPreviousAyah() async {
    if (!isRemotePlaying) return;

    BluetoothService service = await getService();

    Map<String, Object> cmd = {
      "cmd": "getCurrentAudio",
    };

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);

      String prevPlayedFile = resJson['fileName'];
      String ayahNumber = prevPlayedFile.substring(7, 8);
      int ayahNumberInt = int.tryParse(ayahNumber) ?? 0;

      print("logg::: ayahNumberInt $ayahNumberInt");

      if (ayahNumberInt > 1) {
        int prevAyahNumber = ayahNumberInt - 2;
        await playRemoteSurah(
            ayahIndex: prevAyahNumber, goNextOrPrevAyah: true);
      }
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> setAdpMode() async {
    print("logg:: setting A2DP mode");
    BluetoothService service = await getService();
    Map<String, Object> cmd = {"cmd": "setPlayerMode", "playerMode": 1};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      print("logg:: response $resJson");
      toggleRemote(false);

      setState(QuranBoxConnectionState.disconnected);

      print("logg:: its disconnecting");
      // disconnect
      List<BluetoothDevice> devices = await FlutterBluePlus.connectedDevices;
      devices[0].disconnect();
    } catch (e) {
      print("logg:: error $e");
      return onBleCommsError(e);
    }
  }

  Future<void> setSdMode() async {
    print("logg:: setting SD mode");
    BluetoothService service = await getService();
    Map<String, Object> cmd = {"cmd": "setPlayerMode", "playerMode": 2};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      print("logg:: response $resJson");
      toggleRemote(true);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> setSdModeWithService(BluetoothService service) async {
    Map<String, Object> cmd = {"cmd": "setPlayerMode", "playerMode": 2};

    try {
      BleUtils().sendBlueCommand(cmd, service);
      toggleRemote(true);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  SwiperController remoteSwiperController = SwiperController();

  Future<void> onPlaylistPlayPress(
    int surahNumber,
    int startAyahNumber,
    int totalAyahs,
  ) async {
    setRemoteSurahInView(surahNumber);
    remoteSwiperController.move(surahNumber - 1, animation: false);
    playRemoteSurah();
    notifyListeners();
  }

  // Remote On Recitor
  String _remoteRecitorPrefix = remoteOnRecitors[0].prefix; // default
  String get remoteRecitorPrefix => _remoteRecitorPrefix;
  Future<void> setRemoteRecitorPrefix(String prefix) async {
    _remoteRecitorPrefix = prefix;
  }

  Future<void> onRemoteRecitorChange(int index) async {
    String newRecitorPrefix = remoteOnRecitors[index].prefix;
    setRemoteRecitorPrefix(newRecitorPrefix);
    notifyListeners();
  }

  String get remoteRecitorName => remoteOnRecitors
      .firstWhere((el) => el.prefix == remoteRecitorPrefix)
      .name;

  // Remote Surah Loop //
  int _remoteOnSurahLoopCount = SharedPrefs().getRemoteOnSurahLoopCount;

  int get remoteOnSurahLoopCount => _remoteOnSurahLoopCount;

  Future<void> setRemoteOnSurahLoopCount(int count) async {
    _remoteOnSurahLoopCount = count;
    await SharedPrefs().setRemoteOnSurahLoopCount(count);
    notifyListeners();
  }

  Future<void> toggleRemoteOnSurahLoopCount() async {
    int newLoopCount = _remoteOnSurahLoopCount;

    // 2 is Max loop count
    if (_remoteOnSurahLoopCount < 2) {
      newLoopCount = _remoteOnSurahLoopCount + 1;
    } else {
      newLoopCount = 0;
    }

    _remoteOnSurahLoopCount = newLoopCount;
    await SharedPrefs().setRemoteOnSurahLoopCount(newLoopCount);
    notifyListeners();
  }

  // Remote selection
  RemoteOnSelectionModel _remoteOnSelection = RemoteOnSelectionModel(
      startSurah: 1, startAyah: 1, endSurah: 1, endAyah: 7);

  RemoteOnSelectionModel get remoteOnSelection => _remoteOnSelection;

  Future<void> setRemoteOnSelection(int val, RemoteSelectionItem type) async {
    final newRemoteOnSelection = BleUtils().onSelectionChange(
      val: val,
      type: type,
      old: remoteOnSelection,
    );

    _remoteOnSelection = newRemoteOnSelection;
    notifyListeners();
  }

  List<int> get getAyahList =>
      [for (var i = 1; i < remoteOnSelection.endAyah + 1; i++) i];

  List<String> get getEndSurahList => [
        for (var i = remoteOnSelection.startSurah - 1; i < 114; i++)
          surahsInQuran.elementAt(i)
      ];

  Future<void> setPlaySelection() async {
    setRemotePlaying(true);
    int surahNumber = remoteOnSelection.startSurah;
    setRemoteSurahInView(surahNumber);
    remoteSwiperController.move(surahNumber - 1, animation: false);
    notifyListeners();

    BluetoothService service = await getService();

    Map<String, Object> cmd = {
      "cmd": "playQuranPart",
      "prefix": "${remoteRecitorPrefix}_",
      "surahIndex": remoteOnSelection.startSurah,
      "startIndex": remoteOnSelection.startAyah,
      "endIndex": remoteOnSelection.endAyah,
      "loopCount": remoteOnSurahLoopCount
    };

    try {
      await BleUtils().sendBlueCommand(cmd, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<void> sendParametersForOfflineConnection() async {
    final BluetoothService service = await getService();

    print("logg:: sending parameters for Offline");

    final PrayerConfigModel prayerConfig = PrayerUtils().getPrayerConfig();

    int madhabId = SharedPrefs().getSelectedMadhabId; // 0 shafi, 1 hanafi
    int asrlen = madhabId + 1; // as per hardware docs

    final double altitude = SharedPrefs().getAltitude;

    Map<String, Object> cmd = {
      "cmd": "setOfflineAdhanTimes",
      "lat": prayerConfig.cords.latitude,
      "lon": prayerConfig.cords.longitude,
      "elev": altitude,
      "tzone": DateTime.now().timeZoneOffset.inHours,
      "fajrA": prayerConfig.params.fajrAngle,
      "ishaA": prayerConfig.params.ishaAngle ?? 0,
      "asrlen": asrlen,
    };

    Future.delayed(const Duration(minutes: 4), () async {
      bool isSyncComplete = await checkIfAzanTimesSyncComplete();
      if (isSyncComplete) {
        print("logg:: OFFLINE SUCCESS");
        SharedPrefs().setHomeMasjidSyncStatus('offlinePrayerTimes');
        setState(QuranBoxConnectionState.OfflinePrayerTimesSyncComplete);
      } else {
        setState(QuranBoxConnectionState.deviceNotFound);
      }
    });

    try {
      await BleUtils().sendBlueCommand(cmd, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }

  Future<bool> checkIfAzanTimesSyncComplete() async {
    final BluetoothService service = await getService();

    print("logg:: checking if all prayer times are complete");

    Map<String, Object> cmd = {
      "cmd": "checkAdhanTimes",
      "year": DateTime.now().year
    };

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      final dynamic resJson = jsonDecode(response);
      bool isAdhanTimesComplete = resJson['isAdhanTimesComplete'] as bool;
      print("logg:: isAdhanTimesComplete $isAdhanTimesComplete");
      return isAdhanTimesComplete;
    } catch (e) {
      onBleCommsError(e);
      return false;
    }
  }

  Future<void> deleteOldPrayerTimes(BluetoothService service) async {
    final int year = DateTime.now().year;

    print("logg:: Deleting old prayer times");
    Map<String, Object> cmd = {"cmd": "deleteAdhanTimes", "year": year};

    try {
      final response = await BleUtils().sendBlueCommand(cmd, service);
      await sendNextCommand(response, service);
    } catch (e) {
      return onBleCommsError(e);
    }
  }
}
