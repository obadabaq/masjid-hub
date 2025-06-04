import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:masjidhub/common/buttons/flatButton.dart';
import 'package:masjidhub/common/dropdown/dropdown.dart';
import 'package:masjidhub/common/textField/searchTextField.dart';
import 'package:masjidhub/constants/shadows.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/theme/customTheme.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  SearchLocation({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  Timer? _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .fetchSuggestions(widget.controller.text, 'en');
    });
  }

  _onLocatioSelected(id, title) async {
    widget.controller.text = title;
    _debounce?.cancel();
    var locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getPlacesCords(id);
    locationProvider.resetPlaces();
  }

  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _containerWidth = constraints.maxWidth * 0.95;
        final _buttonWidth = constraints.maxWidth * 0.85;
        final _containerTopPadding = constraints.maxHeight * 0.10;
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
                  SearchTextField(
                    padding: EdgeInsets.only(top: 30),
                    buttonWidth: _buttonWidth,
                    controller: widget.controller,
                    onPressed: () => {},
                    hintText: widget.hintText,
                  ),
                  Consumer<LocationProvider>(
                    builder: (ctx, location, _) => Visibility(
                      visible: location.places.isNotEmpty,
                      child: Dropdown(
                          width: _buttonWidth,
                          list: location.places,
                          onItemPressed: _onLocatioSelected),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CustomFlatButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () => Navigator.pop(context),
                      text: tr('go back'),
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
