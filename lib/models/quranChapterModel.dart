import 'package:masjidhub/models/ayahModel.dart';

class QuranChapterModel {
  final int id;
  final String chapterName;
  final String chapterNameMeaning;
  final List<AyahModel> ayahs;
  final int quranRecitorId;

  QuranChapterModel({
    required this.id,
    required this.chapterName,
    required this.chapterNameMeaning,
    required this.ayahs,
    required this.quranRecitorId,
  });
}
