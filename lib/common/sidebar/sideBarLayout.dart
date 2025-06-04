import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:masjidhub/common/sidebar/sideAppBar.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:provider/provider.dart';

class SideBarLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const SideBarLayout({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numOfPresses = 0;
    WatchProvider watchProvider =
        Provider.of<WatchProvider>(context, listen: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        elevation: 0,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: InkWell(
              onTap: () {
                if (numOfPresses < 3) {
                  numOfPresses += 1;
                }
                if (numOfPresses == 3) {
                  showCustomDialog(context, watchProvider);
                }
              },
              child: SideAppBar(title: title, contxt: context),
            ),
          ),
          body: body,
        ),
      ),
    );
  }

  showCustomDialog(BuildContext context, WatchProvider watchProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Are you sure you want to start the logger?"),
          actions: [
            MaterialButton(
              onPressed: () {
                watchProvider.setLogger(false);
                Navigator.pop(context);
              },
              child: Text('Turn off'),
            ),
            MaterialButton(
              onPressed: () {
                watchProvider.setLogger(true);
                Navigator.pop(context);
              },
              child: Text('Turn on'),
            ),
          ],
        );
      },
    );
  }
}
