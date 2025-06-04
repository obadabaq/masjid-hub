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
}
