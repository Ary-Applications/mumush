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
  final Completer<GoogleMapController> _mapController = Completer();
  late MapViewModel _viewModel;

  final CameraPosition _initialCameraPosition = const CameraPosition(
      bearing: 0.0, target: LatLng(46.495951, 24.793748), zoom: 16.9);

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
      mapType: MapType.satellite,
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
    Uint8List pinByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/orangePin.png", 50);
    Uint8List gargantuaByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/gargantua_stage.png", 160);
    Uint8List arboretumByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/arboretum_stage.png", 100);
    Uint8List chillByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/chill.png", 120);
    Uint8List barByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/bar.png", 100);
    Uint8List fireSpaceByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/fire_space.png", 50);
    Uint8List fireByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/fire.png", 40);
    Uint8List toiletByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/toilet.png", 30);
    Uint8List nestByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/nest.png", 100);
    Uint8List entranceByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/entrance.png", 80);
    Uint8List toiShowByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/toilets&showers.png", 50);
    Uint8List medByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/medical_symbol.png", 100);
    Uint8List foodByteData = await AssetHelper.getInstance()
        .getBytesFromAsset("assets/map/food_court.png", 150);

    BitmapDescriptor pinMarker = BitmapDescriptor.fromBytes(pinByteData);
    BitmapDescriptor gargantuaMarker =
        BitmapDescriptor.fromBytes(gargantuaByteData);
    BitmapDescriptor arboretumMarker =
        BitmapDescriptor.fromBytes(arboretumByteData);
    BitmapDescriptor chillMarker = BitmapDescriptor.fromBytes(chillByteData);
    BitmapDescriptor barMarker = BitmapDescriptor.fromBytes(barByteData);
    BitmapDescriptor fireSpaceMarker =
        BitmapDescriptor.fromBytes(fireSpaceByteData);
    BitmapDescriptor fireMarker = BitmapDescriptor.fromBytes(fireByteData);
    BitmapDescriptor toiletMarker = BitmapDescriptor.fromBytes(toiletByteData);
    BitmapDescriptor nestMarker = BitmapDescriptor.fromBytes(nestByteData);
    BitmapDescriptor entranceMarker =
        BitmapDescriptor.fromBytes(entranceByteData);
    BitmapDescriptor toiShowMarker =
        BitmapDescriptor.fromBytes(toiShowByteData);
    BitmapDescriptor medMarker = BitmapDescriptor.fromBytes(medByteData);
    BitmapDescriptor foodMarker = BitmapDescriptor.fromBytes(foodByteData);

    var localMarkers = <Marker>{};

    _viewModel.setState();
    places.forEach((description, location) {
      if (description == "Gargantua Stage") {
        addMarker(localMarkers, location, description, gargantuaMarker);
      } else if (description == "Arboretum Stage") {
        addMarker(localMarkers, location, description, arboretumMarker);
      } else if (description == "Chillzone") {
        addMarker(localMarkers, location, description, chillMarker);
      } else if ((description == "Bar") || (description == "Bar2")) {
        addMarker(localMarkers, location, description, barMarker);
      } else if (description == "Fire space") {
        addMarker(localMarkers, location, description, fireSpaceMarker);
      } else if (description == "Fire") {
        addMarker(localMarkers, location, description, fireMarker);
      } else if ((description == "Toilet") || (description == "Toilets")) {
        addMarker(localMarkers, location, description, toiletMarker);
      } else if (description == "The nest") {
        addMarker(localMarkers, location, description, nestMarker);
      } else if (description == "Entrance") {
        addMarker(localMarkers, location, description, entranceMarker);
      } else if (description == "Toilets & Showers") {
        addMarker(localMarkers, location, description, toiShowMarker);
      } else if (description == "Medical Zone") {
        addMarker(localMarkers, location, description, medMarker);
      } else if (description == "Food court") {
        addMarker(localMarkers, location, description, foodMarker);
      } else {
        addMarker(localMarkers, location, description, pinMarker);
      }
    });
    _markers = localMarkers;
    _viewModel.setState();
    setState(() {});
  }

  void addMarker(Set<Marker> localMarkers, LatLng location, String description,
      BitmapDescriptor marker) {
    localMarkers.add(Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(title: (description != "Bar2") ? description : ("Bar"), snippet: null),
      icon: marker,
    ));
  }
}
