import 'package:mumush/src/data/model/entity/schedule_model.dart';

class Performance {
  ScheduleData data;
  ScheduleIncluded? included;
  bool isCurrent = false;

  Performance(this.data);
}
