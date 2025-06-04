
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/material.dart';

class TelephonyServices{

  final Telephony telephony = Telephony.instance;

  Future<void> init() async {
    AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

    // _awesomeNotifications.listen(
    //         (ReceivedNotification receivedNotification){
    //           print('New SMS received: ${receivedNotification.body}');
    //
    //     }
    // );



    // Register for incoming SMS notifications.

      // telephony.listenIncomingSms(
      //     onNewMessage: (SmsMessage message) {
      //       // Handle message
      //     },
      //     listenInBackground: false
      // );
  }

}