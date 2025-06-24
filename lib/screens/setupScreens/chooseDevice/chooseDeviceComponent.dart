import 'package:flutter/material.dart';
import 'package:masjidhub/common/buttons/devicesButton.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/common/remoteSetup/remoteConnectPopup.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:masjidhub/screens/setupScreens/chooseDevice/qiblaWatchSyncWithList.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChooseDeviceComponent extends StatefulWidget {
  final bool fromSetup;

  ChooseDeviceComponent({
    Key? key,
    this.fromSetup = false,
  }) : super(key: key);

  @override
  _ChooseDeviceComponentState createState() => _ChooseDeviceComponentState();
}

class _ChooseDeviceComponentState extends State<ChooseDeviceComponent> {
  late WatchProvider watchProvider;
  late bool isWatchConnects;

  @override
  void initState() {
    watchProvider = Provider.of<WatchProvider>(context, listen: false);
    isWatchConnects = watchProvider.isConnected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double boxWidth = (constraints.maxWidth / 2) - 20;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DevicesButton(
                  onClick: () => _showRemoteConnectPopup(context),
                  text: 'Home Masjid',
                  icon: AppIcons.ishaIcon,
                  width: boxWidth,
                  buttonSelected: false,
                ),
                StatefulBuilder(
                  builder: (_, state) {
                    return DevicesButton(
                      onClick: () => toggleWatchConnect(),
                      text: 'Qibla Watch',
                      icon: Icons.watch_outlined,
                      width: boxWidth,
                      buttonSelected: isWatchConnects,
                    );
                  },
                )
              ],
            ),
            isWatchConnects == true
                ? QiblaWatchSyncApps()
                : widget.fromSetup
                    ? Container()
                    : SizedBox(
                        height: 45.h,
                        child: Center(
                          child: Text("No Connected Devices"),
                        ),
                      ),
          ],
        );
      }),
    );
  }

  _showRemoteConnectPopup(BuildContext context) => Navigator.push(
      context, PopupLayout(child: RemoteConnectPopup(isSetup: true)));

  void toggleWatchConnect() async {
    if (watchProvider.isConnected) {
      await watchProvider.disconnectDevice();
      setState(() {
        isWatchConnects = false;
      });
    } else {
      await watchProvider.connectDevice(context);
      setState(() {
        isWatchConnects = true;
      });
    }
  }
}
