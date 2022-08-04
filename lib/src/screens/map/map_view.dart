import 'dart:async';

import 'package:flutter/foundation.dart';
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
  var mapMarker = BitmapDescriptor.defaultMarker;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/mumush.svg');
    _markers.add(Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(46.4907468, 24.8109370),
        icon: mapMarker,
        infoWindow: InfoWindow(title: "Gargantua", snippet: "Main Stage")));
    _markers.add(Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(46.4807468, 24.7909375),
        infoWindow: InfoWindow(title: "Arboretum", snippet: "Not the Main Stage")));
    _markers.add(Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(46.4807469, 24.8009370),

        infoWindow: InfoWindow(title: "Another place", snippet: "Again, not the Main Stage")));
  }
  // late StreamSubscription<LocationData> _locationSubscription;
  final Set<Marker> _markers = {};


  late CameraPosition _initialCameraPosition;

  bool _isMapCreated = false;
  late LatLng _lastCameraPosition = LatLng(0, 0);

  static const double _mapZoom = 15;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition cameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(46.4907468, 24.8109370),
      tilt: 0.0,
      zoom: 12);
  static final CameraPosition _zoomIn = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(46.4907468, 24.8109370),
      tilt: 0.0,
      zoom: _mapZoom);

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    setCustomMarker();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   rootBundle.loadString('assets/map_style.txt').then((string) {
    //     _mapStyle = string;
    //   });
    // });

    _initialCameraPosition = CameraPosition(
      target: _lastCameraPosition,
      zoom: _mapZoom,
    );
    // rootBundle.loadString('assets/map_style.txt').then((string) {
    //   _mapStyle = string;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var map = GoogleMap(
      // mapType: MapType.hybrid,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      // markers: _showMarkers,
      onMapCreated: onMapCreated,
      markers: _markers,
      initialCameraPosition: cameraPosition,
      onCameraMove: (CameraPosition position) async {
        final GoogleMapController controller = await _controller.future;
        setState(() {
          controller.animateCamera(CameraUpdate.newCameraPosition(position));
        });
      },
    );

    return BaseStatefulView<MapViewModel>(
      viewModel: getIt<MapViewModel>(),
      builder: (context, viewModel, child) {
        return Scaffold(
            body: SafeArea(child: map),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: _onActionButtonPressed,
                label: Text('Zoom in'),
                icon: const Icon(Icons.directions_walk)));
      },
    );
  }

  Future<void> _onActionButtonPressed() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_zoomIn));
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      // _markers.add(const Marker(
      //     markerId: MarkerId('id-1'),
      //     position: LatLng(46.4907468, 24.8109370)));
      _mapController = controller;
      _mapController.setMapStyle(_mapStyle);
      _controller.complete(controller);
      _isMapCreated = true;
    });
  }
}
