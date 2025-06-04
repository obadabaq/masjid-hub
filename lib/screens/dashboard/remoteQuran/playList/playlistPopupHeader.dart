import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';

class PlaylistPopupHeader extends StatelessWidget {
  const PlaylistPopupHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  CupertinoIcons.multiply,
                  size: 30,
                  color: CustomColors.blackPearl.withOpacity(0.4),
                ),
              )
            ],
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -35.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr('playlist'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.irisBlue,
                    fontSize: 20,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
