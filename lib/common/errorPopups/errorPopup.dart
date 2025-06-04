import 'package:flutter/material.dart';

import 'package:masjidhub/common/buttons/flatButton.dart';
import 'package:masjidhub/common/buttons/primaryButton.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/models/errorModalContentModel.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';

class ErrorPopup extends StatelessWidget {
  const ErrorPopup({
    Key? key,
    this.showBackButton = true,
    this.showSubButton = false,
    this.errorType = AppError.noInternet,
  }) : super(key: key);

  final bool showBackButton;
  final bool showSubButton;
  final AppError errorType;

  @override
  Widget build(BuildContext context) {
    final ErrorModalContentModel modalContent =
        errorList.firstWhere((item) => item.error == errorType);

    Future<void> _onTryAgain() async {
      bool retrySuccess = await modalContent.onRetry();
      if (retrySuccess) Navigator.pop(context);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.80;
        final _containerTopPadding = constraints.maxHeight * 0.20;
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(top: _containerTopPadding),
              width: _containerWidth,
              decoration: BoxDecoration(
                color: CustomTheme.lightTheme.colorScheme.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: shadowNeu,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 30,
                        bottom: showBackButton ? 0 : 30,
                        left: 10,
                        right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: CustomColors.greyIconGradient,
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: Icon(
                            modalContent.icon,
                            size: 100.0,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 15),
                          child: Text(
                            modalContent.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors.blackPearl,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            modalContent.subTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors.blackPearl.withOpacity(0.7),
                              fontSize: 20,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showSubButton)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: PrimaryButton(
                        width: 230,
                        isSelected: true,
                        isDisabled: false,
                        text: modalContent.subButtonText,
                        onPressed: () => Navigator.popUntil(
                            context, ModalRoute.withName('/')),
                      ),
                    ),
                  if (showBackButton)
                    Padding(
                      padding: EdgeInsets.only(top: showSubButton ? 0 : 10),
                      child: CustomFlatButton(
                        textColor: Theme.of(context).colorScheme.secondary,
                        padding: EdgeInsets.all(15),
                        onPressed: () => _onTryAgain(),
                        text: modalContent.buttonText,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
