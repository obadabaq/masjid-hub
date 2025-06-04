import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/provider/providerList.dart';
import 'package:masjidhub/utils/downloaderUtils.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/screens/setupScreens/setup.dart';
import 'package:masjidhub/screens/dashboard/dashboard.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/utils/localizationUtils.dart';
import 'package:masjidhub/utils/tesbihUtils.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalizationUtils().init();
  await SharedPrefs().init();
  await DownloaderUtils().init();
  await TesbihUtils().init();
  runApp(LocalizationUtils().initApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providerList,
      child: Consumer<SetupProvider>(
        builder: (ctx, setupProvider, _) => Sizer(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              title: 'Masjid Hub',
              navigatorKey: navigatorKey,
              theme: CustomTheme.lightTheme,
              home: setupProvider.isSetupCompleted ? Dashboard() : Setup(),
              routes: {
                '/dashboard': (ctx) => Dashboard(),
                '/setup': (ctx) => Setup(),
              },
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              localizationsDelegates: context.localizationDelegates,
            );
          },
        ),
      ),
    );
  }
}
