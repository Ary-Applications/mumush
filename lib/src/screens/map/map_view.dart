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


  // var mapMarker = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = <Marker>{};
  BitmapDescriptor? mapMarker;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setCustomMarker();
    Completer<GoogleMapController> _controller = Completer();

    var map = GoogleMap(
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      onMapCreated: onMapCreated,
      markers: _markers,
      initialCameraPosition: CameraPosition(
          bearing: 0.0, target: LatLng(46.4907468, 24.8109370), zoom: 12.0),
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
      setMarkers();
      _isMapCreated = true;
    });
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)), 'assets/art/mumush.svg');
  }
  void setMarkers() {
    var localMarkers = <Marker>{};

    _markers.add(Marker(
        markerId: const MarkerId('id-1'),
        position: const LatLng(46.4906053, 24.8105279),
        icon: mapMarker!,
        infoWindow:
            const InfoWindow(title: "Gargantua", snippet: "Main Stage")));
    _markers.add(const Marker(
        markerId: MarkerId('id-2'),
        position: LatLng(46.4929542, 24.8045833),
        infoWindow:
            InfoWindow(title: "Arboretum", snippet: "Not the Main Stage")));
    _markers.add(const Marker(
        markerId: MarkerId('id-3'),
        position: LatLng(46.4896469, 24.7998216),
        infoWindow: InfoWindow(
            title: "Another place", snippet: "Again, not the Main Stage")));
  }
}
