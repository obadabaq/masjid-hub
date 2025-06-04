import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/common/textField/searchTextField.dart';
import 'package:masjidhub/provider/quranProvider.dart';

class QuranSearch extends StatefulWidget {
  const QuranSearch({
    Key? key,
    required double buttonWidth,
  })  : _buttonWidth = buttonWidth,
        super(key: key);

  final double _buttonWidth;

  @override
  _QuranSearchState createState() => _QuranSearchState();
}

class _QuranSearchState extends State<QuranSearch> {
  final controller = TextEditingController();

  void _onSearchChanged() async {
    await Provider.of<QuranProvider>(context, listen: false)
        .filterQuranMeta(controller.text);
  }

  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (ctx, quran, _) => quran.isSearchActive
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SearchTextField(
                onPressed: () => {},
                padding: EdgeInsets.only(top: 10),
                hintText: tr('search by surah'),
                buttonWidth: widget._buttonWidth,
                controller: controller,
              ),
            )
          : SizedBox(),
    );
  }
}
