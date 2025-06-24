import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/buttons/flatButton.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/constants/organisations.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:provider/provider.dart';

class SearchOrganisation extends StatefulWidget {
  final Function onOrgSelect;

  SearchOrganisation({
    Key? key,
    required this.onOrgSelect,
  }) : super(key: key);

  @override
  _SearchOrganisationState createState() => _SearchOrganisationState();
}

class _SearchOrganisationState extends State<SearchOrganisation> {
  static EdgeInsetsGeometry buttonPadding =
      const EdgeInsets.fromLTRB(20, 20, 20, 20);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prayerTimeProvider =
        Provider.of<PrayerTimingsProvider>(context, listen: false);
    int selectedOrgId = prayerTimeProvider.getOrgId;

    Future<void> _setOrgId(id) async {
      setState(() {
        selectedOrgId = id;
      });
      prayerTimeProvider.setOrgId(id);
      widget.onOrgSelect(id);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.90;
        final _buttonWidth = constraints.maxWidth * 0.85;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 100),
                width: _containerWidth,
                decoration: BoxDecoration(
                  color: CustomTheme.lightTheme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowNeu,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: organisationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PrimaryButton(
                          id: organisationList[index].id,
                          text: organisationList[index].title,
                          width: _buttonWidth,
                          padding: buttonPadding,
                          margin: EdgeInsets.only(bottom: 30),
                          onPressed: (id) => _setOrgId(id),
                          textAlign: TextAlign.left,
                          isSelected:
                              selectedOrgId == organisationList[index].id,
                          isDisabled: false,
                          fontSize: 19,
                        );
                      },
                    ),
                    CustomFlatButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () => Navigator.pop(context),
                      text: tr('go back'),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
