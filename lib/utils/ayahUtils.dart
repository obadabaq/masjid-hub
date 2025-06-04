import 'dart:convert';

import 'package:flutter/material.dart';

class AyahUtils {
  List<List<int>> parsetTimingsString(String data) {
    var parsedData = json.decode(data);

    List<List<int>> res = [[]];

    for (var i = 1; i < 115; i++) {
      final List<int> tempData = List<int>.from(parsedData["$i"]);
      res.add(tempData);
    }

    return res;
  }

  void scrollToAyah(GlobalKey key, ScrollController controller) {
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    controller.animateTo(
      position.dy - 200,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
