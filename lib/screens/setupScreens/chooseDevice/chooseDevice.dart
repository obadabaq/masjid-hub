import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/screens/setupScreens/chooseDevice/chooseDeviceComponent.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/screens/setupScreens/utils/setup_pageview_template.dart';
import 'package:masjidhub/theme/colors.dart';

class ChooseDevice extends StatefulWidget {
  final PageController pageController;

  ChooseDevice({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChooseDeviceState createState() => _ChooseDeviceState();
}

class _ChooseDeviceState extends State<ChooseDevice> {
  @override
  Widget build(BuildContext context) {
    return SetupPageViewTemplate(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _topPadding = constraints.maxHeight * 0.05;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _topPadding),
                  child: SetupHeaderImage(image: deviceSetupImage),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    tr('devices'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: CustomColors.blackPearl,
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       top: 20, left: 29, right: 29, bottom: 30),
                //   child: Text(
                //     tr('connectDeviceText'),
                //     style: TextStyle(
                //       fontSize: 16.0,
                //       height: 1.3,
                //       color: CustomColors.blackPearl.withValues(alpha: 0.7),
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                ChooseDeviceComponent(fromSetup: true),
              ],
            ),
          );
        },
      ),
      footer: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SetupFooter(
          currentPage: 5,
          margin: EdgeInsets.only(bottom: 30),
          buttonText: tr('next'),
          controller: widget.pageController,
          isLastStep: true,
        ),
      ),
    );
  }
}
