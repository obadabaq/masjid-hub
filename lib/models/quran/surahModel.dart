class SurahModel {
  final int id;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final int startAyahNumber;
  final int? bookmarkedAyah;
  final double? bookmarkedScrollPosition;

  SurahModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.startAyahNumber,
    this.bookmarkedAyah,
    this.bookmarkedScrollPosition,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'revelationType': revelationType,
        'numberOfAyahs': numberOfAyahs,
        'startAyahNumber': startAyahNumber,
        'bookmarkedAyah': bookmarkedAyah,
        'bookmarkedScrollPosition': bookmarkedScrollPosition,
      };
}
