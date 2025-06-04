import 'package:flutter/material.dart';

class PrayerDialModel with ChangeNotifier {
  final String prayerTitle;
  final Duration timeToPrayer;
  final int progressAngle;
  final int alertTimeInMins;

  PrayerDialModel({
    required this.prayerTitle,
    required this.timeToPrayer,
    required this.progressAngle,
    required this.alertTimeInMins,
  });
}
