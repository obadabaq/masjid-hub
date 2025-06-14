import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/constants/quran.dart';
import 'package:masjidhub/constants/quranMeta.dart';
import 'package:masjidhub/constants/quranRecitations.dart';
import 'package:masjidhub/models/quran/bookmarkModel.dart';
import 'package:masjidhub/models/quran/audioPlayerStateModel.dart';
import 'package:masjidhub/models/quran/surahModel.dart';
import 'package:masjidhub/models/quran/editionModel.dart';
import 'package:masjidhub/models/quranChapterModel.dart';
import 'package:masjidhub/utils/enums/playlistMode.dart';
import 'package:masjidhub/utils/quranUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class QuranProvider extends ChangeNotifier {
  late String _quranText;
  late String quranTranslationText;

  Future<void> getQuranTextFuture() async {
    _quranText = await getQuranText();
  }

  Future<void> getQuranDefaultTranslationFuture(BuildContext context) async {
    quranTranslationText = await getQuranDefaultTranslation(context);
    notifyListeners();
  }

  Future<void> initQuran(BuildContext context) async {
    Future.wait(
        [getQuranTextFuture(), getQuranDefaultTranslationFuture(context)]);
  }

  List<SurahModel> quranMeta =
      QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));

  Future<List<EditionModel>> getAllEditions() async {
    final client = http.Client();
    final editionQuery = EditionModel(language: 'en', format: 'text');

    final Uri request =
        Uri.https(quranApiBaseUrl, '/v1/edition', editionQuery.toJson());
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final List<EditionModel> editionsList =
          QuranUtils().parseEditions(response.body);
      return editionsList;
    } else {
      return Future.error(tr('error'));
    }
  }

  Future<QuranChapterModel> getChapterData({
    required int id,
    required BuildContext context,
  }) async {
    try {
      final int chapterId = id;

      await initQuran(context);

      // final List<EditionModel> editionsList = await getAllEditions();
      // final String editionIdentifer = editionsList[0].identifier;
      // await initQuran();

      return QuranUtils().parseChapterData(
        chapterId: chapterId,
        quranTextData: _quranText,
        quranTranslationData: quranTranslationText,
        quranRecitorId: quranReciter,
        bookMarks: bookmarks,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  // TODO remove comments
  // Future<List<QuranChapterModel>> downloadQuran(String editionId) async {
  //   final client = http.Client();

  //   final Uri request =
  //       Uri.https(quranApiBaseUrl, '/v1/quran/$quranTextIdentifier');
  //   final response = await client.get(request);
  //   if (response.statusCode == 200) {
  //     final result = QuranUtils().parseQuranData(response.body, quranReciter);
  //     return result;
  //   } else {
  //     return Future.error('Error downloding Quran');
  //   }
  // }

  Future<String> getQuranText() async {
    try {
      final String quranText =
          await rootBundle.loadString('assets/quran/quran-uthmani.json');
      return quranText;
    } catch (e) {
      return Future.error(tr('error quran fetch'));
    }
  }

  Future<String> getQuranDefaultTranslation(BuildContext context) async {
    final String languageOrCountryCode =
        await getSurahTranslationLanguage(context);

    String translationPath = QuranUtils().getQuranTranslationPath(
      languageOrCountryCode,
    ); // language code and country code are same
    try {
      final String quranTranslation =
          await rootBundle.loadString(translationPath);
      return quranTranslation;
    } catch (e) {
      return Future.error(tr('error quran translation'));
    }
  }

  // Select Surah
  int? _selectedSurah;
  int get getSelectedSurah => _selectedSurah ?? 1;
  Future<void> setSelectedSurah(int surah) async {
    _selectedSurah = surah;
    notifyListeners();
  }

  // Quran Recitation
  int quranReciter = SharedPrefs().getSelectedQuranRecitor;
  Future<void> onQuranReciterChanged(int id) async {
    quranReciter = id;
    SharedPrefs().setQuranRecitor(id);
    notifyListeners();
  }

  // Search Quran
  bool _isSearchActive = false;
  bool get isSearchActive => _isSearchActive;
  Future<void> toggleSearchActive() async {
    final List<SurahModel> tempList =
        QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));

    _isSearchActive = !isSearchActive;

    if (_isSearchActive) {
      await gotoQuranTab();
    }

    quranMeta = tempList;
    notifyListeners();
  }

  Future<void> filterQuranMetaByString(String query) async {
    List<SurahModel>? completeList =
        QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));
    List<SurahModel> filteredList = completeList
        .where((i) =>
            i.englishName.toLowerCase().contains(query.toLowerCase()) ||
            i.name.contains(query))
        .toList();
    quranMeta = filteredList;
  }

  Future<void> filterQuranMetaByInt(int query) async {
    List<SurahModel>? completeList =
        QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));
    List<SurahModel> filteredList =
        completeList.where((i) => i.id == query).toList();
    quranMeta = filteredList;
  }

  Future<void> resetQuranMeta() async {
    quranMeta = QuranUtils().parseQuranMeta(json.encode(quranMetaRaw));
  }

  Future<void> filterQuranMeta(String? query) async {
    final bool queryIsEmpty = query == null || query == '';
    int? intQuery = int.tryParse(query ?? '');
    if (intQuery != null && !queryIsEmpty) {
      filterQuranMetaByInt(int.parse(query));
    } else if (!queryIsEmpty) {
      filterQuranMetaByString(query.toString());
    } else {
      resetQuranMeta();
    }
    notifyListeners();
  }

  bool _isAudioItemVisible = true;
  bool get isAudioItemVisible => _isAudioItemVisible;
  // ignore: todo
  // TODO remove redundant equation
  void changeAudioItemVisibility(bool visibility) {
    _isAudioItemVisible = visibility;
  }

  static AudioPlayerStateModel _audioState = AudioPlayerStateModel();
  AudioPlayerStateModel get audioState => _audioState;
  void setAudioState(AudioPlayerStateModel state) {
    _audioState = state;
    notifyListeners();
  }

  void resetAudioState() {
    _audioState = AudioPlayerStateModel();
    notifyListeners();
  }

  // Audio Controls
  bool _surahCompleted = false;
  bool get surahCompleted => _surahCompleted;
  AudioPlayer audioPlayer = AudioPlayer();
  // .
  void setSurahCompleted() => _surahCompleted = true;
  void resetSurahState() => _surahCompleted = false;

  bool pauseAudioOnTap(surahNumber) =>
      audioState.surahId == surahNumber &&
      audioState.surahAudioCompletionPercentatge != 100;

  void playAudio(currentAyahPlaying) {
    final EditionModel audioDetails = quranRecitations.elementAt(quranReciter);
    final recitor = audioDetails.identifier;
    final bitrate = audioDetails.bitrate;
    audioPlayer.play(AssetSource(
        '$quranAudioApiBaseUrl/$bitrate/$recitor/$currentAyahPlaying.mp3'));
  }

  Future<void> onAudioPlayButtonPressed(
    int surahNumber,
    int startAyahNumber,
    int totalAyahs, {
    bool isAudioPlayerMode = false,
  }) async {
    // .
    if (!isAudioPlayerMode) resetSurahState();

    if (pauseAudioOnTap(surahNumber)) {
      resetAudioState();
      audioPlayer.pause();
      notifyListeners();
    } else {
      int currentAyahPlaying = startAyahNumber;
      setAudioState(AudioPlayerStateModel(
          surahId: surahNumber, currentlyPlayingAyahId: startAyahNumber));
      playAudio(currentAyahPlaying);
      notifyListeners();

      // When ayah ends, play next ayah until end of surah
      audioPlayer.onPlayerComplete.listen((event) {
        final int nextAyah = currentAyahPlaying + 1;
        setAudioState(AudioPlayerStateModel(
          surahId: surahNumber,
          currentlyPlayingAyahId: nextAyah,
          surahAudioCompletionPercentatge: QuranUtils().getSurahPercentage(
              currentAyahPlaying, startAyahNumber, totalAyahs),
        ));

        // On Last Ayah
        bool isLastAyah =
            currentAyahPlaying == startAyahNumber + totalAyahs - 1;

        if (isLastAyah) {
          currentAyahPlaying = nextAyah;
          setSurahCompleted();
        } else {
          currentAyahPlaying = nextAyah;
          playAudio(currentAyahPlaying);
        }

        notifyListeners();
      });
    }
  }

  late String _socialSharingText;
  late String _socialSharingImagePath;
  late String _copyClipboardAyah;

  Future<void> setSocialSharingText(String text) async {
    _socialSharingText = text;
  }

  Future<void> setCopyClipboardAyah(String text) async {
    _copyClipboardAyah = text;
  }

  Future<void> setSocialSharingImagePath(String path) async {
    _socialSharingImagePath = path;
  }

  Future<String> getSocialSharingText() async {
    return _socialSharingText;
  }

  Future<String> getCopyClipboardAyah() async {
    return _copyClipboardAyah;
  }

  Future<String> getSocialSharingImagePath() async {
    return _socialSharingImagePath;
  }

  late TabController _quranScreenTabController;
  Future<void> setQuranScreenTabController(TabController controller) async {
    _quranScreenTabController = controller;
  }

  Future<void> gotoQuranTab() async {
    bool isQuranTab = _quranScreenTabController.index == 0;
    if (!isQuranTab)
      _quranScreenTabController.animateTo(0, duration: Duration.zero);
  }

  // Bookmarks Surahs
  List<BookmarkModel> bookmarks = [];

  Future<List<BookmarkModel>> getBookmarks() async {
    if (bookmarks.length != 0) {
      return bookmarks;
    } else {
      final List<BookmarkModel> _bookmarks = await SharedPrefs().getBookmarks();
      bookmarks = _bookmarks;
      return _bookmarks;
    }
  }

  Future<void> setBookmarkList(List<BookmarkModel> newList) async {
    bookmarks = newList;
    await SharedPrefs().setBookmarks(newList);
  }

  // Playlist for Remote On
  PlayListMode playListMode = PlayListMode.quran;
  Future<void> setPlayListMode(PlayListMode mode) async {
    playListMode = mode;
    notifyListeners();
  }

  // Quran translation language
  late String surahTranslationLanguage = "default";

  Future<String> getSurahTranslationLanguage(context) async {
    if (surahTranslationLanguage == "default") {
      final Locale? locale = EasyLocalization.of(context)!.currentLocale;
      surahTranslationLanguage = locale!.countryCode!;
      notifyListeners();
      return surahTranslationLanguage;
    }
    return surahTranslationLanguage;
  }

  Future<void> setSurahTranslationLanguage(languageCode) async {
    SharedPrefs().setSurahTranslationLanguage(languageCode);
    surahTranslationLanguage = languageCode;
    notifyListeners();
  }

  String get getBismillahText =>
      QuranUtils().getBissmillahText(surahTranslationLanguage);
}
