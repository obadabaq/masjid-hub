import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:masjidhub/constants/coordinates.dart';
import 'package:masjidhub/constants/images.dart';
import 'package:masjidhub/models/coordinateModel.dart';
import 'package:masjidhub/provider/locationProvider.dart';
import 'package:masjidhub/provider/setupProvider.dart';
import 'package:masjidhub/theme/colors.dart';
import 'package:masjidhub/utils/sharedPrefs.dart';
import 'package:masjidhub/common/loader/loader.dart';

class MapWidget extends StatefulWidget {
  final Function onCameraMoved;

  const MapWidget({
    Key? key,
    required this.onCameraMoved,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  String settings =
      '[ { "elementType": "geometry", "stylers": [ { "color": "#1d2c4d" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#8ec3b9" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#1a3646" } ] }, { "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#64779e" } ] }, { "featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [ { "color": "#4b6878" } ] }, { "featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [ { "color": "#334e87" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#6f9ba5" } ] }, { "featureType": "poi", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#3C7680" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#304a7d" } ] }, { "featureType": "road", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "road", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#2c6675" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#255763" } ] }, { "featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [ { "color": "#b0d5ce" } ] }, { "featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [ { "color": "#023e58" } ] }, { "featureType": "transit", "elementType": "labels.text.fill", "stylers": [ { "color": "#98a5be" } ] }, { "featureType": "transit", "elementType": "labels.text.stroke", "stylers": [ { "color": "#1d2c4d" } ] }, { "featureType": "transit.line", "elementType": "geometry.fill", "stylers": [ { "color": "#283d6a" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#3a4762" } ] }, { "featureType": "water", "elementType": "geometry", "stylers": [ { "color": "#0e1626" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#4e6d70" } ] } ]';
  Completer<GoogleMapController> _controller = Completer();

  Future<Set<Marker>> _mark(userLatLng, kaabaLatLng) async {
    if (SharedPrefs().getUserCords == null)
      await Provider.of<LocationProvider>(context, listen: false).locateUser();
    return <Marker>{
      Marker(
        markerId: MarkerId(userLatLng.toString()),
        position: userLatLng,
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), locationIconPng),
      ),
      Marker(
        markerId: MarkerId(kaabaLatLng.toString()),
        position: kaabaLatLng,
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), kaabaIconPng),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    Cords _userCords = SharedPrefs().getUserCords ??
        Provider.of<SetupProvider>(context, listen: false).getUserCords;
    LatLng userLatLng = LatLng(_userCords.lat, _userCords.lon);
    LatLng kaabaLatLng = LatLng(kaabaCords.lat, kaabaCords.lon);

    return FutureBuilder(
      future: _mark(userLatLng, kaabaLatLng),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return GoogleMap(
            onCameraMoveStarted: () => widget.onCameraMoved(),
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: userLatLng,
              zoom: 15,
            ),
            markers: snapshot.data,
            polylines: <Polyline>{
              Polyline(
                polylineId: PolylineId("line"),
                width: 6,
                points: [userLatLng, kaabaLatLng],
                color: CustomColors.irisBlue,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                geodesic: true,
                patterns: [PatternItem.dot, PatternItem.gap(10)],
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(settings);
              _controller.complete(controller);
            },
          );

        return Loader();
      },
    );
  }
}
