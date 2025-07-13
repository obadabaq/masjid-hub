import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/flatButton.dart';
import 'package:provider/provider.dart';

import '../../../../../common/buttons/primaryButton.dart';
import '../../../../../common/dropdown/dropdown.dart';
import '../../../../../constants/organisations.dart';
import '../../../../../models/organisationModel.dart';
import '../../../../../provider/prayerTimingsProvider.dart';
import '../../../../../theme/colors.dart';
import '../../../../../utils/prayerUtils.dart';

class SelectOrg extends StatefulWidget {
  SelectOrg({
    Key? key,
  }) : super(key: key);

  @override
  _SelectOrgState createState() => _SelectOrgState();
}

class _SelectOrgState extends State<SelectOrg> {
  String? id;
  String? title;

  void onSelectedItem(id, title) async {
    setState(() {
      this.id = id;
      this.title = title;
    });
  }

  void onSaveSelection(id, title) async {
    final provider = Provider.of<PrayerTimingsProvider>(context, listen: false);
    provider.setOrgId(int.parse(id));
    Navigator.of(context).pop();
  }

  void setData() {
    final provider = Provider.of<PrayerTimingsProvider>(context, listen: false);
    id = provider.getOrgId.toString();
    title = PrayerUtils().getOrgNameFromId(provider.getOrgId);
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 40, left: 10, right: 10, bottom: 20),
                    child: Text(
                      tr('select an organisation'),
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.3,
                        color: CustomColors.blackPearl.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .45,
                ),
                child: Consumer<PrayerTimingsProvider>(
                    builder: (context, provider, _) {
                  return Dropdown.button(
                    width: MediaQuery.of(context).size.width * .9,
                    list: organisationList,
                    onItemPressed: onSelectedItem,
                    selectedValue: OrganisationModel(
                      id: int.parse(id ?? '0'),
                      title: title.toString(),
                      param: PrayerUtils().getMethodFromId(provider.getOrgId),
                      supportedCountries: [],
                    ),
                  );
                }),
              ),
              PrimaryButton(
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                text: tr('save selection'),
                width: 300,
                upperCase: true,
                isSelected: true,
                isDisabled: false,
                onPressed: () => onSaveSelection(id, title),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CustomFlatButton(
                  padding: EdgeInsets.all(15),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  text: tr('go back'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
