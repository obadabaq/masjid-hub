import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../provider/prayerTimingsProvider.dart';
import '../../../provider/wathc_provider.dart';
import '../../../utils/sharedPrefs.dart';

mixin connectionHelper {
  late WatchProvider watchProvider;

  initMixin(BuildContext context) {
    watchProvider = Provider.of<WatchProvider>(context, listen: false);
  }

  void syncDate(BuildContext context) {
    // watchProvider.syncDateTime(true);
    watchProvider.updateDateTime();
  }

  void syncLocation(BuildContext context) {
    // watchProvider.syncDateLocation(true);
    watchProvider.updateLocation(SharedPrefs().getAddress);
  }

  Future<void> syncPrayerTimes(BuildContext context) async {
    // watchProvider.syncPrayerTime(true);
    PrayerTimingsProvider prayerTimingsProvider = PrayerTimingsProvider();
    watchProvider.updatePrayerTimes([
      {
        'date': DateTime.now(),
        'prayers': [
          DateTime(2024, 6, 27, 5, 10),
          DateTime(2024, 6, 27, 6, 30),
          DateTime(2024, 6, 27, 7, 38),
          DateTime(2024, 6, 27, 8, 53),
          DateTime(2024, 6, 27, 23, 10),
        ],
      },
      // Add more days as needed
    ]);
    try {
      List<Map<String, dynamic>> next30DaysPrayerTimes =
          await prayerTimingsProvider.getNext30DaysPrayerTimes();
      // Ensure the data structure is correct
      next30DaysPrayerTimes.forEach((element) {
        DateTime date = element['date'];
        List<DateTime> prayers =
            (element['prayers'] as List).map((p) => p as DateTime).toList();

        print('Date: $date, Prayers: $prayers');
      });

      // Send the prayer times to the device
      watchProvider.updatePrayerTimes(next30DaysPrayerTimes);
    } catch (e) {
      print('Error fetching or sending prayer times: $e');
    }
    // watchProvider.syncDateLocation(true);
    watchProvider.updateLocation(SharedPrefs().getAddress);
  }

  void updateQeble() {}
}
