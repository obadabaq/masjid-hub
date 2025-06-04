import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/provider/quranProvider.dart';

class TooltipCopy extends StatefulWidget {
  const TooltipCopy({
    Key? key,
  }) : super(key: key);

  @override
  State<TooltipCopy> createState() => _TooltipCopyState();
}

class _TooltipCopyState extends State<TooltipCopy> {
  Timer setTimeout(callback, [int duration = 2000]) {
    return Timer(Duration(milliseconds: duration), callback);
  }

  void clearTimeout(Timer t) {
    t.cancel();
  }

  void copyClipboard() async {
    QuranProvider quranProvider =
        Provider.of<QuranProvider>(context, listen: false);
    String copyClipboardText = await quranProvider.getCopyClipboardAyah();
    Clipboard.setData(ClipboardData(text: copyClipboardText));
  }

  bool copied = false;

  void onCopyClick() {
    copyClipboard();
    setState(() => copied = true);
    setTimeout(() => setState(() => copied = false));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onCopyClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              copied ? tr('copied') : tr('copy'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
