import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/model/entity/schedule_model.dart';
import '../data/model/repository/schedule/schedule_remote_data_repository.dart';
import '../screens/base/base_view_model.dart';

class Stage {
  ScheduleIncluded data;
  LatLng? coords;

  Stage(this.data);
}

class Performance {
  ScheduleData data;

  Performance(this.data);
}

class Day {
  ScheduleIncluded data;

  Day(this.data);
}

@injectable
class AppViewModel extends BaseViewModel {
  final ScheduleRepository _scheduleRepository;

  AppViewModel(this._scheduleRepository);

  Schedule? schedule;
  List<ScheduleIncluded?>? included;
  List<Stage> stages = [];
  List<Performance> allPerformances = [];
  List<Day> days = [];

  getAllSchedule() async {
    try {
      await _scheduleRepository.getSchedule().then((value) => schedule = value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getAllIncluded() {
    included = schedule?.included;
    included?.forEach((element) {});
  }

  getAllStages() {
    if (included != null) {
      for (var element in included!) {
        if (element?.type == "stages") {
          if (element?.attributes != null) {
            var stage = Stage(element!);
            stages.add(stage);
          }
        }
      }
    }
  }

  getAllDays() {
    if (included != null) {
      for (var element in included!) {
        if (element?.type == "days") {
          if (element?.attributes != null) {
            var day = Day(element!);
            days.add(day);
          }
        }
      }
    }
  }

  getAllStageNames() {
    stages.forEach((stage) {

      print(stage.data.attributes?.name?.toUpperCase());


    });
  }

  getAllPerformances() {
    if (schedule?.data != null) {
      for (var element in schedule!.data!) {
        if (element?.type == "performances") {
          var performance = Performance(element!);
          allPerformances.add(performance);
        }
      }
      allPerformances.forEach((element) {
        print(element.data.attributes?.activity);
      });
    }
  }

  List<Performance> getEventsByStageAndDay(String stageName, int dayId) {
    Stage? stage;
    Day? day;

    List<int> eventIds = [];
    List<Performance> eventsToReturn = [];
    /// Get one stage by stageName
    for (var element in stages) {
      if (element.data.attributes?.name == stageName) {
        stage = element;
      }
    }

    if (stage != null) {
      /// Get one day by dayID
      for (var element in days) {
        if (element.data.attributes?.id == dayId) {
          day = element;
        }
      }
      if (stage.data.relationships != null) {
        ScheduleIncludedRelationships stageRelList = stage.data.relationships!;
        List<ScheduleIncludedRelationshipsPerformances?>? stagePerfList =
            stageRelList.performances;

        if ((day != null) && (stagePerfList != null)) {
          if (stage.data.relationships != null) {
            ScheduleIncludedRelationships dayRelList = day.data.relationships!;
            List<ScheduleIncludedRelationshipsPerformances?>? dayPerfList =
                dayRelList.performances;
            if (dayPerfList != null) {
              for (var stagePerfElement in stagePerfList) {
                for (var dayPerfElement in dayPerfList) {
                  if (dayPerfElement?.data?.id == stagePerfElement?.data?.id) {
                    // ScheduleIncludedRelationshipsPerformancesData = d
                    eventIds.add(dayPerfElement!.data!.id!);
                  }
                }
              }
            }
          }
        }
      }
    } else {
      print("Error: getEventsByStageAndDay: Could not find stage");
    }

    for (var performance in allPerformances) {
      for(var eventId in eventIds) {
        if (performance.data.id == eventId) {
          eventsToReturn.add(performance);
        }
      }
    }
    print("DEBUG: Events to return by stage names: ");
    for (var element in eventsToReturn) {
      print(element.data.relationships?.artists?.data?.id);
    }
    return eventsToReturn;
  }
}
