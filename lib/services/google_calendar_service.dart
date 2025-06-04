// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
//
// class GoogleCalendarService {
//   static const _scopes =
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
//
//   Future<List<google_calendar.Event>> retrieveCalendarEvents() async {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//     var client = (await _googleSignIn.authenticatedClient());
//     if(client == null){
//       return [];
//     }
//     final calendar = google_calendar.CalendarApi(client);
//     final now = DateTime.now().toUtc();
//
//     final events = await calendar.events.list(
//       'primary',
//       timeMin: now.subtract(Duration(days: 365* 30)),
//       timeMax: now.add(Duration(days: 365* 30)),
//     );
//
//     return events.items!;
//   }
// }
