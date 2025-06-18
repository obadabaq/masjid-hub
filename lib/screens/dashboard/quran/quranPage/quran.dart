import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/screens/dashboard/quran/quranPage/search/quranSearch.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListWrapper.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/recentSurah/recentSurah.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/provider/quranProvider.dart';

import '../../../../common/scrollable_main_screen.dart';
import '../../../../provider/wathc_provider.dart';

class Quran extends StatefulWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  void showAudioPlayerDialog(WatchProvider watchProvider) {
    Future.delayed(Duration(seconds: 7), () {
      watchProvider.sendCommand('1A01C205');
    });
    Future.delayed(Duration(seconds: 11), () {
      watchProvider.sendCommand('1A01C205');
    });
    bool isPlaying = true; // Initial play state
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Quran Audio Player",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Previous Button
                        IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.skip_previous_rounded,
                              color: Colors.blueAccent),
                          onPressed: () {
                            watchProvider.sendCommand('1A01C206');
                          },
                        ),
                        // Play/Pause Toggle Button
                        IconButton(
                          iconSize: 50,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_filled_rounded,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isPlaying) {
                                watchProvider
                                    .sendCommand('1A01C202'); // Pause Command
                              } else {
                                watchProvider
                                    .sendCommand('1A01C201'); // Play Command
                              }
                              isPlaying = !isPlaying; // Toggle play/pause state
                            });
                          },
                        ),
                        // Next Button
                        IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.skip_next_rounded,
                              color: Colors.blueAccent),
                          onPressed: () {
                            watchProvider.sendCommand('1A01C205');
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1.5),
                  // Close Button
                  ElevatedButton.icon(
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text("Close"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      watchProvider.sendCommand('1A01C202');
                      watchProvider.sendCommand('1A01C207');
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double _buttonWidth = constraints.maxWidth * 0.85;
        final double _tabBarHeight = 60;
        final double _maxheight = constraints.maxHeight - _tabBarHeight;
        final double _maxHeightWithSearch = constraints.maxHeight - 150;
        return Consumer<QuranProvider>(
          builder: (ctx, quran, _) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                QuranSearch(buttonWidth: _buttonWidth),
                Visibility(
                    visible: !quran.isSearchActive,
                    child: SizedBox(height: _tabBarHeight)),
                SizedBox(
                  height:
                      quran.isSearchActive ? _maxHeightWithSearch : _maxheight,
                  width: constraints.maxWidth,
                  child: ScrollableMainScreen(
                    scrollController: scrollController,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: quran.isSearchActive ? 80 : 30),
                      child: SurahListWrapper(
                        scrollController: scrollController,
                        topWidget: Column(
                          children: [
                            Consumer<WatchProvider>(
                              builder: (context, watchProvider, child) {
                                if (watchProvider.isConnected) {
                                  return TextButton(
                                      onPressed: () {
                                        watchProvider
                                            .sendCommand('1A01C101010000');
                                        showAudioPlayerDialog(watchProvider);
                                      },
                                      child: Text(
                                        "Open Quran Screen On Qibla Watch",
                                        style: TextStyle(fontSize: 18),
                                      ));
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RecentSurah(
                                isSearchActive: quran.isSearchActive,
                                maxWidth: constraints.maxWidth),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text(
                                    tr('surahs'),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                      color: CustomColors.mischka,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
