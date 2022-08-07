import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumush/src/screens/map/map_view_model.dart';

import '../../di/injection.dart';
import '../base/base.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late String _mapStyle;
  late GoogleMapController _mapController;
  bool _isMapCreated = false;
  final CameraPosition _initialCameraPosition = const CameraPosition(
      bearing: 0.0, target: LatLng(46.495951, 24.793748), zoom: 16.6);

  final places = {
    "Entrance": const LatLng(46.496222, 24.791574),
    "Toilets & Showers": const LatLng(46.496695, 24.792001),
    "Community kitchen": const LatLng(46.496056, 24.793188),
    "Toilet": const LatLng(46.497688, 24.793422),
    "Circulo tent": const LatLng(46.497470, 24.794083),
    "Medical Zone": const LatLng(46.497433, 24.794864),
    "Bar": const LatLng(46.496920, 24.794804),
    "Gargantua Stage": const LatLng(46.496677, 24.794926),
    "Artechno tent": const LatLng(46.496685, 24.793927),
    "Chillzone": LatLng(46.496529, 24.794551),
    "Info panel": LatLng(46.496437, 24.794032),
    "Arts & Crafts": LatLng(46.496213, 24.794661),
    "Food court": LatLng(46.496213, 24.794363),
    "Info point": LatLng(46.496141, 24.794406),
    "AV Install": LatLng(46.495928, 24.794760),
    "Jam stage": LatLng(46.496053, 24.793744),
    "Circus & Yoga tent": LatLng(46.495943, 24.793666),
    "Fire space": LatLng(46.495807, 24.793914),
    "UV zone": LatLng(46.495530, 24.795012),
    "Coffee & Tea": LatLng(46.495747, 24.793313),
    "Kids area": LatLng(46.495541, 24.792998),
    "Fire": LatLng(46.495157, 24.793428),
    "Stargate": LatLng(46.495017, 24.793523),
    "Toilets": LatLng(46.495057, 24.795264),
    "The nest": LatLng(46.494775, 24.793394),
    "Healing": LatLng(46.494635, 24.793463),
    "Arboretum Stage": LatLng(46.494730, 24.794628),
    "Camping, toilets": LatLng(46.494252, 24.794295),
    "Caravan Camping": LatLng(46.496649, 24.793036),
    "Car parking": LatLng(46.497193, 24.791783)
  };

  Set<Marker> _markers = Set();

  @override
  initState() {


    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });
    setMarkers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    var map = GoogleMap(
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: onMapCreated,
      markers: _markers,
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
    );

    return BaseStatefulView<MapViewModel>(
      viewModel: getIt<MapViewModel>(),
      builder: (context, viewModel, child) {
        return SafeArea(child: map);
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(_mapStyle);

      _isMapCreated = true;
      setMarkers();
    });
  }

  setMarkers() async {
    // if (_isMapCreated) {
      BitmapDescriptor mapMarker = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/art/mumush.svg");
      var localMarkers = <Marker>{};

      places.forEach((description, location) {
        localMarkers.add(Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(title: description),
          icon: mapMarker,
        ));
      });
      _markers = localMarkers;
      setState(() {

      });
    // }
  }
}
