import 'package:flutter/material.dart';
import 'package:masjidhub/constants/bottomNav.dart';

import 'package:masjidhub/screens/setupScreens/utils/setupFooter/dot.dart';

class BottomNavGrab extends StatefulWidget {
  const BottomNavGrab({Key? key}) : super(key: key);

  @override
  _BottomNavGrabState createState() => _BottomNavGrabState();
}

class _BottomNavGrabState extends State<BottomNavGrab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomNavGrabHeight,
      padding: EdgeInsets.only(top: 5),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.surface,
      //   boxShadow: bottomNavShadow,
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(20),
      //     topRight: Radius.circular(20),
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [for (var i = 0; i < 3; i++) Dot(isActive: false)],
      ),
    );
  }
}
