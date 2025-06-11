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
  bool whatsApp = false;
  bool calender = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final watchProvider = Provider.of<WatchProvider>(context, listen: false);
      watchProvider.startConnectionProcess(context).whenComplete(() async {
        watchProvider.updateLocation(SharedPrefs().getAddress);
      });
      setState(() {
        isAllOn = SharedPrefs().getSyncAllApps;
        calls = SharedPrefs().getSyncCalls;
        messages = SharedPrefs().getSyncMessages;
        whatsApp = SharedPrefs().getSyncWhatsapp;
        time = SharedPrefs().getSyncTime;
        calender = SharedPrefs().getSyncCalender;
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
            crossAxisAlignment: watchProvider.isScanning
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
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
                      setState(() {
                        messages = true;
                        calls = true;
                        time = true;
                        whatsApp = true;
                        calender = true;
                        isAllOn = !isAllOn;
                      });
                      watchProvider.syncWatch(true, true);
                    },
                    onSwitchOff: () {
                      setState(() {
                        messages = false;
                        calls = false;
                        time = false;
                        whatsApp = false;
                        calender = false;
                        isAllOn = !isAllOn;
                      });
                      watchProvider.syncWatch(false, true);
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
                      ListTileItem(
                        title: 'Incoming Calls',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            calls = true;
                          });
                          watchProvider.syncCalls(true);
                        },
                        onSwitchOff: () {
                          setState(() {
                            calls = false;
                            isAllOn = false;
                          });
                          watchProvider.syncWatch(false, false);
                          watchProvider.syncCalls(false);
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
                          watchProvider.syncMessages(true);
                        },
                        onSwitchOff: () {
                          setState(() {
                            messages = false;
                          });
                          watchProvider.syncWatch(false, false);
                          watchProvider.syncMessages(false);
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
                        title: 'WhatsApp',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            whatsApp = true;
                          });
                          watchProvider.syncWhatsApp(true);
                        },
                        onSwitchOff: () {
                          setState(() {
                            whatsApp = false;
                          });
                          watchProvider.syncWatch(false, false);
                          watchProvider.syncWhatsApp(false);
                        },
                        tileValue: whatsApp,
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
                          watchProvider.syncTime(true);
                        },
                        onSwitchOff: () {
                          setState(() {
                            time = false;
                          });
                          watchProvider.syncWatch(false, false);
                          watchProvider.syncTime(false);
                        },
                        tileValue: time,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12.withOpacity(0.08),
                      ),
                      ListTileItem(
                        title: 'Google Calendar',
                        isLastItem: false,
                        onSwitchOn: () {
                          setState(() {
                            calender = true;
                          });
                          watchProvider.syncCalender(true);
                        },
                        onSwitchOff: () {
                          setState(() {
                            calender = false;
                          });
                          watchProvider.syncWatch(false, false);
                          watchProvider.syncCalender(false);
                        },
                        tileValue: calender,
                      ),
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
