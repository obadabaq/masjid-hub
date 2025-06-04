import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/frimware_update.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:provider/provider.dart';
import '../../../common/listTilesList/ListTileItem.dart';
import '../../../provider/prayerTimingsProvider.dart';
import '../../../provider/wathc_provider.dart';
import '../../../utils/locationUtils.dart';
import '../../../utils/tasbeeh_helper.dart';

class QiblaWatchSyncApps extends StatefulWidget {
  const QiblaWatchSyncApps({Key? key}) : super(key: key);

  @override
  State<QiblaWatchSyncApps> createState() => _QiblaWatchSyncAppsState();
}

class _QiblaWatchSyncAppsState extends State<QiblaWatchSyncApps> {

  bool isAllOn = false;
  bool calls = false;
  bool messages = false;
  bool time = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final watchProvider = Provider.of<WatchProvider>(context, listen: false);
      watchProvider.startConnectionProcess(context).whenComplete(() async {
        watchProvider.updateLocation(SharedPrefs().getAddress);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Consumer<WatchProvider>(
        builder: (context, watchProvider, child) {
          return Column(
            children: [
              (watchProvider.isScanning)
                  ? CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              if (watchProvider.isScanning) SizedBox(),
              if (watchProvider.isConnected) ...[
                Text(
                  'ALLOW QIBLA WATCH TO ACCESS',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CustomTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTileItem(
                    title: 'All apps',
                    isLastItem: isAllOn,
                    onSwitchOn: () {
                      setState(() async {
                        messages = true;
                        calls = true;
                        time = true;
                        isAllOn = !isAllOn;
                        watchProvider.syncWatch();

                        PrayerTimingsProvider prayerTimingsProvider =
                            PrayerTimingsProvider();
                        try {
                          List<Map<String, dynamic>> next30DaysPrayerTimes =
                              await prayerTimingsProvider
                                  .getNext30DaysPrayerTimes();
                          // Ensure the data structure is correct
                          next30DaysPrayerTimes.forEach((element) {
                            DateTime date = element['date'];
                            List<DateTime> prayers =
                                (element['prayers'] as List)
                                    .map((p) => p as DateTime)
                                    .toList();
                            print('Date: $date, Prayers: $prayers');
                          });

                          // Send the prayer times to the device
                          watchProvider
                              .updatePrayerTimes(next30DaysPrayerTimes);
                        } catch (e) {
                          print('Error fetching or sending prayer times: $e');
                        }
                      });
                    },
                    onSwitchOff: () {
                      messages = false;
                      calls = false;
                      time = false;
                      watchProvider.syncDateTime(false);
                      watchProvider.syncPrayerTime(false);
                      watchProvider.syncDateLocation(false);
                      watchProvider.syncDateTime(false);
                      watchProvider.syncPrayerTime(false);
                      watchProvider.syncDateLocation(false);
                      watchProvider.syncTsbeeh(false);
                      watchProvider.syncqibla(false);
                      setState(() {
                        isAllOn = !isAllOn;
                      });
                    },
                    tileValue: isAllOn,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CustomTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ListTileItem(
                      //   title: 'Time App',
                      //   isLastItem: false,
                      //   onSwitchOn: () {
                      //     watchProvider.syncDateTime(true);
                      //     watchProvider.updateDateTime();
                      //   },
                      //   onSwitchOff: () {
                      //     watchProvider.syncDateTime(false);
                      //   },
                      //   tileValue: watchProvider.syncDate,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey.withOpacity(0.2),
                      //   ),
                      // ),
                      // ListTileItem(
                      //   title: 'Tasbih App',
                      //   isLastItem: false,
                      //   onSwitchOn: () {
                      //     watchProvider.syncTsbeeh(true);
                      //   },
                      //   onSwitchOff: () {
                      //     watchProvider.syncTsbeeh(false);
                      //   },
                      //   tileValue: watchProvider.syncTasbeeh,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey.withOpacity(0.2),
                      //   ),
                      // ),
                      // ListTileItem(
                      //   title: 'Prayer App',
                      //   isLastItem: false,
                      //   onSwitchOn: () async {
                      //     watchProvider.syncPrayerTime(true);
                      //     PrayerTimingsProvider prayerTimingsProvider =
                      //         PrayerTimingsProvider();
                      //     try {
                      //       List<Map<String, dynamic>> next30DaysPrayerTimes =
                      //           await prayerTimingsProvider
                      //               .getNext30DaysPrayerTimes();
                      //       // Ensure the data structure is correct
                      //       next30DaysPrayerTimes.forEach((element) {
                      //         DateTime date = element['date'];
                      //         List<DateTime> prayers =
                      //             (element['prayers'] as List)
                      //                 .map((p) => p as DateTime)
                      //                 .toList();
                      //         print('Date: $date, Prayers: $prayers');
                      //       });
                      //
                      //       // Send the prayer times to the device
                      //       watchProvider
                      //           .updatePrayerTimes(next30DaysPrayerTimes);
                      //     } catch (e) {
                      //       print('Error fetching or sending prayer times: $e');
                      //     }
                      //   },
                      //   onSwitchOff: () {
                      //     watchProvider.syncPrayerTime(false);
                      //   },
                      //   tileValue: watchProvider.syncPrayer,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey.withOpacity(0.2),
                      //   ),
                      // ),
                      // ListTileItem(
                      //   title: 'Location App',
                      //   isLastItem: false,
                      //   onSwitchOn: () {
                      //     watchProvider.syncDateLocation(true);
                      //     log(SharedPrefs().getAddress.toString());
                      //     watchProvider
                      //         .updateLocation(SharedPrefs().getAddress);
                      //   },
                      //   onSwitchOff: () {
                      //     watchProvider.syncDateLocation(false);
                      //   },
                      //   tileValue: watchProvider.syncLocation,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey.withOpacity(0.2),
                      //   ),
                      // ),
                      // ListTileItem(
                      //   title: 'Qibla App',
                      //   isLastItem: false,
                      //   onSwitchOn: () {
                      //     watchProvider.syncqibla(true);
                      //     double bearing = SharedPrefs().getBearing;
                      //     double adjustedHeading =
                      //         LocationUtils().adjustHeading(0, bearing);
                      //
                      //     String hexAC = bearing
                      //         .toInt()
                      //         .sign
                      //         .abs()
                      //         .toRadixString(16)
                      //         .padLeft(2, '0')
                      //         .toUpperCase();
                      //     String hex1D = adjustedHeading
                      //         .toInt()
                      //         .sign
                      //         .abs()
                      //         .toRadixString(16)
                      //         .padLeft(2, '0')
                      //         .toUpperCase();
                      //
                      //     String command = '1A01F6${hexAC}${hex1D}0';
                      //     log(command);
                      //     watchProvider.sendCommand(command);
                      //   },
                      //   onSwitchOff: () {
                      //     watchProvider.syncqibla(false);
                      //   },
                      //   tileValue: watchProvider.syncqibla1,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4),
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey.withOpacity(0.2),
                      //   ),
                      // ),
                      ListTileItem(
                        title: 'Incoming Calls',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            calls = true;
                          });
                        },
                        onSwitchOff: () {
                          setState(() {
                            calls = false;
                          });
                        },
                        tileValue: calls,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      ListTileItem(
                        title: 'Messages',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            messages = true;
                          });
                        },
                        onSwitchOff: () {
                          setState(() {
                            messages = false;
                          });
                        },
                        tileValue: messages,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      ListTileItem(
                        title: 'World Time',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            time = true;
                          });
                        },
                        onSwitchOff: () {
                          setState(() {
                            time = false;
                          });
                        },
                        tileValue: time,
                      ),
                      // ListTile(
                      Container(
                        height: 1,
                        color: Colors.black12.withOpacity(0.08),
                      ),
                      ListTileItem(
                        title: 'Google Calendar',
                        isLastItem: false,
                        onSwitchOn: () {
                          watchProvider.syncTsbeeh(true);
                        },
                        onSwitchOff: () {
                          watchProvider.syncTsbeeh(false);
                        },
                        tileValue: watchProvider.syncTasbeeh,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      //   title: Text("Open Quran Screen"),
                      //   onTap: () {
                      //     watchProvider.sendCommand('1A01C101010000');
                      //     showAudioPlayerDialog(watchProvider);
                      //   },
                      //   trailing: Icon(
                      //     Icons.mosque_rounded,
                      //     color: Color(0xFF33DBD6),
                      //     size: 40,
                      //   ),
                      // ),
                      // Container(
                      //   height: 1,
                      //   color: Colors.black12,
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // ListTile(
                      //   onTap: () {
                      //     watchProvider.checkAndUpdateFirmware();
                      //   },
                      //   title: Text("Check for new update"),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //   height: 1,
                      //   color: Colors.black12,
                      // ),
                    ],
                  ),
                )
              ],
              SizedBox(
                height: 30,
              ),
              if (watchProvider.errorMessage != null)
                Text(
                  watchProvider.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          );
        },
      ),
    );
  }

  // Function to open the dialog
  // Function to open the dialog with state management using StatefulBuilder
  void showAudioPlayerDialog(WatchProvider watchProvider) {
    Future.delayed(Duration(seconds: 7), () {
      watchProvider.sendCommand('1A01C205');
    });
    Future.delayed(Duration(seconds: 11), () {
      watchProvider.sendCommand('1A01C205');
    });
    bool isPlaying = true; // Initial play state
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Quran Audio Player",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Previous Button
                        IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.skip_previous_rounded,
                              color: Colors.blueAccent),
                          onPressed: () {
                            watchProvider.sendCommand('1A01C206');
                          },
                        ),
                        // Play/Pause Toggle Button
                        IconButton(
                          iconSize: 50,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_filled_rounded,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isPlaying) {
                                watchProvider
                                    .sendCommand('1A01C202'); // Pause Command
                              } else {
                                watchProvider
                                    .sendCommand('1A01C201'); // Play Command
                              }
                              isPlaying = !isPlaying; // Toggle play/pause state
                            });
                          },
                        ),
                        // Next Button
                        IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.skip_next_rounded,
                              color: Colors.blueAccent),
                          onPressed: () {
                            watchProvider.sendCommand('1A01C205');
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1.5),
                  // Close Button
                  ElevatedButton.icon(
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text("Close"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      watchProvider.sendCommand('1A01C202');
                      watchProvider.sendCommand('1A01C207');
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
