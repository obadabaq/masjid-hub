import 'package:flutter/material.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/screens/dashboard/quran/quranScreen.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/remoteQuranScreen.dart';

class QuranMode extends StatelessWidget {
  const QuranMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(builder: (ctx, ble, _) {
      if (ble.isRemoteOn) {
        return RemoteQuranScreen();
      } else {
        return QuranScreen();
      }
    });
  }
}
