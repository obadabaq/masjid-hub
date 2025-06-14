import 'package:flutter/material.dart';

import 'package:masjidhub/screens/dashboard/tesbih/scrollButton/scrollButton.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihAnalytics/tesbihAnalytics.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihCountView/tesbihCountView.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihDial/tesbihDial.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/utils/tesbihUtils.dart';
import 'package:provider/provider.dart';

import '../../../common/scrollable_main_screen.dart';
import '../../../provider/tesbihProvider.dart';
import '../../../provider/wathc_provider.dart';

class Tesbih extends StatefulWidget {
  const Tesbih({Key? key}) : super(key: key);

  @override
  _TesbihState createState() => _TesbihState();
}

class _TesbihState extends State<Tesbih> with SingleTickerProviderStateMixin {
  ScrollController tesbihScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tasbihProvider =
          Provider.of<TesbihProvider>(context, listen: false);
      final watchProvider = Provider.of<WatchProvider>(context, listen: false);
      if (watchProvider.isConnected) {
        watchProvider.sendCommand(
            "1A02D3${tasbihProvider.getTesbihCount.toRadixString(16).padLeft(4, '0').toUpperCase()}");
      }
    });
    SharedPrefs().setNewFeatureViewed();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tesbihScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableMainScreen(
      scrollController: tesbihScrollController,
      child: ListView(
        controller: tesbihScrollController,
        addAutomaticKeepAlives: true,
        physics: ClampingScrollPhysics(),
        children: [
          const TesbihDial(),
          const TesbihCountView(),
          // ScrollButton(icon: Icons.expand_more, onPressed: onIconDownClick),
          const SizedBox(height: 100),
          const TesbihAnalytics(),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  void onIconDownClick() => TesbihUtils()
      .scrollToTesbihSection(tesbihScrollController, TesbihSection.analytics);

  void onIconUplick() => TesbihUtils()
      .scrollToTesbihSection(tesbihScrollController, TesbihSection.dial);
}
