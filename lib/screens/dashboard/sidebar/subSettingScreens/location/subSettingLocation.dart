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
  }

  void onValueChanged(bool value) {
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
                    defaultValue: locationProvider.isAutomatic,
                    onValueChanged: (value) => onValueChanged(value),
                  ),
                  Visibility(
                    visible: !locationProvider.isAutomatic,
                    child: ChooseLocationField(
                      buttonWidth: 350,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
            // if (locationProvider.isLoadingLocation) _buildLoadingLocation(),
          ],
        );
      },
    );
  }

  Widget _buildLoadingLocation() {
    return SizedBox(
      width: 100.w,
      height: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 5,
                ),
                Text("loading location"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
