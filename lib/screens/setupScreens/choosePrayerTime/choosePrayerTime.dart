import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/common/setup/setupHeaderImage.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/constants/organisations.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/setupFooter.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
  bool _showOrgDropdown = false;
  static int? selectedMadhabId;
  static int? selectedOrgId;

  static EdgeInsetsGeometry buttonPadding =
      const EdgeInsets.fromLTRB(0, 20, 0, 20);

  Future<void> _setOrgId(id) async {
    final provider = Provider.of<PrayerTimingsProvider>(context, listen: false);
    setState(() {
      selectedOrgId = id;
      _showOrgDropdown = false;
    });
    provider.setOrgId(id);
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
                            crossAxisCount: 1,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 25.0,
                            mainAxisExtent: 66),
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
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
                          top: 20, left: 10, right: 10, bottom: 20),
                      child: Text(
                        '... or select an organisation',
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          color: CustomColors.blackPearl.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Consumer<PrayerTimingsProvider>(
                      builder: (ctx, provider, _) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOrgDropdown = !_showOrgDropdown;
                              });
                            },
                            child: Container(
                              width: constraints.maxWidth,
                              margin: EdgeInsets.only(
                                  top: 0, left: 35, right: 35, bottom: 10),
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
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
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (_showOrgDropdown)
                            Container(
                              width: constraints.maxWidth * 0.8,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              constraints: BoxConstraints(
                                maxHeight: 200,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: organisationList.length,
                                itemBuilder: (_, index) {
                                  return ListTile(
                                    title: Text(
                                        PrayerUtils().getOrgNameFromId(index)),
                                    onTap: () => _setOrgId(index),
                                  );
                                },
                              ),
                            ),
                        ],
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
}
