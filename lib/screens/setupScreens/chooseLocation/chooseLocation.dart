import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/screens/setupScreens/utils/setup_pageview_template.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/common/buttons/neuButton.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/chooseLocationField.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
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
  late LocationProvider locationProvider;

  @override
  void initState() {
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (ctx, locationProvider, _) {
        return AbsorbPointer(
          absorbing: locationProvider.isLoadingLocation,
          child: SetupPageViewTemplate(
            minimum: const EdgeInsets.all(16.0),
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: SetupHeaderImage(image: mapSetupImage),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.5.h),
                            child: Text(
                              tr('set your location'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30.0,
                                color: CustomColors.blackPearl,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.5.h),
                            child: Text(
                              tr('enterLocationText'),
                              style: TextStyle(
                                fontSize: 16.0,
                                height: 1.3,
                                color: CustomColors.blackPearl
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ChooseLocationField(
                            controller: _controller,
                            buttonWidth: MediaQuery.sizeOf(context).width * .91,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: NeuButton(
                                    onClick: () => _locateUser(),
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        if (locationProvider.isAutomatic)
                                          Icon(
                                            AppIcons.locationIcon,
                                            size: 20,
                                            color: locationProvider.isAutomatic
                                                ? Colors.white
                                                : CustomColors.mischka,
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: AutoSizeText(
                                            'Automatically Detect Location'
                                                .tr(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.3,
                                              color:
                                                  locationProvider.isAutomatic
                                                      ? Colors.white
                                                      : CustomColors.mischka,
                                            ),
                                            minFontSize: 12,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    isSelected: locationProvider.isAutomatic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            footer: SetupFooter(
              currentPage: 0,
              buttonText: tr('save location'),
              controller: widget.pageController,
              isPrimaryButtonDisabled: _controller.text.isEmpty,
            ),
          ),
        );
      },
    );
  }

  Future<void> _locateUser() async {
    if (!locationProvider.isAutomatic) {
      locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.setAutomatic(true);
      try {
        await locationProvider.locateUser();
        _controller.text =
            locationProvider.getAddress ?? tr('could not fetch location');
      } catch (e) {
        AppSnackBar().showSnackBar(context, e);
      }
    }
  }
}
