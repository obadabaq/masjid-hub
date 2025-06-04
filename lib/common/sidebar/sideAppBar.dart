import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/theme/colors.dart';

class SideAppBar extends StatefulWidget {
  final BuildContext contxt;
  final String title;

  const SideAppBar({
    required this.title,
    required this.contxt,
    Key? key,
  }) : super(key: key);

  @override
  _SideAppBarState createState() => _SideAppBarState();
}

class _SideAppBarState extends State<SideAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      toolbarHeight: 100,
      centerTitle: false,
      leadingWidth: 40,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => {
          setState(() => {}),
          Navigator.of(widget.contxt).pop(),
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Icon(
            Icons.chevron_left,
            size: 35,
            color: CustomColors.blackPearl,
          ),
        ),
      ),
      title: Text(
        tr(widget.title.toLowerCase()),
        style: TextStyle(
          fontSize: 22,
          height: 1.3,
          color: CustomColors.blackPearl,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }
}
