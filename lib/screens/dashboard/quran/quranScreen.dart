import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/tabBar/customTabBar.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/bookmarksPage/bookmarks.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/quran.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    Provider.of<QuranProvider>(context, listen: false)
        .setQuranScreenTabController(_controller);
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            Quran(),
            BookmarksPage(),
          ],
        ),
        Consumer<QuranProvider>(
          builder: (ctx, quran, _) => Padding(
            padding: EdgeInsets.only(top: quran.isSearchActive ? 100 : 0),
            child: CustomTabBar(
              // transformation: Matrix4.translationValues(0.0, -20.0, 0.0),
              controller: _controller,
              tabList: ['surah', 'bookmarks'],
              margin: EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }
}
