class PlacesModel {
  final String id;
  final String title;

  PlacesModel({required this.id, required this.title});

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  factory PlacesModel.fromString(String serialized) {
    try {
      final parts = serialized.split('||');
      if (parts.length != 2) {
        throw const FormatException('Invalid serialized PlacesModel format');
      }
      return PlacesModel(
        id: parts[0].trim(),
        title: parts[1].trim(),
      );
    } catch (e) {
      throw FormatException('Failed to parse PlacesModel from string: $e');
    }
  }

  @override
  String toString() => '$id||$title';
}
