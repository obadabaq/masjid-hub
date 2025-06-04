import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/choosePrayerTime/searchOrganisation.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';

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
  static int? selectedMadhabId;
  static int? selectedOrgId;

  static EdgeInsetsGeometry buttonPadding =
      const EdgeInsets.fromLTRB(0, 20, 0, 20);

  Future<void> _setOrgId(id) async {
    if (selectedMadhabId != null) {
      setState(() {
        selectedMadhabId = null;

      });
    }
    setState(() {
      if (selectedOrgId == id) return selectedOrgId = null;
      selectedOrgId = id;
    });

  }

  void openOrgSelectPopup() {
    return _showPopup(
      context,
      SearchOrganisation(
        onOrgSelect: (id) => _setOrgId(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final _topPadding = constraints.maxHeight * 0.05;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: _topPadding),
                      child: SetupHeaderImage(image: calculatorSetupImage),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Text(
                        tr('prayer time calculation'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          height: 1.3,
                          color: CustomColors.blackPearl,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 0),
                      child: Text(
                        tr('select your madzhab.'),
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 25.0,
                            mainAxisExtent: 71),
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                        shrinkWrap: true,
                        itemCount: madhabList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PrimaryButton(
                            id: madhabList[index].id,
                            text: tr(madhabList[index].title),
                            width: 150,
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
                          top: 20, left: 10, right: 10, bottom: 20),
                      child: Text(
                        tr('select organisation'),
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => PrimaryButton(
                        text: PrayerUtils().getOrgNameFromId(provider.getOrgId),
                        width: constraints.maxWidth,
                        margin: EdgeInsets.only(
                            top: 0, left: 35, right: 35, bottom: 10),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        onPressed: () => openOrgSelectPopup(),
                        textAlign: TextAlign.center,
                        isSelected: true,
                        isDisabled: false,
                      ),
                    ),
                    SetupFooter(
                      currentPage: 3,
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

  _showPopup(
    BuildContext context,
    Widget widget,
  ) {
    Navigator.push(
      context,
      PopupLayout(
        child: widget,
      ),
    );
  }
}
