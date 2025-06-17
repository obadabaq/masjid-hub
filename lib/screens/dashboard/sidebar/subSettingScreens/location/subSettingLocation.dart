import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/common/elevatedSwitch/ElevatedSwitch.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/chooseLocationField.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubSettingLocation extends StatefulWidget {
  SubSettingLocation({Key? key}) : super(key: key);

  @override
  _SubSettingLocationState createState() => _SubSettingLocationState();
}

class _SubSettingLocationState extends State<SubSettingLocation> {
  bool initialValue = false;
  final TextEditingController controller = TextEditingController();
  late LocationProvider locationProvider;

  @override
  void initState() {
    super.initState();
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    initialValue = locationProvider.getAutomatic;
  }

  void onValueChanged(bool value) {
    setState(() {
      initialValue = value;
    });
    if (value) {
      locationProvider.locateUser();
    } else {}
    locationProvider.setAutomatic(value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  ElevatedSwitch(
                    text: tr('automatically detect'),
                    icon: Icons.settings,
                    onClick: () {},
                    defaultValue: initialValue,
                    onValueChanged: (value) => onValueChanged(value),
                  ),
                  Visibility(
                    visible: !initialValue,
                    child: ChooseLocationField(
                      buttonWidth: 350,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
            if (locationProvider.isLoadingLocation)
              Container(
                width: 100.w,
                height: 100.h,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
