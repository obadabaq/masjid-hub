import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListWrapper.dart';

class PlaylistSurahList extends StatelessWidget {
  const PlaylistSurahList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SurahListWrapper(isRemoteOn: true);
  }
}
