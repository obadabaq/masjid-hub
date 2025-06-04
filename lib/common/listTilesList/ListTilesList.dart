import 'package:flutter/cupertino.dart';
import 'package:masjidhub/common/listTilesList/ListTileItem.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/utils/enums/qiblaWatchSyncApps.dart';
import 'package:masjidhub/utils/qiblaWatchSyncUtils.dart';

class ListTileList extends StatelessWidget {
  const ListTileList({
    required this.list,
    required this.onItemSwitchedOn,
    required this.onItemSwitchedOff,
    this.width = 300,
    Key? key,
  }) : super(key: key);

  final List<dynamic> list;
  final Function onItemSwitchedOn;
  final Function onItemSwitchedOff;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: CustomTheme.lightTheme.colorScheme.background,
        boxShadow: secondaryShadow,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTileItem(
            title:
                QiblaWatchSyncUtils.getQiblaWatchSyncAppName(list[index].app),
            isLastItem: index + 1 == list.length,
            onSwitchOn: () {
              onItemSwitchedOn(list[index].app);
            },
            onSwitchOff: () {
              onItemSwitchedOff(list[index].app);
            },
            tileValue: list[index].syncStatus,
          );
        },
      ),
    );
  }
}
