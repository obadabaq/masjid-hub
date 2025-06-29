import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../common/popup/popup.dart';
import '../../dashboard/sidebar/subSettingScreens/calculationMethod/select_org.dart';

class ChoosePrayerTime extends StatefulWidget {
  final PageController pageController;

  ChoosePrayerTime({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _ChoosePrayerTimeState createState() => _ChoosePrayerTimeState();
}

class _ChoosePrayerTimeState extends State<ChoosePrayerTime> {
  static EdgeInsetsGeometry buttonPadding =
      const EdgeInsets.fromLTRB(0, 20, 0, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: SetupHeaderImage(image: calculatorSetupImage),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4.5.h,
                        left: 15.w,
                        right: 15.w,
                      ),
                      child: Text(
                        tr('prayer time calculation'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32.0,
                          height: 1.3,
                          color: CustomColors.blackPearl,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.5.h),
                      child: Text(
                        tr('select your madzhab.'),
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 25.0,
                            mainAxisExtent: 66),
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(30, 3.h, 30, 3.h),
                        shrinkWrap: true,
                        itemCount: madhabList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PrimaryButton(
                            id: madhabList[index].id,
                            text: tr(madhabList[index].title),
                            width: double.infinity,
                            padding: buttonPadding,
                            onPressed: (id) => provider.setMadhabId(id),
                            isSelected: provider.getMadhabId == index,
                            isDisabled: false,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 3.h, left: 10, right: 10, bottom: 20),
                      child: Text(
                        '... or select an organisation',
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showPopup(
                                context,
                                SelectOrg(),
                                popupContext: context,
                              );
                            },
                            child: Container(
                              width: constraints.maxWidth,
                              margin: EdgeInsets.only(
                                  top: 0, left: 8.w, right: 8.w, bottom: 10),
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              decoration: ConcaveDecoration(
                                  depth: 9,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  colors: ([
                                    Colors.white,
                                    CustomColors.spindle,
                                  ]),
                                  size: Size(84.w, 70)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      provider.getOrgId == -1
                                          ? tr('select organisation')
                                          : PrayerUtils().getOrgNameFromId(
                                              provider.getOrgId),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: SetupFooter(
                          currentPage: 3,
                          margin: EdgeInsets.only(bottom: 30),
                          isPrimaryButtonDisabled: provider.getMadhabId == -1,
                          buttonText: tr('next'),
                          controller: widget.pageController,
                        ),
                      ),
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

  _showPopup(BuildContext context, Widget widget,
      {required BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        child: widget,
      ),
    );
  }
}
