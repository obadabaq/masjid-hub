class AdhanModel {
  final int id;
  final String title;
  final String subTitle;
  final String urlSlug;
  final String? path; // for masjidhub device

  AdhanModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.urlSlug,
    this.path,
  });
}
