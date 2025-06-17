import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/screens/setupScreens/chooseAdhan/chooseAdhanComponent.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:sizer/sizer.dart';

class ChooseAdhan extends StatefulWidget {
  final PageController pageController;

  ChooseAdhan({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChooseAdhanState createState() => _ChooseAdhanState();
}

class _ChooseAdhanState extends State<ChooseAdhan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: SetupHeaderImage(image: adhanSetupImage),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.5.h),
                      child: Text(
                        tr('choose adhan'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          color: CustomColors.blackPearl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.5.h, left: 30, right: 30),
                      child: Text(
                        tr('selectPrayersForAlarms'),
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.h, left: 30, right: 30),
                      child: ChooseAdhanComponent(),
                    ),
                    SetupFooter(
                      currentPage: 1,
                      margin: EdgeInsets.only(bottom: 30),
                      buttonText: tr('next'),
                      controller: widget.pageController,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
