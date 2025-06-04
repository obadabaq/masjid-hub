class EditionModel {
  final String name;
  final String identifier;
  final String language;
  final String format;
  final int? bitrate;

  EditionModel({
    this.name = '',
    this.identifier = '',
    required this.language,
    required this.format,
    this.bitrate,
  });

  Map<String, dynamic> toJson() => {'language': language, 'format': format};
}
