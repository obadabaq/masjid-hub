import 'package:masjidhub/provider/bottom_bar_provider.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/provider/ayahListProvider.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/provider/quranFontProvider.dart';
import 'package:masjidhub/provider/tesbihProvider.dart';
import '../services/bluetooth_mananger.dart';

final watchProvider = WatchProvider(); // Create WatchProvider instance

final List<SingleChildWidget> providerList = [
  ChangeNotifierProvider.value(value: SetupProvider()),
  ChangeNotifierProxyProvider<SetupProvider, PrayerTimingsProvider>(
    create: (_) => PrayerTimingsProvider(),
    update: (_, setupProvider, myNotifier) =>
        PrayerTimingsProvider(setupProvider: setupProvider),
  ),
  ChangeNotifierProxyProvider<SetupProvider, LocationProvider>(
    create: (_) => LocationProvider(),
    update: (_, setupProvider, myNotifier) =>
        LocationProvider(setupProvider: setupProvider),
  ),
  ChangeNotifierProvider.value(value: QuranProvider()),

  // Provide WatchProvider as a single instance throughout the app
  ChangeNotifierProvider.value(value: watchProvider),

  ChangeNotifierProvider.value(value: AudioProvider()),
  ChangeNotifierProvider.value(value: QuranFontProvider()),
  ChangeNotifierProvider.value(value: BottomBarProvider()),
  ChangeNotifierProxyProvider<AudioProvider, AyahListProvider>(
    create: (_) => AyahListProvider(),
    update: (_, audioProvider, myNotifier) =>
        myNotifier!..setAyahAudioState(audioProvider.audioState),
  ),
  ChangeNotifierProvider.value(value: BleProvider()),
  // Pass WatchProvider instance to TesbihProvider
  ChangeNotifierProvider.value(
      value: TesbihProvider(watchProvider: watchProvider)),
  ChangeNotifierProvider.value(value: BluetoothManager()),
];
