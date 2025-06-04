import 'dart:io' show Platform;
import 'package:geocoding/geocoding.dart';

import 'package:masjidhub/constants/organisations.dart';
import 'package:masjidhub/constants/strings.dart';
import 'package:masjidhub/secrets.dart';

class LocationUtils {
  String extractCountryFromAdrAddress(String address) {
    final String start = '<span class="country-name">';
    final String end = '</span>';
    final startIndex = address.indexOf(start);
    final endIndex = address.indexOf(end, startIndex + start.length);
    return address.substring(startIndex + start.length, endIndex);
  }

  int getOrgIdByCountry(String? countryIsoCode) {
    final int defaultOrgId = 0; // default org id
    if (countryIsoCode == null) return defaultOrgId;

    final int organisationIndex = organisationList
        .indexWhere((el) => el.supportedCountries.contains(countryIsoCode));

    final countryNotListedByOrg = organisationIndex == -1;
    if (countryNotListedByOrg) return defaultOrgId;

    return organisationList[organisationIndex].id;
  }

  double adjustedNegativeBearing(double bearing) {
    if (bearing < 0) return 360 - bearing;
    return bearing;
  }

  double adjustHeading(double heading, double bearingB) {
    double addedBearing = heading - bearingB;
    if (addedBearing > 360) return addedBearing - 360;
    return addedBearing;
  }

  bool checkIfValidString(String? str) {
    return str != null && str != "";
  }

  String getAddressFromPlacemark(Placemark placemark) {
    String? pCountry = placemark.country;
    String? pCity = placemark.locality;
    String? pStreet = placemark.street;
    String? subAdminstrativeArea = placemark.subAdministrativeArea;


    bool hasCountry = checkIfValidString(pCountry);
    bool hasCity = checkIfValidString(pCity);
    bool hasStreet = checkIfValidString(pStreet);
    bool hasArea = checkIfValidString(subAdminstrativeArea);

    bool hasAllDetails = hasCountry && hasCity && hasStreet;
    bool hasAreaAndStreet = hasArea && hasStreet;

    if (hasAllDetails) return '$pStreet, $pCity, $pCountry';
    if (hasAreaAndStreet) return '$pStreet, $subAdminstrativeArea, $pCountry';
    if (hasCity) return '$pCity, $pCountry';

    return '$pCountry';
  }

  String getApiKeyByPlatform({
    required String androidKey,
    required String iOSKey,
  }) {
    if (Platform.isAndroid) return androidKey;
    if (Platform.isIOS) return iOSKey;
    return '';
  }

  String get gMapsKey =>
      getApiKeyByPlatform(androidKey: androidKey, iOSKey: iOSKey);

  Map<String, String> get gMapsHeaders => {
        "x-ios-bundle-identifier": bundleId,
        "x-android-package": bundleId,
        "x-android-cert": androidSHA,
      };
}
