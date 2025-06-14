import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/dashboard/appBar.dart';
import 'package:masjidhub/common/dashboard/bottomNavigation.dart';
import 'package:masjidhub/common/dashboard/layout.dart';
import 'package:masjidhub/screens/dashboard/quranMode/quranMode.dart';
import 'package:masjidhub/screens/dashboard/prayerTime/prayerTime.dart';
import 'package:masjidhub/screens/dashboard/qibla/qibla.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbih.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/provider/audioProvider.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/common/errorPopups/errorPopup.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/utils/notificationUtils.dart';
import 'package:masjidhub/utils/appBarUtils.dart';
import 'package:masjidhub/utils/enums/appBarEnums.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      keepPage: true,
    );
    // Notifications
    NotificationUtils()
        .init(onFailure: () => _showAllowNotificationsPopup(context));
    Provider.of<LocationProvider>(context, listen: false)
        .fetchAddress(onError: (err) {});
    new Future.delayed(Duration.zero, () {
      // Provider.of<WatchProvider>(context, listen: false).checkUpdate();
      _initQuran(context);
    });
  }

  @override
  void dispose() {
    NotificationUtils().dispose();
    super.dispose();
  }

  _initQuran(BuildContext cntxt) async {
    Provider.of<QuranProvider>(context, listen: false).initQuran(cntxt);
    Provider.of<AudioProvider>(context, listen: false).initSurahTimings();
  }

  int _currentIndex = 0;
  late PageController _pageController;
  final List<Widget> _children = [PrayerTime(), Qibla(), QuranMode(), Tesbih()];

  GlobalKey<ScaffoldState> _dashboardScaffoldKey = GlobalKey();

  void openDrawer() => _dashboardScaffoldKey.currentState!.openDrawer();
  void onTabTapped(int index) {
    _pageController.jumpToPage(
      index,
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(
      builder: (ctx, ble, _) => Consumer<QuranProvider>(
        builder: (ctx, quran, _) => Consumer<SetupProvider>(
          builder: (ctx, setup, _) => Consumer<LocationProvider>(
            builder: (ctx, locationProvider, _) {
              AppBarState state = AppBarUtils().getAppBarState(
                tabIndex: _currentIndex,
                isRemote: ble.isRemoteOn,
                isQuranSearchActive: quran.isSearchActive,
                isLoading: locationProvider.locationLoading,
              );

              return Layout(
                child: Scaffold(
                  key: _dashboardScaffoldKey,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: CustomAppBar(
                      openDrawer: openDrawer,
                      state: state,
                    ),
                  ),
                  body: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _children,
                  ),
                  bottomNavigationBar: CustomBottonNavigation(
                    onTabTapped: onTabTapped,
                    currentIndex: _currentIndex,
                  ),
                  drawer: AppBarUtils().getSideBar(state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _showAllowNotificationsPopup(BuildContext context) => Navigator.push(context,
      PopupLayout(child: ErrorPopup(errorType: AppError.noNotifications)));
}
