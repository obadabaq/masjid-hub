import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masjidhub/screens/setupScreens/utils/setup_pageview_template.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/common/buttons/neuButton.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/chooseLocationField.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
import 'package:masjidhub/common/errorPopups/errorPopup.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:sizer/sizer.dart';

class ChooseLocation extends StatefulWidget {
  final PageController pageController;

  ChooseLocation({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final _controller = TextEditingController();
  bool _isAuto = false;

  @override
  Widget build(BuildContext context) {
    Future<void> _locateUser() async {
      bool isOnline = await InternetConnectionChecker().hasConnection;
      if (!isOnline) return _showOfflinePopup(context);
      var locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      try {
        await locationProvider.locateUser();
        setState(() {
          _isAuto = true;
        });
        _controller.text =
            locationProvider.getAddress ?? tr('could not fetch location');
      } catch (e) {
        AppSnackBar().showSnackBar(context, e);
      }
    }

    return SetupPageViewTemplate(
      minimum: const EdgeInsets.all(16.0),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double _buttonMaxWidth = 400.0;
          final _topPadding = constraints.maxHeight * 0.05;
          final _buttonWidth = constraints.maxWidth < _buttonMaxWidth
              ? constraints.maxWidth * 0.9
              : _buttonMaxWidth * 0.9;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _topPadding),
                  child: SetupHeaderImage(image: mapSetupImage),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    tr('set your location'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: CustomColors.blackPearl,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Text(
                    tr('enterLocationText'),
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.3,
                      color: CustomColors.blackPearl.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: ChooseLocationField(
                      buttonWidth: 350, controller: _controller),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Consumer<LocationProvider>(
                    builder: (ctx, locationProvider, _) => NeuButton(
                      onClick: () => _locateUser(),
                      height: 70,
                      width: _buttonWidth,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Icon(
                              AppIcons.locationIcon,
                              size: 20,
                              color:
                                  _isAuto ? Colors.white : CustomColors.mischka,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 10),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                              ),
                              child: AutoSizeText(
                                'Auto Detect Location',
                                style: TextStyle(
                                  fontSize: 22,
                                  height: 1.3,
                                  color: _isAuto
                                      ? Colors.white
                                      : CustomColors.mischka,
                                ),
                                minFontSize: 12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      isSelected: _isAuto,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      footer: Consumer<SetupProvider>(
        builder: (ctx, setup, _) => SetupFooter(
          currentPage: 0,
          margin: EdgeInsets.only(top: 15),
          buttonText: tr('save location'),
          controller: widget.pageController,
          isPrimaryButtonDisabled: !setup.isLocationSetupComplete,
        ),
      ),
    );
  }

  _showOfflinePopup(BuildContext context) =>
      Navigator.push(context, PopupLayout(child: ErrorPopup()));
}
