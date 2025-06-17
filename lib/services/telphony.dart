import 'package:telephony/telephony.dart';

class TelephonyServices {
  final Telephony telephony = Telephony.instance;

  Future<void> init() async {
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
