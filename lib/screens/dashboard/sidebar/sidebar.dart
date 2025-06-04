import 'package:flutter/material.dart';

import 'package:masjidhub/common/sidebar/sideBarLayout.dart';
import 'package:masjidhub/screens/dashboard/sidebar/sidebarBody.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideBarLayout(
      title: 'Settings',
      body: Sidebarbody(),
    );
  }
}
