import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/icons/app_icons.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/provider/bleProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:masjidhub/common/buttons/neuButton.dart';

class SwitchQuranBox extends StatelessWidget {
  const SwitchQuranBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onDisconect() {
      Provider.of<BleProvider>(context, listen: false).disconnect();
      Navigator.pop(context);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.90;
        final _containerTopPadding = constraints.maxHeight * 0.20;
        return Consumer<BleProvider>(
          builder: (ctx, ble, _) => Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: _containerTopPadding),
                padding: EdgeInsets.only(bottom: 30),
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
                      padding: EdgeInsets.fromLTRB(40, 15, 15, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, top: 5),
                                        child: Icon(
                                          AppIcons.remote,
                                          size: 30,
                                          color: CustomColors.irisBlue
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr('connected'),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: CustomColors.blackPearl
                                                  .withOpacity(0.7),
                                              fontSize: 20,
                                              height: 1.3,
                                            ),
                                          ),
                                          Text(
                                            tr('my homemasjid'),
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.3,
                                              color: CustomColors.irisBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  CupertinoIcons.multiply,
                                  size: 30,
                                  color:
                                      CustomColors.blackPearl.withOpacity(0.4),
                                ),
                              )
                            ],
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 40, 0, 18),
                          //   child: Text(
                          //     'Abdul’s HomeMasjid',
                          //     textAlign: TextAlign.start,
                          //     style: TextStyle(
                          //       color: CustomColors.blackPearl,
                          //       fontSize: 20,
                          //       height: 1.3,
                          //     ),
                          //   ),
                          // ),
                          // Divider(
                          //   height: 2,
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 18),
                          //   child: Text(
                          //     'Meryem’s HomeMasjid',
                          //     textAlign: TextAlign.start,
                          //     style: TextStyle(
                          //       color: CustomColors.blackPearl,
                          //       fontSize: 20,
                          //       height: 1.3,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: NeuButton(
                        isSelected: true,
                        onClick: _onDisconect,
                        height: 65,
                        width: _containerWidth * 0.90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12, right: 10),
                              child: Text(
                                'Disconnect',
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.3,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
