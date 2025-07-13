import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:masjidhub/utils/appBarUtils.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
import 'package:masjidhub/utils/enums/appBarEnums.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/common/errorPopups/errorPopup.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/constants/settingsList/locationSettingsListData.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/subSettingLayout.dart';

class CustomAppBar extends StatefulWidget {
  final Function openDrawer;
  final AppBarState state;

  const CustomAppBar({
    Key? key,
    required this.openDrawer,
    required this.state,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
// When user clicks on location icon on prayer times dashboard
  void fetchAddress() {
    Provider.of<LocationProvider>(context, listen: false).setAutomatic(true);
    Provider.of<LocationProvider>(context, listen: false)
        .fetchAddress(onError: (err) => _showOfflinePopup(context, err));
  }

  void onQuranSearchToggle() =>
      Provider.of<QuranProvider>(context, listen: false).toggleSearchActive();

  Future<void> onFailure() async {
    await Provider.of<BleProvider>(context, listen: false).toggleRemote(false);
  }

  // Popup to show already connected Home masjid devices
  Future<void> switchToA2dpMode() async {
    try {
      await Provider.of<BleProvider>(context, listen: false).setAdpMode();
    } catch (e) {
      AppSnackBar().showSnackBar(context, e, onTap: onFailure);
    }
  }

  Future<void> switchSearchOff() async {
    await Provider.of<QuranProvider>(context, listen: false)
        .toggleSearchActive();
  }

  void resetTesbih() =>
      Provider.of<TesbihProvider>(context, listen: false).resetTesbih();

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: AppBarUtils().isCenter(widget.state),
        title: Padding(
          padding: AppBarUtils().getTitlePadding(widget.state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.state == AppBarState.quranSearch)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: switchSearchOff,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0),
                        child: Icon(
                          Icons.chevron_left,
                          size: 35,
                          color: CustomColors.blackPearl,
                        ),
                      ),
                      Text(
                        tr('back'),
                        style: TextStyle(
                          fontSize: 22,
                          height: 1.3,
                          color: CustomColors.blackPearl,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              if (widget.state != AppBarState.quranSearch)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (widget.state == AppBarState.address) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubSettingLayout(
                                  title: locationSettingsList.first.title,
                                  contxt: context,
                                ),
                              ),
                            );
                          }
                        },
                        child: Consumer<LocationProvider>(
                          builder: (ctx, locationProvider, _) {
                            return AutoSizeText(
                              AppBarUtils().getTitle(widget.state),
                              style: TextStyle(
                                fontSize:
                                    AppBarUtils().titleFontSize(widget.state),
                                height: 1.3,
                                color: CustomColors.blackPearl,
                              ),
                              minFontSize: 16,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign:
                                  AppBarUtils().titleAlignment(widget.state),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.state == AppBarState.remote)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    AppBarUtils().getSubTitle(widget.state),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.3,
                      color: CustomColors.irisBlue,
                    ),
                  ),
                )
            ],
          ),
        ),
        actions: AppBarUtils().getActionWidgets(
          widget.state,
          onQuranSearchToggle: onQuranSearchToggle,
          showRemotePopup: switchToA2dpMode,
          openDrawer: widget.openDrawer,
          resetTesbih: resetTesbih,
        ),
        leading: AppBarUtils()
            .getLeadingWidgets(widget.state, fetchLocation: fetchAddress),
      ),
    );
  }

  _showOfflinePopup(BuildContext context, AppError error) =>
      Navigator.push(context, PopupLayout(child: ErrorPopup(errorType: error)));
}
