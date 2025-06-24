import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/concaveDecoration.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabList;
  final EdgeInsets margin;
  final Matrix4? transformation;

  static const double _height = 48;
  static const double _radius = 25;

  const CustomTabBar({
    Key? key,
    required this.controller,
    required this.tabList,
    this.margin = EdgeInsets.zero,
    this.transformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: _height,
      transform: transformation,
      decoration: const BoxDecoration(
        color: CustomColors.irisBlue,
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: ConcaveDecoration(
              depth: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              colors: tabBarInnerShadow,
              size: Size(constraints.maxWidth, _height),
              inverse: true,
            ),
            child: TabBar(
              controller: controller,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(_radius),
                gradient: CustomColors.grey90,
              ),
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: CustomColors.irisBlue,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              labelPadding: const EdgeInsets.only(top: 4),
              tabs: tabList
                  .map((label) => Tab(text: tr(label).toUpperCase()))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
