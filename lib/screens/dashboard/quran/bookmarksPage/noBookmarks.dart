import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';

class NoBookmarks extends StatelessWidget {
  const NoBookmarks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Text(
        tr('no bookmarks yet'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.3,
          color: CustomColors.blackPearl,
        ),
      ),
    );
  }
}
