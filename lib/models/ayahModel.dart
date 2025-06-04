class AyahModel {
  final int id;
  final int ayahNumberInSurah;
  final String text;
  final String translation;
  final bool hasSajda;
  final bool hasRuku;

  AyahModel({
    required this.id,
    required this.text,
    required this.translation,
    required this.hasSajda,
    required this.hasRuku,
    required this.ayahNumberInSurah,
  });
}
