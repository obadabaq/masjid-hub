// import 'dart:async';
// import 'package:device_calendar/device_calendar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:masjidhub/services/google_calendar_service.dart';
// import 'package:masjidhub/services/incoming_calls.dart';
// import 'package:masjidhub/services/telphony.dart';
// import 'package:masjidhub/services/watch_services.dart';
// import 'package:masjidhub/utils/enums/qiblaWatchSyncApps.dart';
// import 'package:masjidhub/utils/sharedPrefs.dart';
// import 'package:moyoung_ble_plugin/moyoung_ble.dart';
//
// class QiblaWatchSyncProvider extends ChangeNotifier {
//   late List<QiblaWatchSyncApp> activeSyncApps;
//   late DeviceCalendarPlugin _deviceCalendarPlugin;
//   var watchChannel = MethodChannel("co.takva/watch");
//
//   final _streamSubscriptions = <StreamSubscription<dynamic>>[];
//   final MoYoungBle _blePlugin = MoYoungBle();
//   final List<BleScanBean> _deviceList = [];
//
//   QiblaWatchSyncProvider() {
//     _deviceCalendarPlugin = DeviceCalendarPlugin();
//     refreshActiveSyncApps();
//   }
//
//   refreshActiveSyncApps() {
//     activeSyncApps = QiblaWatchSyncApp.values
//         .where((app) => getPrefsAppSyncStatus(app) == true)
//         .toList();
//     if (activeSyncApps.length >= QiblaWatchSyncApp.values.length - 1) {
//       activeSyncApps.add(QiblaWatchSyncApp.all);
//     }
//   }
//
//   bool getAppSyncStatus(QiblaWatchSyncApp app) {
//     if (app == QiblaWatchSyncApp.all) {
//       return activeSyncApps.length >= QiblaWatchSyncApp.values.length - 1;
//     }
//     bool val = activeSyncApps.contains(app);
//     return val;
//   }
//
//   bool getPrefsAppSyncStatus(QiblaWatchSyncApp app) {
//     List<QiblaWatchSyncApp> apps = QiblaWatchSyncApp.values;
//     if (app == QiblaWatchSyncApp.all) {
//       for (app in apps) {
//         var value = SharedPrefs().getQiblaWatchSyncStatus(app);
//         if (value == false) {
//           return false;
//         }
//       }
//       return true;
//     }
//     return SharedPrefs().getQiblaWatchSyncStatus(app);
//   }
//
//   Future<void> setAppSyncStatus(QiblaWatchSyncApp app, bool status) async {
//     List<QiblaWatchSyncApp> apps = QiblaWatchSyncApp.values;
//     WatchServices watchServices = WatchServices();
//     IncomingCallsServices incomingCallsServices = IncomingCallsServices();
//
//     if (app == QiblaWatchSyncApp.all) {
//       for (app in apps) {
//         SharedPrefs().setQiblaWatchSyncStatus(app, status);
//       }
//     } else {
//       if (app == QiblaWatchSyncApp.icloud_calender && status == true) {
//         await requestCalendarPermission();
//         List<Event?>? events = await retrieveAllCalendarEvents();
//         for(Event? event in events??[]){
//           if(event != null){
//             var min = event.start?.minute;
//             var hr = event.start?.hour;
//             int id = (event.eventId ?? DateTime.now().millisecondsSinceEpoch) as int;
//             if (hr != null && min != null) {
//               AlarmClockBean alarmClockBean = AlarmClockBean(
//                   enable: true, hour: hr, id: id, minute: min, repeatMode: 0);
//               watchServices.setAlarm(alarmClockBean);
//             }
//           }
//         }
//       }
//       if (app == QiblaWatchSyncApp.google_calender && status == true) {
//         GoogleCalendarService googleCalendarService = GoogleCalendarService();
//         var eventsList = await googleCalendarService.retrieveCalendarEvents();
//
//         for (var event in eventsList) {
//           var min = event.start?.date?.minute;
//           var hr = event.start?.date?.hour;
//           int id = (event.id ?? DateTime.now().millisecondsSinceEpoch) as int;
//           if (hr != null && min != null) {
//             AlarmClockBean alarmClockBean = AlarmClockBean(
//                 enable: true, hour: hr, id: id, minute: min, repeatMode: 0);
//             watchServices.setAlarm(alarmClockBean);
//
//           }
//         }
//
//       }
//       if (app == QiblaWatchSyncApp.whatsapp && status == true) {
//         subscriptStream();
//         startScan();
//       }
//
//       if (app == QiblaWatchSyncApp.messages && status == true) {
//         TelephonyServices telephonyServices = TelephonyServices();
//         telephonyServices.init();
//       }
//
//       if (app == QiblaWatchSyncApp.incoming_calls && status == true) {
//         print("incomingCallsServices");
//         incomingCallsServices.listenToEvents();
//       }
//       SharedPrefs().setQiblaWatchSyncStatus(app, status);
//     }
//     refreshActiveSyncApps();
//     notifyListeners();
//   }
//
//   Future<void> requestCalendarPermission() async {
//     var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
//     if (permissionsGranted.isSuccess &&
//         permissionsGranted.data != null &&
//         !permissionsGranted.data!) {
//       permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
//       if (!permissionsGranted.isSuccess ||
//           permissionsGranted.data == null ||
//           !permissionsGranted.data!) {
//         // Handle permission denial
//         return;
//       }
//     }
//   }
//
//   Future<List<Event?>?>? retrieveAllCalendarEvents() async {
//     final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
//
//     if (calendarsResult.isSuccess) {
//       final calendars = calendarsResult.data;
//
//       // Define a very early start date (e.g., 30 years ago)
//       final startDate = DateTime.now().subtract(Duration(days: 365 * 30));
//
//       // Define a very late end date (e.g., 30 years in the future)
//       final endDate = DateTime.now().add(Duration(days: 365 * 30));
//
//       // Iterate through the calendars
//       for (final calendar in calendars ?? []) {
//         final eventsParams = RetrieveEventsParams(
//           startDate: startDate,
//           endDate: endDate,
//         );
//
//         final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
//           calendar.id,
//           eventsParams,
//         );
//
//         if (eventsResult.isSuccess) {
//           final events = eventsResult.data;
//
//           // Process the events as per your requirements
//           events?.forEach((event) {
//             final startTime = event.start;
//             final endTime = event.end;
//             final endName = event.title;
//
//             // Use the start and end times as needed
//             print('Event Name: $endName');
//             print('Event Start Time: $startTime');
//             print('Event End Time: $endTime');
//
//             // Add more event properties or handling logic as required
//           });
//         return events;
//         } else {
//           print("eventsResult ${eventsResult.hasErrors}");
//         }
//       }
//     } else {
//       // Handle error retrieving calendars
//       print("calendarsResult ${calendarsResult.hasErrors}");
//     }
//     return null;
//   }
//
//   ////
//   void subscriptStream() {
//     _streamSubscriptions.add(
//       _blePlugin.bleScanEveStm.listen(
//         (BleScanBean event) async {
//           // setState(() {
//           print("event ${event.name} ${event.address} ");
//           if (event.isCompleted) {
//             //Scan completed, do something
//           } else {
//             _deviceList.add(event);
//           }
//           // });
//         },
//       ),
//     );
//   }
//
//   void startScan() {
//     _blePlugin
//         .startScan(10 * 1000)
//         .then((value) => {
//               // Do something.
//               print(value ? "Scanning" : "Have not started")
//             })
//         .onError((error, stackTrace) => {
//               //Usually some permissions are not requested
//               print(error.toString())
//             });
//   }
// }
