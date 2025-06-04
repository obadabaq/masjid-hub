import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/Audio/remoteOnLoop.dart';
import 'package:masjidhub/models/radioListModel.dart';
import 'package:masjidhub/provider/bleProvider.dart';

class SubSettingsRemoteOnLoop extends StatefulWidget {
  const SubSettingsRemoteOnLoop({
    Key? key,
  }) : super(key: key);

  @override
  _SubSettingsRemoteOnLoop createState() => _SubSettingsRemoteOnLoop();
}

class _SubSettingsRemoteOnLoop extends State<SubSettingsRemoteOnLoop> {
  @override
  Widget build(BuildContext context) {
    List<RadioListModel> list = [
      for (var i = 0; i < remoteOnLoopOptions.length; i++)
        RadioListModel(
          id: remoteOnLoopOptions[i].loopCount,
          title: remoteOnLoopOptions[i].label,
        ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Consumer<BleProvider>(
        builder: (ctx, ble, _) =>
            LayoutBuilder(builder: (context, constraints) {
          return RadioList(
            list: list,
            onItemPressed: (id) => ble.setRemoteOnSurahLoopCount(id),
            itemSelected: ble.remoteOnSurahLoopCount,
            width: constraints.maxWidth,
          );
        }),
      ),
    );
  }
}
