import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/common/dashboard/appBarActionButton.dart';
import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/common/quran/surah/surahSettings/fontSizeChange.dart';
import 'package:masjidhub/common/remoteSetup/remoteConnectPopup.dart';
import 'package:masjidhub/theme/colors.dart';

class SurahAppBar extends StatefulWidget {
  final BuildContext contxt;
  final Function onSettingsPress;

  const SurahAppBar({
    required this.contxt,
    required this.onSettingsPress,
    Key? key,
  }) : super(key: key);

  @override
  _SideAppBarState createState() => _SideAppBarState();
}

class _SideAppBarState extends State<SurahAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: false,
      title: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(widget.contxt).pop(),
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 0),
                child: Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: CustomColors.blackPearl,
                ),
              ),
              Text(
                tr('surahs'),
                style: TextStyle(
                  fontSize: 22,
                  height: 1.3,
                  color: CustomColors.blackPearl,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppBarActionButton(
          onPressed: () => _showRemoteConnectPopup(context),
          icon: AppIcons.remote,
        ),
        AppBarActionButton(
          onPressed: () => _showFontSizeChangePopup(context),
          icon: AppIcons.fontSize,
          iconSize: 16,
        ),
        AppBarActionButton(
          onPressed: widget.onSettingsPress,
          icon: AppIcons.quranSettings,
        )
      ],
    );
  }

  _showFontSizeChangePopup(BuildContext context) =>
      Navigator.push(context, PopupLayout(child: FontSizeChange()));

  _showRemoteConnectPopup(BuildContext context) =>
      Navigator.push(context, PopupLayout(child: RemoteConnectPopup()));
}
