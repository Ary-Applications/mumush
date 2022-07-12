import 'package:flutter/material.dart';
import 'package:mumush/src/screens/map/map_view_model.dart';

import '../../di/injection.dart';
import '../base/base.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return BaseStatefulView<MapViewModel>(
      viewModel: getIt<MapViewModel>(),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Center(
            child: Text(viewModel.testTitle),
          ),
        );
      },
    );
  }
}
