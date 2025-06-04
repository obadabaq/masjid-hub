import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/utils/tesbihUtils.dart';
import 'package:masjidhub/provider/tesbihProvider.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihDial/tesbihDialBackground.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihDial/tesbihDots.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';

class TesbihDial extends StatefulWidget {
  const TesbihDial({Key? key}) : super(key: key);

  @override
  _TesbihState createState() => _TesbihState();
}

class _TesbihState extends State<TesbihDial>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    SharedPrefs().setNewFeatureViewed();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: maxWidth,
              height: maxWidth,
              child: Consumer<TesbihProvider>(
                builder: (ctx, tesbih, _) => Stack(
                  children: [
                    TesbihDialBackground(
                      maxWidth: maxWidth,
                      tesbihCount: tesbih.getTesbihCount,
                      incrementTesbih: tesbih.incrementTesbih,
                    ),
                    TesbihDots(
                      tesbihCount:
                          TesbihUtils().getTesbihBeads(tesbih.getTesbihCount),
                      incrementTesbih: tesbih.incrementTesbih,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
