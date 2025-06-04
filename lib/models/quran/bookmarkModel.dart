class BookmarkModel {
  final int surah;
  final int ayah;
  final double scrollPosition;

  BookmarkModel({
    required this.surah,
    required this.ayah,
    required this.scrollPosition,
  });

  Map<String, dynamic> toJson() => {
        'surah': surah,
        'ayah': ayah,
        'scrollPosition': scrollPosition,
      };
}
