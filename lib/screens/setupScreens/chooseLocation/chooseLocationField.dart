import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/common/popup/popup.dart';
import 'package:masjidhub/common/textField/searchTextField.dart';
import 'package:masjidhub/screens/setupScreens/chooseLocation/searchLocation.dart';

class ChooseLocationField extends StatelessWidget {
  final double buttonWidth;
  final TextEditingController controller;
  static String hintText = tr('find your location');

  const ChooseLocationField({
    required this.buttonWidth,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (ctx, locationProvider, _) => SearchTextField(
        readOnly: true,
        padding: EdgeInsets.only(top: 30),
        onPressed: () => _showPopup(
          context,
          SearchLocation(controller: controller, hintText: hintText),
          hintText,
          popupContext: context,
        ),
        hintText: hintText,
        buttonWidth: buttonWidth,
        controller: controller,
      ),
    );
  }

  _showPopup(BuildContext context, Widget widget, String title,
      {required BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        child: widget,
      ),
    );
  }
}
