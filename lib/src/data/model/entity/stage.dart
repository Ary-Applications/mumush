import 'package:mumush/src/data/model/entity/schedule_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stage {
  bool isActive;
  ScheduleIncluded data;
  LatLng? coords;

  Stage(this.data, this.isActive);
}
