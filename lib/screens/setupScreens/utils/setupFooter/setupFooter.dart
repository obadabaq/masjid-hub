import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/common/snackBar/AppSnackBar.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/screens/setupScreens/utils/setupFooter/navDots.dart';
import 'package:sizer/sizer.dart';

class SetupFooter extends StatelessWidget {
  final int currentPage;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String buttonText;
  final PageController controller;
  final bool isLastStep;
  final bool isPrimaryButtonDisabled;
  final bool isLoading;

  const SetupFooter({
    Key? key,
    required this.currentPage,
    required this.buttonText,
    required this.controller,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.isLastStep = false,
    this.isLoading = false,
    this.isPrimaryButtonDisabled = false,
  }) : super(key: key);

  void _nextPage() {
    controller.animateToPage((currentPage + 1).toInt(),
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _completeSetup() async {
      var setupProvider = Provider.of<SetupProvider>(context, listen: false);
      try {
        setupProvider.setIsSetupCompleted(true);
      } catch (e) {
        AppSnackBar().showSnackBar(context, e);
      }
    }

    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        children: [
          PrimaryButton(
            margin: EdgeInsets.only(
                top: 30, left: 20, right: 20, bottom: isLastStep ? 50 : 0),
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            text: buttonText,
            width: 300,
            upperCase: true,
            isSelected: true,
            isLoading: isLoading,
            isDisabled: isPrimaryButtonDisabled,
            onPressed: () => isLastStep ? _completeSetup() : _nextPage(),
          ),
          if (!isLastStep)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: InkWell(
                onTap: () => _nextPage(),
                child: Text(
                  tr('skip this step'),
                  style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                ),
              ),
            ),
          NavDots(
            controller: controller,
          )
        ],
      ),
    );
  }
}
