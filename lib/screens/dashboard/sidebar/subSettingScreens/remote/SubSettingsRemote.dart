import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/radioList/RadioList.dart';
import 'package:masjidhub/constants/remoteSettings.dart';
import 'package:masjidhub/provider/bleProvider.dart';

class SubSettingsRemote extends StatelessWidget {
  const SubSettingsRemote({Key? key}) : super(key: key);

  bool idToBool(int id) {
    return id == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<BleProvider>(builder: (ctx, setup, _) {
          return RadioList(
            list: remoteSettingsList,
            onItemPressed: (id) => setup.toggleRemote(idToBool(id)),
            itemSelected: setup.isRemoteOn ? 1 : 0,
          );
        }),
      ],
    );
  }
}
