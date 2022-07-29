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

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
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
      // markers: _showMarkers,
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
          bearing: 0.0, target: LatLng(46.4907468, 24.8109370), zoom: 0.0),
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
    });
  }
}
