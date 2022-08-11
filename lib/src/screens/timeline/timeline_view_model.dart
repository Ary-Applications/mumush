import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:mumush/src/screens/timeline/event.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import '../../data/model/entity/day.dart';
import '../../data/model/entity/performance.dart';
import '../../data/model/entity/schedule_model.dart';
import '../../data/model/entity/stage.dart';
import '../../data/model/repository/schedule/schedule_remote_data_repository.dart';
import '../base/base_view_model.dart';

@injectable
class TimelineViewModel extends BaseViewModel {
  final ScheduleRepository _scheduleRepository;

  Schedule? schedule;
  List<ScheduleIncluded?>? included;
  Stage placeholderStage = Stage(ScheduleIncluded(
      attributes: ScheduleIncludedAttributes(name: "GARGANTUA")));
  List<Stage> stages = [];
  List<Performance> allPerformances = [];
  List<Day> days = [];

  TimelineViewModel(this._scheduleRepository) {
    stages = [placeholderStage];
  }

  List<SquareWidget> makeSquareListsFromPerformances(
      List<Performance> performances) {
    List<SquareWidget> squaresToReturn = [];
    for (var performance in performances) {
      var startDate = performance.data.attributes?.start ?? "";
      var endDate = performance.data.attributes?.end ?? "";
      var startToEnd = "$startDate-$endDate";

      var event = Event(performance.data.relationships?.artists?.data?.id ?? "",
          "", (startToEnd));
      squaresToReturn.add(SquareWidget(event: event));
    }
    return squaresToReturn;
  }

  Stage? findStageByUppercasedTitle(String title) {
    Stage? returnStage;
    for (var stage in stages) {
      if (stage.data.attributes?.name == title) {
        returnStage = stage;
      } else if (stage.data.attributes?.name?.toUpperCase() == title) {
        returnStage = stage;
      }
    }
    return returnStage;
  }

  getAllSchedule() async {
    try {
      await _scheduleRepository.getSchedule().then((value) => schedule = value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Performance> getEventsByStageAndDay(int stageId, int dayId) {
    Stage? stage;
    Day? day;
    // String lowercasedStageName = stageName.toLowerCase();
    // String capitalizedStageName = lowercasedStageName.replaceFirst(lowercasedStageName[0], lowercasedStageName[0].toUpperCase());
    List<int> eventIds = [];
    List<Performance> eventsToReturn = [];

    /// Get one stage by stageName
    for (var element in stages) {
      if (element.data.attributes?.id == stageId) {
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
      for (var eventId in eventIds) {
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

  getAllIncluded() {
    included = schedule?.included;
    included?.forEach((element) {});
  }

  getAllStages() {
    stages = [];
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
}
