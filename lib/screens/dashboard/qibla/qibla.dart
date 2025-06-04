import 'package:flutter/material.dart';

import 'package:masjidhub/common/tabBar/customTabBar.dart';
import 'package:masjidhub/screens/dashboard/qibla/qiblaCompass/qiblaCompass.dart';
import 'package:masjidhub/screens/dashboard/qibla/qiblaMap/qiblaMap.dart';

class Qibla extends StatefulWidget {
  const Qibla({Key? key}) : super(key: key);

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: const [
            QiblaCompass(),
            QiblaMap(),
          ],
        ),
        CustomTabBar(
          controller: _controller,
          tabList: ['compass', 'map'],
          margin: const EdgeInsets.all(20),
        ),
      ],
    );
  }
}
