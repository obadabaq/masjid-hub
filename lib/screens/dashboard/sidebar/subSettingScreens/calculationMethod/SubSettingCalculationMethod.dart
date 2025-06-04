import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/madhabs.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/screens/setupScreens/choosePrayerTime/searchOrganisation.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:provider/provider.dart';

class SubSettingCalculationMethod extends StatefulWidget {
  const SubSettingCalculationMethod({
    Key? key,
  }) : super(key: key);

  @override
  _SubSettingCalculationMethodState createState() =>
      _SubSettingCalculationMethodState();
}

class _SubSettingCalculationMethodState
    extends State<SubSettingCalculationMethod> {
  static int? selectedOrgId;

  Future<void> _setOrgId(id) async {
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Consumer<PrayerTimingsProvider>(
          builder: (ctx, provider, _) => Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 25),
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
                    color: CustomColors.blackPearl.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              PrimaryButton(
                text: PrayerUtils().getOrgNameFromId(provider.getOrgId),
                width: constraints.maxWidth,
                margin:
                    EdgeInsets.only(top: 0, left: 35, right: 35, bottom: 10),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                onPressed: () => openOrgSelectPopup(),
                textAlign: TextAlign.center,
                isSelected: true,
                isDisabled: false,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      },
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
