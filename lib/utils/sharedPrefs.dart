import 'dart:convert';
import 'package:masjidhub/utils/enums/qiblaWatchSyncApps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_of_year/week_of_year.dart';

import 'package:masjidhub/constants/strings.dart';
import 'package:masjidhub/models/adhanTimeModel.dart';
import 'package:masjidhub/models/coordinateModel.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/utils/enums/surahFontSize.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/models/quranBox/quranBoxDevice.dart';
import 'package:masjidhub/models/tesbih/tesbihDataModel.dart';
import 'package:masjidhub/utils/enums/tesbihAnalyticsEnums.dart';
import 'package:masjidhub/utils/tesbihUtils.dart';

import '../models/placesModel.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  List<String> allStoredPrefs = [
    keyIsSetupCompleted,
    keyLattitude,
    keyLongitude,
    keyAddress,
    keyBearing,
    keyPrayerListSettings,
    keySelectedAdhanId,
    keyCountdownTimer,
    keyCountdownAudioId,
    keyMadhabId,
    keyOrgId,
    keyQiblaHelperTextViewed,
    keySurahFontSize,
    keyTranslationFontSize,
    keyNotificationLastUpdated,
    keyBookmarks,
    keyDownloadedSurahs,
    keyNotificationLastLocation,
    keyRecentSurahs,
    keyQuranBoxDevice,
    keyPlaybackRate,
    keyNewFeatureViewed,
    keyTesbihGoal,
    keyTesbihCountToday,
    keyTesbihAnalyticsDaily,
    keyTesbihAnalyticsWeekly,
    keyTesbihAnalyticsYearly,
    keyRemoteOnSurahLoopCount,
    keyAltitude,
    keyHomeMasjidSyncStatus,
    keySurahTranslationLanguage,
    keyRemoteOnRecentSurah,
    keyHasAdpConnectBefore,
    keyRemoteVol,
    keyLastSelectedLocation,
  ];

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
    // final testLog =
    //     allStoredPrefs.map((key) => '$key: ${_sharedPrefs!.get(key)}');
    // print(testLog);
    // _sharedPrefs?.clear();
  }

  // SETUP //
  bool _isSetupCompleted = _sharedPrefs?.getBool(keyIsSetupCompleted) ?? false;

  bool get isSetupCompleted => _isSetupCompleted;

  Future<void> setIsSetupCompleted(bool isSetupCompleted) async =>
      _sharedPrefs?.setBool(keyIsSetupCompleted, isSetupCompleted);

  Future<void> setLocation(
      double lat, double lon, String address, String addressMobile) async {
    _sharedPrefs?.setDouble(keyLattitude, lat);
    _sharedPrefs?.setDouble(keyLongitude, lon);
    _sharedPrefs?.setString(keyAddress, address);
    _sharedPrefs?.setString(keyAddressForMobile, addressMobile);
  }

  String? _address = _sharedPrefs?.getString(keyAddress);

  String? _addressMobile = _sharedPrefs?.getString(keyAddressForMobile);

  bool? _automaticLocation = _sharedPrefs?.getBool(keyAutomaticLocation);

  bool? _syncAllApps = _sharedPrefs?.getBool(keySyncAllApps);

  bool? _syncCalls = _sharedPrefs?.getBool(keySyncCalls);

  bool? _syncMessages = _sharedPrefs?.getBool(keySyncMessages);

  bool? _syncWhatsapp = _sharedPrefs?.getBool(keySyncWhatsapp);

  bool? _syncTime = _sharedPrefs?.getBool(keySyncTime);

  bool? _syncCalender = _sharedPrefs?.getBool(keySyncCalender);

  String get getAddress =>
      _address ?? 'Unable to locate, Please refresh location';

  bool get getAutomatic => _automaticLocation ?? false;

  bool get getSyncAllApps => _syncAllApps ?? false;

  bool get getSyncCalls => _syncCalls ?? false;

  bool get getSyncMessages => _syncMessages ?? false;

  bool get getSyncWhatsapp => _syncWhatsapp ?? false;

  bool get getSyncTime => _syncTime ?? false;

  bool get getSyncCalender => _syncCalender ?? false;

  String get getAddressMobile =>
      _addressMobile ?? 'Unable to locate, Please refresh location';

  Future<void> setAddress(String address) async {
    _sharedPrefs?.setString(keyAddress, address);
  }

  Future<void> setSyncAllApps(bool value, bool turnAll) async {
    _sharedPrefs?.setBool(keySyncAllApps, value);

    if (turnAll) {
      _sharedPrefs?.setBool(keySyncCalls, value);
      _sharedPrefs?.setBool(keySyncMessages, value);
      _sharedPrefs?.setBool(keySyncWhatsapp, value);
      _sharedPrefs?.setBool(keySyncTime, value);
      _sharedPrefs?.setBool(keySyncCalender, value);
    }
  }

  Future<void> setSyncCalls(bool value) async {
    _sharedPrefs?.setBool(keySyncCalls, value);
  }

  Future<void> setSyncMessages(bool value) async {
    _sharedPrefs?.setBool(keySyncMessages, value);
  }

  Future<void> setSyncTime(bool value) async {
    _sharedPrefs?.setBool(keySyncTime, value);
  }

  Future<void> setSyncWhatsapp(bool value) async {
    _sharedPrefs?.setBool(keySyncWhatsapp, value);
  }

  Future<void> setSyncCalender(bool value) async {
    _sharedPrefs?.setBool(keySyncCalender, value);
  }

  Future<void> setAutomatic(bool automaticLocation) async {
    _sharedPrefs?.setBool(keyAutomaticLocation, automaticLocation);
  }

  Cords? get getUserCords {
    final double? lat = _sharedPrefs?.getDouble(keyLattitude);
    final double? lon = _sharedPrefs?.getDouble(keyLongitude);
    if (lat == null || lon == null) return null;
    return Cords(lat: lat, lon: lon);
  }

  // Bearing from Mecca
  final double defualtBearing = 0;
  double? _bearing = _sharedPrefs?.getDouble(keyBearing);

  double get getBearing => _bearing ?? defualtBearing;

  Future<void> setBearing(double? bearing) async =>
      _sharedPrefs?.setDouble(keyBearing, bearing ?? defualtBearing);

  bool? _logger = _sharedPrefs?.getBool(keyLogger);

  bool get getLogger => _logger ?? false;

  Future<void> setLogger(bool value) async =>
      _sharedPrefs?.setBool(keyLogger, value);

  // Prayer Timings Data //
  Future<void> setPrayerTimesList(List<AdhanTimeModel> list) async {
    List<Map<String, dynamic>> object = list.map((e) => e.toJson()).toList();
    String listJson = jsonEncode(object);
    _sharedPrefs?.setString(keyPrayerListSettings, listJson);
  }

  Future<List<AdhanTimeModel>?>? getPrayerTimesList() async {
    String? jsonList = _sharedPrefs?.getString(keyPrayerListSettings);
    return PrayerUtils().decodePrayerTimingsList(jsonList);
  }

  // Adhan Recitor Id//
  final int defaultAdhanId = 0;
  int? _selectedAdhanId = _sharedPrefs?.getInt(keySelectedAdhanId);

  int get getSelectedAdhanId => _selectedAdhanId ?? defaultAdhanId;

  Future<void> setSelectedAdhanId(int? adhanId) async =>
      _sharedPrefs?.setInt(keySelectedAdhanId, adhanId ?? defaultAdhanId);

  // Countdown Timer //
  final int defualtCountDownTimer = 20;
  int? _countdownTimer = _sharedPrefs?.getInt(keyCountdownTimer);

  int get getCountdownTimer => _countdownTimer ?? defualtCountDownTimer;

  Future<void> setCountdownTimer(int? time) async =>
      _sharedPrefs?.setInt(keyCountdownTimer, time ?? defualtCountDownTimer);

  final int defaultCountdownAudioId = 0;
  int? _selectedCountdownAudioId = _sharedPrefs?.getInt(keyCountdownAudioId);

  int get getSelectedCountdownAudioId =>
      _selectedCountdownAudioId ?? defaultCountdownAudioId;

  Future<void> setCountdownAudioId(int? audioId) async => _sharedPrefs?.setInt(
      keyCountdownAudioId, audioId ?? defaultCountdownAudioId);

  final int defaultMadhabId = 1;
  int? _selectedMadhabId = _sharedPrefs?.getInt(keyMadhabId);

  int get getSelectedMadhabId => _selectedMadhabId ?? defaultMadhabId;

  Future<void> setSelectedMadhabId(int? madhabId) async =>
      _sharedPrefs?.setInt(keyMadhabId, madhabId ?? defaultMadhabId);

  final int defaultOrgId = -1;
  int? _selectedOrgId = _sharedPrefs?.getInt(keyOrgId);

  int get getSelectedOrgId => _selectedOrgId ?? defaultOrgId;

  Future<void> setSelectedOrgId(int? id) async =>
      _sharedPrefs?.setInt(keyOrgId, id ?? defaultOrgId);

  // Qibla //
  final bool defaultQiblaHelperTextViewed = false;
  bool? _qiblaHelperTextViewed =
      _sharedPrefs?.getBool(keyQiblaHelperTextViewed);

  bool get getQiblaHelperTextViewed =>
      _qiblaHelperTextViewed ?? defaultQiblaHelperTextViewed;

  Future<void> setQiblaHelperTextViewed(bool? bool) async => _sharedPrefs
      ?.setBool(keyQiblaHelperTextViewed, bool ?? defaultQiblaHelperTextViewed);

  // Selected Quran Recitor //
  final int defaultQuranRecitor = 0;
  int? _selectedQuranRecitor = _sharedPrefs?.getInt(keySelectedQuranRecitor);

  int get getSelectedQuranRecitor =>
      _selectedQuranRecitor ?? defaultQuranRecitor;

  Future<void> setQuranRecitor(int? recitorId) async => _sharedPrefs?.setInt(
      keySelectedQuranRecitor, recitorId ?? defaultQuranRecitor);

  // Selected Surah Font Size //
  final FontSize defaultSurahFontSize = FontSize.medium;
  FontSize? _surahFontSize =
      QuranUtils().parseSurahFontSize(_sharedPrefs?.getInt(keySurahFontSize));

  FontSize get getSurahFontSize => _surahFontSize ?? defaultSurahFontSize;

  Future<void> setSurahFontSize(FontSize size) async =>
      _sharedPrefs?.setInt(keySurahFontSize, size.index);

  // Selected TranslationFontSize Font Size //
  final FontSize defaultTranslationFontSize = FontSize.medium;
  FontSize? _translationFontSize = QuranUtils()
      .parseSurahFontSize(_sharedPrefs?.getInt(keyTranslationFontSize));

  FontSize get getTranslationFontSize =>
      _translationFontSize ?? defaultTranslationFontSize;

  Future<void> setTranslationFontSize(FontSize size) async =>
      _sharedPrefs?.setInt(keyTranslationFontSize, size.index);

  // Notification Last updated //
  final int defaultNotificationLastUpdated =
      DateTime.now().subtract(Duration(days: 1)).day;
  int? _notificationLastUpdated =
      _sharedPrefs?.getInt(keyNotificationLastUpdated);

  int get getNotificationLastUpdated =>
      _notificationLastUpdated ?? defaultNotificationLastUpdated;
  int today = DateTime.now().day;

  Future<void> setNotificationUpdated() async =>
      _sharedPrefs?.setInt(keyNotificationLastUpdated, today);

  // Notification Last location //
  final String defaultNotificationLastLocation = '';
  String? _notificationLastLocation =
      _sharedPrefs?.getString(keyNotificationLastLocation);

  String get getNotificationLastLocation =>
      _notificationLastLocation ?? defaultNotificationLastLocation;

  Future<void> setNotificationLocation() async {
    _sharedPrefs?.setString(keyNotificationLastLocation, getAddress);
  }

  bool isNotificationLocationChanged() {
    return getNotificationLastLocation != getAddress;
  }

  Future<void> setLastSelectedLocation(PlacesModel model) async {
    await _sharedPrefs?.setString(keyLastSelectedLocation, model.toString());
  }

  Future<PlacesModel?> getLastSelectedLocation() async {
    String? value = _sharedPrefs?.getString(keyLastSelectedLocation);
    if (value == null) return null;
    return PlacesModel.fromString(value);
  }

  // Bookmarks //
  final List<BookmarkModel> defaultBookmarks = [];

  Future<List<BookmarkModel>> getBookmarks() async {
    String? jsonList = _sharedPrefs?.getString(keyBookmarks);
    return QuranUtils().decodeBookmarks(jsonList) ?? defaultBookmarks;
  }

  Future<void> setBookmarks(List list) async {
    String listJson = jsonEncode(list);
    _sharedPrefs?.setString(keyBookmarks, listJson);
  }

  // Downloaded Surahs //
  final List<int> defaultDownloadedSurahs = [];

  Future<List<int>> getDownloadedSurahs() async {
    String? jsonList = _sharedPrefs?.getString(keyDownloadedSurahs);
    return QuranUtils().decodeDownloadedSurahs(jsonList) ??
        defaultDownloadedSurahs;
  }

  Future<void> setDownloadedSurahs(int surah) async {
    final List<int> list = await getDownloadedSurahs();
    if (list.contains(surah)) return;
    String listJson = jsonEncode([surah, ...list]);
    _sharedPrefs?.setString(keyDownloadedSurahs, listJson);
  }

  // Recent Surah //
  final AudioPlayerStateModel defaultRecentSurah = AudioPlayerStateModel();

  Future<AudioPlayerStateModel> getRecentSurah() async {
    String? json = _sharedPrefs?.getString(keyRecentSurahs);
    if (json == null) return defaultRecentSurah;
    return AudioPlayerStateModel.fromJson(jsonDecode(json));
  }

  Future<void> setRecentSurah(AudioPlayerStateModel state) async {
    String json = jsonEncode(state);
    _sharedPrefs?.setString(keyRecentSurahs, json);
  }

  // QuranBox Device
  final QuranBoxDevice defaultQuranBoxDevice =
      QuranBoxDevice(name: 'My MasjidHub');

  Future<QuranBoxDevice> getQuranBoxDevice() async {
    String? json = _sharedPrefs?.getString(keyQuranBoxDevice);
    if (json == null) return defaultQuranBoxDevice;
    return QuranBoxDevice.fromJson(jsonDecode(json));
  }

  Future<void> setQuranBoxDevice(QuranBoxDevice device) async {
    String json = jsonEncode(device);
    _sharedPrefs?.setString(keyQuranBoxDevice, json);
  }

  // Set Playback Rate
  final double defaultPlaybackRate = 1;
  double? _playbackRate = _sharedPrefs?.getDouble(keyPlaybackRate);

  double get getPlaybackRate => _playbackRate ?? defaultPlaybackRate;

  Future<void> setPlaybackRate(double? rate) async =>
      _sharedPrefs?.setDouble(keyPlaybackRate, rate ?? defaultPlaybackRate);

  // New Feature Viewed
  final bool defaultNewFeatureViewed = false;
  bool? _newFeatureViewed = _sharedPrefs?.getBool(keyNewFeatureViewed);

  bool get getNewFeatureViewed => _newFeatureViewed ?? defaultNewFeatureViewed;

  Future<void> setNewFeatureViewed() async =>
      _sharedPrefs?.setBool(keyNewFeatureViewed, true);

  // Tesbih Dhikr Goal //
  final int defaultTesbihGoal = 33;
  int? _tesbihGoal = _sharedPrefs?.getInt(keyTesbihGoal);

  int get getTesbihGoal => _tesbihGoal ?? defaultTesbihGoal;

  Future<void> setTesbihGoal(int? goal) async =>
      _sharedPrefs?.setInt(keyTesbihGoal, goal ?? defaultTesbihGoal);

  // Today - Tesbih Analytics //
  String? _tesbihCountTodayObject =
      _sharedPrefs?.getString(keyTesbihCountToday);

  TesbihDataModel? get todaysCummulativeTesbihCount {
    if (_tesbihCountTodayObject == null) return null;
    return TesbihDataModel.fromJson(
        jsonDecode(_tesbihCountTodayObject ?? "") as Map<String, dynamic>);
  }

  int get getTesbihCountToday {
    if (_tesbihCountTodayObject == null) return 0;
    return todaysCummulativeTesbihCount!.count;
  }

  void incrementTesbihCountToday() {
    final int prevTesbihCount = getTesbihCountToday;
    final int dailyCountIncrement = prevTesbihCount + 1;

    final TesbihDataModel dailyTesbihData = TesbihUtils()
        .getTesbihData(dailyCountIncrement, TesbihAnalyticsState.daily);

    final TesbihDataModel weeklyTesbihData = TesbihUtils()
        .getTesbihData(dailyCountIncrement, TesbihAnalyticsState.weekly);

    final TesbihDataModel monthlyTesbihData = TesbihUtils()
        .getTesbihData(dailyCountIncrement, TesbihAnalyticsState.monthly);

    final TesbihDataModel yearlyTesbihData = TesbihUtils()
        .getTesbihData(dailyCountIncrement, TesbihAnalyticsState.yearly);

    setTesbihAnalyticsDailyData(dailyTesbihData);
    setTesbihAnalyticsWeeklyData(weeklyTesbihData);
    setTesbihAnalyticsMonthlyData(monthlyTesbihData);
    setTesbihAnalyticsYearlyData(yearlyTesbihData);

    _sharedPrefs?.setString(keyTesbihCountToday, jsonEncode(dailyTesbihData));
  }

  void resetTodaysCummulativeTesbihCount() {
    final TesbihDataModel tesbihData = TesbihDataModel(
        count: 0, unixDate: DateTime.now().millisecondsSinceEpoch);
    _sharedPrefs?.setString(keyTesbihCountToday, jsonEncode(tesbihData));
  }

  // Daily - Tesbih Analytics //
  String? _tesbihAnalyticsDailyObject =
      _sharedPrefs?.getString(keyTesbihAnalyticsDaily);

  List<TesbihDataModel> get getTesbihAnalyticsDailyList {
    if (_tesbihAnalyticsDailyObject == null) return [];

    final List<dynamic> rawList = jsonDecode(_tesbihAnalyticsDailyObject ?? '');

    final List<TesbihDataModel> dailyList =
        rawList.map((item) => TesbihDataModel.fromJson(item)).toList();

    return dailyList;
  }

  void setTesbihAnalyticsDailyList(List<TesbihDataModel> list) {
    _sharedPrefs?.setString(keyTesbihAnalyticsDaily, jsonEncode(list));
  }

  void setTesbihAnalyticsDailyData(TesbihDataModel newData) {
    final DateTime today = DateTime.now();

    final List<TesbihDataModel> oldList = getTesbihAnalyticsDailyList;

    List<TesbihDataModel> listData = oldList;

    final int todaysDataIndexOldList = oldList.indexWhere((el) =>
        today.day == DateTime.fromMillisecondsSinceEpoch(el.unixDate).day);

    if (todaysDataIndexOldList == -1) {
      listData.add(newData);
    } else {
      listData[todaysDataIndexOldList] = newData;
    }

    setTesbihAnalyticsDailyList(listData);
  }

  // Weekly - Tesbih Analytics //
  String? _tesbihAnalyticsWeeklyObject =
      _sharedPrefs?.getString(keyTesbihAnalyticsWeekly);

  List<TesbihDataModel> get getTesbihAnalyticsWeeklyList {
    if (_tesbihAnalyticsDailyObject == null) return [];

    final List<dynamic> rawList =
        jsonDecode(_tesbihAnalyticsWeeklyObject ?? "[]");

    final List<TesbihDataModel> weeklyList =
        rawList.map((item) => TesbihDataModel.fromJson(item)).toList();

    return weeklyList;
  }

  void setTesbihAnalyticsWeeklyList(List<TesbihDataModel> list) {
    _sharedPrefs?.setString(keyTesbihAnalyticsWeekly, jsonEncode(list));
  }

  void setTesbihAnalyticsWeeklyData(TesbihDataModel newData) {
    final DateTime today = DateTime.now();

    final List<TesbihDataModel> oldList = getTesbihAnalyticsWeeklyList;

    List<TesbihDataModel> listData = oldList;

    final int weeklyDataIndexOldList = oldList.indexWhere((el) =>
        today.weekOfYear ==
        DateTime.fromMillisecondsSinceEpoch(el.unixDate).weekOfYear);

    if (weeklyDataIndexOldList == -1) {
      listData.add(newData);
    } else {
      listData[weeklyDataIndexOldList] = newData;
    }

    setTesbihAnalyticsWeeklyList(listData);
  }

  // Monthly - Tesbih Analytics //
  String? _tesbihAnalyticsMonthlyObject =
      _sharedPrefs?.getString(keyTesbihAnalyticsMonthly);

  List<TesbihDataModel> get getTesbihAnalyticsMonthlyList {
    if (_tesbihAnalyticsMonthlyObject == null) return [];

    final List<dynamic> rawList =
        jsonDecode(_tesbihAnalyticsMonthlyObject ?? "[]");

    final List<TesbihDataModel> monthlyList =
        rawList.map((item) => TesbihDataModel.fromJson(item)).toList();

    return monthlyList;
  }

  void setTesbihAnalyticsMonthlyList(List<TesbihDataModel> list) {
    _sharedPrefs?.setString(keyTesbihAnalyticsMonthly, jsonEncode(list));
  }

  void setTesbihAnalyticsMonthlyData(TesbihDataModel newData) {
    final DateTime today = DateTime.now();

    final List<TesbihDataModel> oldList = getTesbihAnalyticsMonthlyList;

    List<TesbihDataModel> listData = oldList;

    final int monthlyDataIndexOldList = oldList.indexWhere((el) =>
        today.month == DateTime.fromMillisecondsSinceEpoch(el.unixDate).month);

    if (monthlyDataIndexOldList == -1) {
      listData.add(newData);
    } else {
      listData[monthlyDataIndexOldList] = newData;
    }

    setTesbihAnalyticsMonthlyList(listData);
  }

  // Yearly - Tesbih Analytics //
  String? _tesbihAnalyticsYearlyObject =
      _sharedPrefs?.getString(keyTesbihAnalyticsYearly);

  List<TesbihDataModel> get getTesbihAnalyticsYearlyList {
    if (_tesbihAnalyticsYearlyObject == null) return [];

    final List<dynamic> rawList =
        jsonDecode(_tesbihAnalyticsYearlyObject ?? "[]");

    final List<TesbihDataModel> yearlyList =
        rawList.map((item) => TesbihDataModel.fromJson(item)).toList();

    return yearlyList;
  }

  void setTesbihAnalyticsYearlyList(List<TesbihDataModel> list) {
    _sharedPrefs?.setString(keyTesbihAnalyticsYearly, jsonEncode(list));
  }

  void setTesbihAnalyticsYearlyData(TesbihDataModel newData) {
    final DateTime today = DateTime.now();

    final List<TesbihDataModel> oldList = getTesbihAnalyticsYearlyList;

    List<TesbihDataModel> listData = oldList;

    final int yearlyDataIndexOldList = oldList.indexWhere((el) =>
        today.year == DateTime.fromMillisecondsSinceEpoch(el.unixDate).year);

    if (yearlyDataIndexOldList == -1) {
      listData.add(newData);
    } else {
      listData[yearlyDataIndexOldList] = newData;
    }

    setTesbihAnalyticsYearlyList(listData);
  }

  // Remote On Surah Lopp count //
  final int defaultRemoteOnSurahLoopCount = 0;
  int? _remoteOnSurahLoopCount =
      _sharedPrefs?.getInt(keyRemoteOnSurahLoopCount);

  int get getRemoteOnSurahLoopCount =>
      _remoteOnSurahLoopCount ?? defaultRemoteOnSurahLoopCount;

  Future<void> setRemoteOnSurahLoopCount(int? count) async =>
      _sharedPrefs?.setInt(
          keyRemoteOnSurahLoopCount, count ?? defaultRemoteOnSurahLoopCount);

  // Set Altitude
  final double defaultAltitude = 0;
  double? _altitude = _sharedPrefs?.getDouble(keyAltitude);

  double get getAltitude => _altitude ?? defaultAltitude;

  Future<void> setAltitude(double? alt) async =>
      _sharedPrefs?.setDouble(keyAltitude, alt ?? defaultAltitude);

  // incomplete when home masjid is not sync at all
  // offlinePrayerTimes when device calculates its own prayertimes
  // onlinePrayerTimes when device uses online prayertimes data
  final String defaultHomeMasjidSyncStatus = "incomplete";
  String? _homeMasjidSyncStatus =
      _sharedPrefs?.getString(keyHomeMasjidSyncStatus);

  String get getHomeMasjidSyncStatus =>
      _homeMasjidSyncStatus ?? defaultHomeMasjidSyncStatus;

  Future<void> setHomeMasjidSyncStatus(String? status) async =>
      _sharedPrefs?.setString(
        keyHomeMasjidSyncStatus,
        status ?? defaultHomeMasjidSyncStatus,
      );

  Future<bool> shouldSyncHomeMasjid() async {
    return getHomeMasjidSyncStatus == 'incomplete';
  }

  // Surah translation language
  final String defaultSurahTranslationLanguage = "default";
  String? _surahTranslationLanguage =
      _sharedPrefs?.getString(keySurahTranslationLanguage);

  String get getSurahTranslationLanguage =>
      _surahTranslationLanguage ?? defaultSurahTranslationLanguage;

  Future<void> setSurahTranslationLanguage(String? languageCode) async =>
      _sharedPrefs?.setString(
        keySurahTranslationLanguage,
        languageCode ?? defaultSurahTranslationLanguage,
      );

  // Remote On Recent Surah
  final int defaultRemoteOnRecentSurah = 0;
  int? _remoteOnRecentSurah = _sharedPrefs?.getInt(keyRemoteOnRecentSurah);

  int get getRemoteOnRecentSurah =>
      _remoteOnRecentSurah ?? defaultRemoteOnRecentSurah;

  Future<void> setRemoteOnRecentSurah(int? surahId) async =>
      _sharedPrefs?.setInt(
        keyRemoteOnRecentSurah,
        surahId ?? defaultRemoteOnRecentSurah,
      );

  // Remote Volume
  final int defaultRemoteVol = 0;
  int? _remoteVol = _sharedPrefs?.getInt(keyRemoteVol);

  int get getRemoteVol => _remoteVol ?? defaultRemoteVol;

  Future<void> setRemoteVol(int? vol) async =>
      _sharedPrefs?.setInt(keyRemoteVol, vol ?? defaultRemoteVol);

  // Has Adp connected before
  final bool defaultHasAdpConnectBefore = false;
  bool? _hasAdpConnectBefore = _sharedPrefs?.getBool(keyHasAdpConnectBefore);

  bool get getHasAdpConnectBefore =>
      _hasAdpConnectBefore ?? defaultHasAdpConnectBefore;

  Future<void> setHasAdpConnected() async =>
      _sharedPrefs?.setBool(keyHasAdpConnectBefore, true);

  //Qibla Watch sync with apps
  setQiblaWatchSyncStatus(QiblaWatchSyncApp app, bool status) {
    _sharedPrefs?.setBool(keyQiblaWatchSyncStatus + app.name, status);
  }

  getQiblaWatchSyncStatus(QiblaWatchSyncApp app) {
    return _sharedPrefs?.getBool(keyQiblaWatchSyncStatus + app.name) ?? false;
  }
}
