import 'package:flutter/material.dart';

class AppSnackBar {
  Future<void> showSnackBar(context, message, {Function()? onTap}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        duration: Duration(minutes: 1),
        backgroundColor: Colors.grey,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height -
                100 -
                MediaQuery.of(context).padding.top,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Future<void> closeSnackBar(context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
