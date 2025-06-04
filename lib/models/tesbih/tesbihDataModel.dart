class TesbihDataModel {
  int count;
  int unixDate;

  TesbihDataModel({
    required this.count,
    required this.unixDate,
  });

  Map<String, dynamic> toJson() => {
        'count': count.toString(),
        'unixDate': unixDate.toString(),
      };

  factory TesbihDataModel.fromJson(Map<String, dynamic> json) {
    return TesbihDataModel(
      count: int.parse(json['count']),
      unixDate: int.parse(json['unixDate']),
    );
  }
}
