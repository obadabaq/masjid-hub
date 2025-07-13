import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/dashboard/appBarActionButton.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahPage/surahSideBar/surahSideBar.dart';
import 'package:masjidhub/screens/dashboard/sidebar/sidebar.dart';
import 'package:masjidhub/utils/enums/appBarEnums.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class AppBarUtils {
  AppBarState getAppBarState({
    required int tabIndex,
    required bool isRemote,
    required bool isQuranSearchActive,
    bool isLoading = false,
  }) {
    final isLocationTab = tabIndex == 0 || tabIndex == 1;
    if (isLoading && isLocationTab) return AppBarState.loading;

    final isQuranTab = tabIndex == 2;
    if (isQuranTab && isRemote) return AppBarState.remote;
    if (isQuranTab && isQuranSearchActive) return AppBarState.quranSearch;

    switch (tabIndex) {
      case 2:
        return AppBarState.quran;
      case 3:
        return AppBarState.tesbih;
      case 0:
      case 1:
      default:
        return AppBarState.address;
    }
  }

  String getTitle(AppBarState state) {
    switch (state) {
      case AppBarState.address:
        return SharedPrefs().getAddress;
      case AppBarState.quranSearch:
      case AppBarState.remote:
      case AppBarState.quran:
        return tr('quran');
      case AppBarState.tesbih:
        return tr('tesbih');
      case AppBarState.loading:
        return tr('loading');
    }
  }

  String getSubTitle(AppBarState state) {
    if (state == AppBarState.remote) return tr('my homemasjid');
    return '';
  }

  EdgeInsetsGeometry getTitlePadding(AppBarState state) {
    switch (state) {
      case AppBarState.remote:
      case AppBarState.quran:
      case AppBarState.tesbih:
        return EdgeInsets.only(left: 20);
      default:
        return EdgeInsets.zero;
    }
  }

  bool isCenter(AppBarState state) {
    if (state == AppBarState.loading) return true;
    return false;
  }

  double titleFontSize(AppBarState state) {
    switch (state) {
      case AppBarState.loading:
        return 15;
      case AppBarState.address:
        return 20;
      default:
        return 22;
    }
  }

  TextAlign titleAlignment(AppBarState state) {
    switch (state) {
      case AppBarState.remote:
      case AppBarState.quran:
      case AppBarState.tesbih:
        return TextAlign.start;
      default:
        return TextAlign.center;
    }
  }

  List<Widget>? getActionWidgets(
    AppBarState state, {
    required Function onQuranSearchToggle,
    required Function showRemotePopup,
    required Function openDrawer,
    required Function resetTesbih,
  }) {
    switch (state) {
      case AppBarState.quran:
      case AppBarState.quranSearch:
        return [
          AppBarActionButton(
            onPressed: onQuranSearchToggle,
            icon: AppIcons.searchBold,
            isActive: state == AppBarState.quranSearch,
          )
        ];
      case AppBarState.remote:
        return [
          AppBarActionButton(
            onPressed: showRemotePopup,
            icon: AppIcons.remote,
            isActive: true,
          ),
          AppBarActionButton(
            onPressed: openDrawer,
            icon: AppIcons.quranSettings,
          )
        ];
      case AppBarState.tesbih:
        return [
          AppBarActionButton(
            onPressed: resetTesbih,
            icon: CupertinoIcons.refresh_bold,
            isActive: false,
          ),
          AppBarActionButton(
            onPressed: openDrawer,
            icon: AppIcons.settingsIcon,
          )
        ];
      default:
        return [
          AppBarActionButton(
            onPressed: openDrawer,
            icon: AppIcons.settingsIcon,
          )
        ];
    }
  }

  Widget? getLeadingWidgets(
    AppBarState state, {
    required Function fetchLocation,
  }) {
    switch (state) {
      case AppBarState.address:
      case AppBarState.loading:
        return AppBarActionButton(
          onPressed: fetchLocation,
          icon: CupertinoIcons.location_solid,
          isLeading: true,
        );
      default:
        return null;
    }
  }

  Widget getSideBar(AppBarState state) {
    // BACKLOG REFACTOR maybe one sidebar
    if (state == AppBarState.remote) return SurahSideBar();
    return SideBar();
  }
}
