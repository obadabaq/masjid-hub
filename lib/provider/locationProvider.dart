import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masjidhub/provider/prayerTimingsProvider.dart';
import 'package:masjidhub/provider/wathc_provider.dart';
import 'package:masjidhub/utils/prayerUtils.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjidhub/constants/errors.dart';
import 'package:masjidhub/utils/locationUtils.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/models/placesModel.dart';
import 'package:masjidhub/models/coordinateModel.dart';
import 'package:masjidhub/constants/coordinates.dart';
import '../helper_qibla.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider._privateConstructor({this.setupProvider});

  final String apiKey = LocationUtils().gMapsKey;

  static final LocationProvider _instance =
      LocationProvider._privateConstructor();

  factory LocationProvider({setupProvider}) {
    _instance.setupProvider = setupProvider;
    return _instance;
  }

  late List<Placemark> _placemarks;
  List<PlacesModel> places = List<PlacesModel>.empty(growable: true);

  String? _address;

  String? get getAddress {
    if (_address == null) {
      _address = SharedPrefs().getAddress;
    }
    return _address;
  }

  set setAddress(String addr) => _address = addr;

  bool? _isAutomatic;

  bool? get getAutomatic {
    _isAutomatic = SharedPrefs().getAutomatic;
    return _isAutomatic;
  }

  void setAutomatic(bool value) {
    SharedPrefs().setAutomatic(value);
    _isAutomatic = value;
    notifyListeners();
  }

  bool locationLoading = false;
  String errorText = "";

  var setupProvider;

  Future<void> setErrorText(String err) async {
    errorText = err;
    notifyListeners();
  }

  Future<void> getPlacesCords(String placeId) async {
    final sessionToken = Uuid().v4();
    final client = http.Client();
    final headers = LocationUtils().gMapsHeaders;
    final Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=$placeId&key=$apiKey&sessiontoken=$sessionToken&adr_address');
    final response = await client.get(request, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final cords = responseBody['result']['geometry']['location'];
      String cityName =
          responseBody['result']['address_components'][0]['short_name'].length <
                  12
              ? responseBody['result']['address_components'][0]['short_name']
              : responseBody['result']['address_components'][1]['short_name'];
      String addrAddress =
          "$cityName, ${responseBody['result']['address_components'].last['short_name']}";
      String addressMobile =
          "$cityName, ${responseBody['result']['address_components'].last['short_name']}";
      if (addrAddress.contains("tanbul")) {
        addrAddress = "I" + addrAddress.substring(1);
      }
      if (addrAddress.length > 15) {
        addrAddress = addrAddress.split(',')[0];
      }
      final userCords = Cords(lat: cords['lat'], lon: cords['lng']);
      setupProvider.setUserCords(userCords);
      SharedPrefs().setLocation(
          userCords.lat, userCords.lon, addrAddress, addressMobile);
      PrayerUtils().getAltitude();
      await fetchAddressAndSaveOrgId(userCords.lat, userCords.lon,
          saveAddress: false);
      getBearingFromMecca(userCords);
      try {
        final watchProvider = WatchProvider();
        if (watchProvider.isConnected) {
          try {
            QiblaHelper.sendQiblaCommand(
                userCords.lat, userCords.lon, WatchProvider());
            watchProvider.updateDateTime();
            watchProvider.updateLocation(await SharedPrefs().getAddress);
            Future.delayed(Duration(seconds: 4), () async {
              watchProvider.updateLocation(SharedPrefs().getAddress);
              PrayerTimingsProvider prayerTimingsProvider =
                  PrayerTimingsProvider();
              try {
                List<Map<String, dynamic>> next30DaysPrayerTimes =
                    await prayerTimingsProvider.getNext30DaysPrayerTimes();
                // Ensure the data structure is correct
                next30DaysPrayerTimes.forEach((element) {
                  DateTime date = element['date'];
                  List<DateTime> prayers = (element['prayers'] as List)
                      .map((p) => p as DateTime)
                      .toList();
                  print('Date: $date, Prayers: $prayers');
                });
                // Send the prayer times to the device
                watchProvider.updatePrayerTimes(next30DaysPrayerTimes);
              } catch (e) {
                print('Error fetching or sending prayer times: $e');
              }
            });
          } catch (e) {
            log(e.toString());
          }
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      setErrorText(tr('error coordinates'));
      return Future.error(tr('error coordinates'));
    }
    notifyListeners();
  }

  /// Fetch place information based on latitude and longitude
  Future<List<String>> getPlaceFromCoordinates(double lat, double lng) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final results = data["results"][0];
          if (results.isNotEmpty) {
            String address =
                "${results['address_components'][results['address_components'].length - 2]['short_name']}, ${results['address_components'].last['short_name']}";
            String addressMobile =
                "${results['address_components'][results['address_components'].length - 2]['short_name']}, ${results['address_components'].last['short_name']}";
            if (address.contains("tanbul")) {
              address = "I" + address.substring(1);
            }
            if (address.length > 15) {
              address =
                  "${results['address_components'][results['address_components'].length - 3]['short_name']}, ${results['address_components'].last['short_name']}";
            }
            return [address, addressMobile];
            return results[1]["formatted_address"].split(",").last;
          } else {
            return ["No results found"];
          }
        } else {
          return ["Error: ${data["status"]}"];
        }
      } else {
        return ["HTTP Error: ${response.statusCode}"];
      }
    } catch (e) {
      return ["Error: $e"];
    }
  }

  Future<void> locateUser() async {
    try {
      // final locationCords = await checkLocationPermissionAndLocate();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      log(position.toString());
      final double lat = position.latitude;
      final double lon = position.longitude;
      Timer? _timer2;
      final userCords = Cords(lat: lat, lon: lon);
      final address = await getPlaceFromCoordinates(lat, lon);
      setupProvider.setUserCords(userCords);
      await SharedPrefs().setLocation(lat, lon, address[0], address[1]);
      PrayerUtils().getAltitude();
      getBearingFromMecca(userCords);
      final watchProvider = WatchProvider();
      if (watchProvider.isConnected) {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          QiblaHelper.sendQiblaCommand(
              position.latitude, position.longitude, WatchProvider());
          watchProvider.updateDateTime();
          Future.delayed(Duration(seconds: 4), () async {
            watchProvider.updateLocation(SharedPrefs().getAddress);
            PrayerTimingsProvider prayerTimingsProvider =
                PrayerTimingsProvider();
            try {
              List<Map<String, dynamic>> next30DaysPrayerTimes =
                  await prayerTimingsProvider.getNext30DaysPrayerTimes();
              // Ensure the data structure is correct
              next30DaysPrayerTimes.forEach((element) {
                DateTime date = element['date'];
                List<DateTime> prayers = (element['prayers'] as List)
                    .map((p) => p as DateTime)
                    .toList();
                print('Date: $date, Prayers: $prayers');
              });
              // Send the prayer times to the device
              watchProvider.updatePrayerTimes(next30DaysPrayerTimes);
            } catch (e) {
              print('Error fetching or sending prayer times: $e');
            }
          });
        } catch (e) {
          log(e.toString());
        }
      }
    } catch (e) {
      print(e.toString());
      setErrorText(tr('error location'));
      return Future.error(tr('error location'));
    }
    notifyListeners();
  }

  Future<void> fetchAddressAndSaveOrgId(double lat, double lon,
      {bool saveAddress = true}) async {
    try {
      _placemarks = await placemarkFromCoordinates(lat, lon);

      String? _countryIsoCode = _placemarks[0].isoCountryCode;
      setOrgId(_countryIsoCode);

      if (saveAddress) {
        setAddress = LocationUtils().getAddressFromPlacemark(_placemarks[0]);
        print(getAddress);
        notifyListeners();
      }
    } catch (e) {
      setErrorText(e.toString());
      Future.error(e.toString());
    }
  }

  Future<void> saveAddress() async {
    try {
      locationLoading = true;
      notifyListeners();
      await locateUser();
      locationLoading = false;
      notifyListeners();
    } catch (e) {
      locationLoading = false;
      notifyListeners();
      setErrorText(e.toString());
      return Future.error(e.toString());
    }
  }

  Future<Position> checkLocationPermissionAndLocate() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setErrorText(tr('location disabled'));
      return Future.error(tr('location disabled'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setErrorText(tr('location permanently denied'));
        return Future.error(tr('location permanently denied'));
      }

      if (permission == LocationPermission.denied) {
        setErrorText(tr('location denied'));
        return Future.error(tr('location denied'));
      }
    }
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit:
            Duration(seconds: 15), // Increased timeout for better reliability
      );
    } catch (e) {
      // Fallback to last known position if `getCurrentPosition` fails
      final lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        return lastKnownPosition;
      } else {
        setErrorText(tr('error location'));
        return Future.error(tr('error location'));
      }
    }
  }

  List<PlacesModel> parsePlaces(String responseBody) {
    final result = json.decode(responseBody);
    return result['predictions']
        .map<PlacesModel>((p) => PlacesModel(
              id: p['place_id'],
              title: p['description'],
            ))
        .toList();
  }

  Future<void> fetchSuggestions(String input, String lang) async {
    if (input.isEmpty) places = [];
    final sessionToken = Uuid().v4();
    final client = http.Client();
    final headers = LocationUtils().gMapsHeaders;
    final Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=$lang&key=$apiKey&sessiontoken=$sessionToken');
    final response = await client.get(request, headers: headers);

    final result = json.decode(response.body);
    inspect(result);
    if (response.statusCode == 200) {
      if (result['status'] == 'OK') {
        places = parsePlaces(response.body);
      } else if (result['status'] == 'ZERO_RESULTS') {
        setErrorText(tr('no results'));
        return Future.error(tr('no results'));
      }
    } else {
      setErrorText(tr('error location'));
      return Future.error(tr('error location'));
    }
    notifyListeners();
  }

  Future<void> resetPlaces() async {
    places.clear();
    notifyListeners();
  }

  Future<void> setOrgId(String? isoCountryCode) async {
    int orgId = LocationUtils().getOrgIdByCountry(isoCountryCode);
    SharedPrefs().setSelectedOrgId(orgId);
  }

  Future<void> fetchAddress({
    required Function(AppError errorType) onError,
  }) async {
    bool isOnline = await InternetConnectionChecker().hasConnection;
    if (!isOnline) onError(AppError.noInternet);
    bool isAutoLocation = SharedPrefs().getAutomatic;
    try {
      if (isAutoLocation) await saveAddress();
    } catch (e) {
      setErrorText(e.toString());
      onError(AppError.noGPS);
    }
  }

  Future<void> getBearingFromMecca(Cords cord) async {
    double bearing = Geolocator.bearingBetween(
      cord.lat,
      cord.lon,
      kaabaCords.lat,
      kaabaCords.lon,
    );
    setBearing(bearing);
  }

  double _bearing = SharedPrefs().getBearing;

  double get getBearing => _bearing;

  Future<void> setBearing(double bearing) async {
    _bearing = bearing;
    SharedPrefs().setBearing(bearing);
    notifyListeners();
  }
}
