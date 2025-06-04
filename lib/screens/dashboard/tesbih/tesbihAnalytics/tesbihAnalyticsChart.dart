import 'package:flutter/material.dart';
import 'package:masjidhub/screens/dashboard/tesbih/tesbihAnalytics/analyticsColumn.dart';
import 'package:masjidhub/models/tesbih/tesbihAnalyticsColumnModel.dart';

class TesbihAnalyticsChart extends StatefulWidget {
  final List<TesbihAnalyticsColumnModel> analyticsData;

  const TesbihAnalyticsChart({
    Key? key,
    required this.analyticsData,
  }) : super(key: key);

  @override
  State<TesbihAnalyticsChart> createState() => _TesbihAnalyticsChartState();
}

class _TesbihAnalyticsChartState extends State<TesbihAnalyticsChart> {
  ScrollController analyticsScrollController = ScrollController();

  static int indexWhenNoColumnSelected = -1;
  int showNumbersOfColumnIndex = indexWhenNoColumnSelected;

  void setColumn(int id) => setState(() => showNumbersOfColumnIndex = id);

  void onColumnTap(int id) {
    if (showNumbersOfColumnIndex == id) {
      setColumn(indexWhenNoColumnSelected);
    } else {
      setColumn(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            height: 320,
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: analyticsScrollController,
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                return AnalyticsColumn(
                  progress: widget.analyticsData[index].progress,
                  footerText: widget.analyticsData[index].label,
                  totalCount: widget.analyticsData[index].count,
                  index: index,
                  showNumbers: showNumbersOfColumnIndex == index,
                  onColumnTap: onColumnTap,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
