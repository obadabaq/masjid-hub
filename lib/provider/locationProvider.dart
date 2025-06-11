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
    final headers = LocationUtils().gMapsHeaders;
    final Uri request = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?placeid=$placeId&key=$apiKey&sessiontoken=$sessionToken',
    );

    try {
      final response = await http.get(request, headers: headers);

      if (response.statusCode != 200) {
        setErrorText(tr('error coordinates'));
        return Future.error(tr('error coordinates'));
      }

      final responseBody = json.decode(response.body);
      final result = responseBody['result'];

      final location = result['geometry']['location'];
      final addressComponents = result['address_components'];

      final city = addressComponents.firstWhere(
        (comp) => comp['types'].toString().contains('[locality'),
        orElse: () => null,
      );
      final country = addressComponents.firstWhere(
        (comp) => comp['types'].toString().contains('country'),
        orElse: () => null,
      );

      if (city == null || country == null) {
        setErrorText(tr('error coordinates'));
        return Future.error(tr('error coordinates'));
      }

      String address = "${city['short_name']}, ${country['short_name']}";
      String addressMobile = address;

      if (address.contains("tanbul")) {
        address = "I" + address.substring(1);
      }
      if (address.length >= 15) {
        address = address.split(',')[0];
      }

      final userCords = Cords(lat: location['lat'], lon: location['lng']);
      setupProvider.setUserCords(userCords);
      SharedPrefs().setLocation(
        userCords.lat,
        userCords.lon,
        address,
        addressMobile,
      );

      PrayerUtils().getAltitude();
      await fetchAddressAndSaveOrgId(
        userCords.lat,
        userCords.lon,
        saveAddress: false,
      );
      getBearingFromMecca(userCords);

      // Watch device integration
      try {
        final watchProvider = WatchProvider();

        if (watchProvider.isConnected) {
          QiblaHelper.sendQiblaCommand(
            userCords.lat,
            userCords.lon,
            watchProvider,
          );

          watchProvider.updateDateTime();
          watchProvider.updateLocation(await SharedPrefs().getAddress);

          Future.delayed(Duration(seconds: 4), () async {
            watchProvider.updateLocation(await SharedPrefs().getAddress);

            final prayerProvider = PrayerTimingsProvider();
            try {
              final next30DaysPrayerTimes =
                  await prayerProvider.getNext30DaysPrayerTimes();

              next30DaysPrayerTimes.forEach((element) {
                final date = element['date'];
                final prayers = (element['prayers'] as List)
                    .map((p) => p as DateTime)
                    .toList();
                print('Date: $date, Prayers: $prayers');
              });

              watchProvider.updatePrayerTimes(next30DaysPrayerTimes);
            } catch (e) {
              print('Error fetching or sending prayer times: $e');
            }
          });
        }
      } catch (e) {
        log('WatchProvider error: $e');
      }

      notifyListeners();
    } catch (e) {
      setErrorText(tr('error coordinates'));
      return Future.error(tr('error coordinates'));
    }
  }

  Future<List<String>> getPlaceFromCoordinates(double lat, double lng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return ["HTTP Error: ${response.statusCode}"];
      }

      final data = json.decode(response.body);
      if (data["status"] != "OK") {
        return ["Error: ${data["status"]}"];
      }

      final results = data["results"];
      if (results.isEmpty) {
        return ["No results found"];
      }

      final components = results[0]['address_components'];

      final city = components.firstWhere(
        (comp) => comp['types'].toString().contains('[locality'),
        orElse: () => null,
      );

      final country = components.firstWhere(
        (comp) => comp['types'].toString().contains('country'),
        orElse: () => null,
      );

      if (city == null || country == null) {
        return ["Missing city or country information"];
      }

      String address = "${city['short_name']}, ${country['short_name']}";
      String addressMobile = address;

      if (address.contains("tanbul")) {
        address = "I" + address.substring(1);
      }

      if (address.length >= 15) {
        address = address.split(',')[0];
      }

      return [address, addressMobile];
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
