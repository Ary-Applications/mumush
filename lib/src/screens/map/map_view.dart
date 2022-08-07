import 'dart:async';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mumush/src/screens/map/map_view_model.dart';

import '../../application/resources/places.dart';
import '../../di/injection.dart';
import '../../utils/asset_helper.dart';
import '../base/base.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late String _mapStyle;
  Completer<GoogleMapController> _mapController = Completer();
  late MapViewModel _viewModel;

  final CameraPosition _initialCameraPosition = const CameraPosition(
      bearing: 0.0, target: LatLng(46.495951, 24.793748), zoom: 16.6);

  Set<Marker> _markers = {};

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
    var map = GoogleMap(
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: onMapCreated,
      markers: Set<Marker>.of(_markers),
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
    );

    return BaseStatefulView<MapViewModel>(
      viewModel: getIt<MapViewModel>(),
      onInit: (viewModel) {
        _viewModel = viewModel;
      },
      builder: (context, viewModel, child) {
        return SafeArea(child: map);
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      setMarkers();
      controller.setMapStyle(_mapStyle);
      _viewModel.setState();
      _mapController.complete(controller);
    });
  }

  setMarkers() async {
    Uint8List byteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/art/mumush.png", 50);
    BitmapDescriptor mapMarkerIcon = BitmapDescriptor.fromBytes(byteData);
    var localMarkers = <Marker>{};

    _viewModel.setState();
    places.forEach((description, location) {
      localMarkers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: InfoWindow(title: description, snippet: "Yoho"),
        icon: mapMarkerIcon,
      ));
    });
    _markers = localMarkers;
    _viewModel.setState();
    setState(() {});
    // }
  }
}
