import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/model/entity/schedule_model.dart';
import '../data/model/repository/schedule/schedule_remote_data_repository.dart';
import '../screens/base/base_view_model.dart';

class Stage {
  ScheduleIncludedAttributes attributes;
  LatLng? coords;
  Stage(this.attributes);
}

@injectable
class AppViewModel extends BaseViewModel {
  final ScheduleRepository _scheduleRepository;

  AppViewModel(this._scheduleRepository);

  Schedule? schedule;
  List<ScheduleIncluded?>? included;
  List<Stage> stages = [];

  getAllSchedule() async {
    try {
      await _scheduleRepository.getSchedule().then((value) => schedule = value);
      // print("DEBUG: schedule");
      // print(schedule);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getAllIncluded() {
    included = schedule?.included;
    // print("DEBUG: included");
    included?.forEach((element) {
      // print(element?.attributes?.name);
    });
  }

  getAllStages() {
    if (included != null) {
      for (var element in included!) {
        if (element?.type == "stages") {
          if (element?.attributes != null) {
            var stage = Stage(element!.attributes!);
            stages.add(stage);
          }
        }
      }
    }

    //
    // included?.forEach((element) {
    //   if (element?.type == "stages") {
    //     stages?.add(element);
    //   }
    // });
  }

  getAllStageNames() {
    stages.forEach((stage) {
      print(stage.attributes.name?.toUpperCase());
    });
  }
}
