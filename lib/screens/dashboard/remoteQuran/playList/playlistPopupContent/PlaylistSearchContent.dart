import 'package:flutter/material.dart';

import 'package:masjidhub/common/textField/searchTextField.dart';
import 'package:masjidhub/provider/quranProvider.dart';
import 'package:masjidhub/screens/dashboard/quran/quranPage/surahList/surahListWrapper.dart';
import 'package:provider/provider.dart';

class PlaylistSearchContent extends StatefulWidget {
  const PlaylistSearchContent({Key? key}) : super(key: key);

  @override
  State<PlaylistSearchContent> createState() => _PlaylistSearchContentState();
}

class _PlaylistSearchContentState extends State<PlaylistSearchContent> {
  final _controller = TextEditingController();

  void _onSearchChanged() async {
    await Provider.of<QuranProvider>(context, listen: false)
        .filterQuranMeta(_controller.text);
  }

  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _searchWidth = constraints.maxWidth * 0.90;
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
            children: [
              SearchTextField(
                onPressed: () => {},
                padding: EdgeInsets.only(top: 10),
                hintText: 'Search Surah',
                buttonWidth: _searchWidth,
                controller: _controller,
              ),
              SurahListWrapper(isRemoteOn: true),
            ],
          ),
        );
      },
    );
  }
}
