import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/dashboard/bottomNavigationItem.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/utils/bottomNavBarUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class CustomBottonNavigation extends StatefulWidget {
  final Function(int) onTabTapped;
  final int currentIndex;

  const CustomBottonNavigation({
    Key? key,
    required this.onTabTapped,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottonNavigation> createState() => _CustomBottonNavigationState();
}

class _CustomBottonNavigationState extends State<CustomBottonNavigation> {
  ScrollController bottomNavScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    bottomNavScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        BottomNavBarUtils().scrollToNewFeature(bottomNavScrollController);
      });
    });

    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 120,
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: new ClampingScrollPhysics(),
        controller: bottomNavScrollController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            BottomNavigationItem(
              index: 0,
              onItemPressed: widget.onTabTapped,
              label: 'prayer time'.tr(),
              icon: AppIcons.prayertimeIcon,
              currentIndex: widget.currentIndex,
            ),
            BottomNavigationItem(
              index: 1,
              onItemPressed: widget.onTabTapped,
              label: 'qibla'.tr(),
              icon: AppIcons.qiblaIcon,
              currentIndex: widget.currentIndex,
            ),
            BottomNavigationItem(
              index: 2,
              onItemPressed: widget.onTabTapped,
              label: 'quran'.tr(),
              icon: AppIcons.quranIcon,
              currentIndex: widget.currentIndex,
            ),
            BottomNavigationItem(
              index: 3,
              onItemPressed: widget.onTabTapped,
              label: 'tesbih'.tr(),
              icon: AppIcons.tesbih,
              currentIndex: widget.currentIndex,
              isNewFeature: !SharedPrefs().getNewFeatureViewed,
            ),
            SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
