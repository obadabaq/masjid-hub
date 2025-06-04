import 'enums/qiblaWatchSyncApps.dart';

class QiblaWatchSyncUtils{

  static List<QiblaWatchSyncApp> getQiblaWatchSyncAppsList(){
    return QiblaWatchSyncApp.values;
  }
  static String getQiblaWatchSyncAppName(QiblaWatchSyncApp app) {
    switch (app) {
      case QiblaWatchSyncApp.all:
        return "All";
      case QiblaWatchSyncApp.incoming_calls:
        return "Incoming Calls";
      case QiblaWatchSyncApp.messages:
        return "Messages";
      case QiblaWatchSyncApp.whatsapp:
        return "WhatsApp";
      case QiblaWatchSyncApp.google_calender:
        return "Google Calender";
      case QiblaWatchSyncApp.icloud_calender:
        return "ICal";
    }
  }
}