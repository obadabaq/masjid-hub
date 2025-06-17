import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupButtons.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupContent/playlistPopupContent.dart';
import 'package:masjidhub/screens/dashboard/remoteQuran/playList/playlistPopupHeader.dart';
import 'package:masjidhub/theme/customTheme.dart';

class PlaylistPopup extends StatelessWidget {
  const PlaylistPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerTopPadding = constraints.maxHeight * 0.15;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: _containerTopPadding),
                padding: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: CustomTheme.lightTheme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowNeu,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlaylistPopupHeader(),
                    PlaylistPopupButtons(),
                    SizedBox(height: 10),
                    PlaylistPopupContent()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
