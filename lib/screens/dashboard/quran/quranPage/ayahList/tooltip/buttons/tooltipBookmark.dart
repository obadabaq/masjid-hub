import 'package:flutter/material.dart';

class TooltipBookmark extends StatelessWidget {
  const TooltipBookmark({
    Key? key,
    required this.onAddBookmark,
  }) : super(key: key);

  final Function() onAddBookmark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onAddBookmark,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark,
              size: 25,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
