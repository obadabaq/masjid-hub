import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/sidebar/sideBarLayout.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/sideBarContent.dart';

class SurahSideBar extends StatelessWidget {
  const SurahSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideBarLayout(
      title: tr('quran settings'),
      body: SideBarContent(),
    );
  }
}
