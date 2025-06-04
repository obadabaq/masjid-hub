class AdhanTimeModel {
  int id;
  String time;
  bool isAlarmDisabled;
  bool isCurrentPrayer;

  AdhanTimeModel(
      {required this.id,
      required this.time,
      required this.isAlarmDisabled,
      required this.isCurrentPrayer});

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'isAlarmDisabled': isAlarmDisabled,
        'isCurrentPrayer': isCurrentPrayer
      };

  factory AdhanTimeModel.fromJson(Map<String, dynamic> json) {
    return AdhanTimeModel(
      id: json['id'] as int,
      time: json['time'] as String,
      isAlarmDisabled: json['isAlarmDisabled'] as bool,
      isCurrentPrayer: json['isCurrentPrayer'] as bool,
    );
  }
}
