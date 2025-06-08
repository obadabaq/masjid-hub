import 'package:flutter/material.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/dot.dart';

class NavDots extends StatefulWidget {
  final PageController controller;

  const NavDots({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _NavDotsState createState() => _NavDotsState();
}

class _NavDotsState extends State<NavDots> {
  int currentPage = 0;

  void getCurrentPage() {
    if (mounted)
      setState(() {
        currentPage = widget.controller.page!.toInt();
      });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      getCurrentPage();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {
      getCurrentPage();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 6; i++)
            Dot(
              isActive: currentPage == i,
            ),
        ],
      ),
    );
  }
}
