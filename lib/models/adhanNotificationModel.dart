class AdhanNotificationModel {
  final int hour;
  final int minute;
  final String title;
  final String text;
  final bool playSound;
  final bool isCountdown;
  final int? weekday;

  AdhanNotificationModel({
    required this.hour,
    required this.minute,
    required this.text,
    required this.title,
    required this.playSound,
    required this.isCountdown,
    this.weekday,
  });
}
