import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/dashboard/sidebar/subSettingScreens/calculationMethod/select_org.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';

import '../../../../../common/popup/popup.dart';

class SubSettingCalculationMethod extends StatelessWidget {
  const SubSettingCalculationMethod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Consumer<PrayerTimingsProvider>(
          builder: (ctx, provider, _) => Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 25),
                child: Text(
                  tr('select your madzhab'),
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.3,
                    color: CustomColors.blackPearl.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RadioList(
                  list: madhabList,
                  onItemPressed: (id) => provider.setMadhabId(id),
                  itemSelected: provider.getMadhabId,
                  width: constraints.maxWidth,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
                child: Text(
                  tr('select organisation'),
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.3,
                    color: CustomColors.blackPearl.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                  margin:
                      EdgeInsets.only(top: 0, left: 35, right: 35, bottom: 10),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: BoxDecoration(
                    color: CustomColors.irisBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    PrayerUtils().getOrgNameFromId(provider.getOrgId),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
