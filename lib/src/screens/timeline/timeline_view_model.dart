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

T? cast<T>(x) => x is T ? x : null;

@injectable
class TimelineViewModel extends BaseViewModel {
  final ScheduleRepository _scheduleRepository;

  Schedule? schedule;
  List<ScheduleIncluded?>? included;
  List<ScheduleIncluded> performanceDescriptions = [];
  Stage placeholderStage = Stage(ScheduleIncluded(
      attributes: ScheduleIncludedAttributes(name: "GARGANTUA")));
  List<Stage> stages = [];
  List<ScheduleIncluded> artists = [];
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

      // ScheduleIncludedRelationshipsPerformances?
      //     // singlePerformanceDataForPerformance =
      //     // cast<ScheduleIncludedRelationshipsPerformances>(
      //     //     performance.included?.relationships?.performances);
      var eventName = performance.included?.attributes?.name;
      var eventShortName = performance.included?.attributes?.shortName;
      var eventLongName = performance.included?.attributes?.longName;

      if (eventName != null) {
        var event = Event(eventName, "", (startToEnd));
        squaresToReturn.add(SquareWidget(event: event));
      } else if (eventShortName != null) {
        var event = Event(eventShortName, "", (startToEnd));
        squaresToReturn.add(SquareWidget(event: event));
      } else if (eventLongName != null) {
        var event = Event(eventLongName, "", (startToEnd));
        squaresToReturn.add(SquareWidget(event: event));
      } else {
        ScheduleIncluded? foundArtist;
        for (var artist in artists) {
          ScheduleIncludedRelationshipsPerformances?
              singlePerformanceDataForArtist =
              cast<ScheduleIncludedRelationshipsPerformances>(
                  artist.relationships?.performances);
          var artistdataId = singlePerformanceDataForArtist?.data?.id;
          var perfDataId = performance.data.attributes?.id;
          if (artistdataId == perfDataId) {
            foundArtist = artist;
          }
        }
        if (foundArtist != null) {
          var name = foundArtist.attributes?.name;
          print("DEBUG: FUCKMESIDEWAYS : $name");
          if (name != null) {
            var event = Event(name, "", (startToEnd));
            squaresToReturn.add(SquareWidget(event: event));
          } else {
            var maybeName = performance.data.relationships?.artists?.data?.id;
            print(
                "DEBUG: ERROR ERROR ERROR!!!!!!!!!!! Could not find NAME!!!!!!! Maybe this? : $maybeName");
            if (maybeName != null) {
              var event = Event(maybeName, "", (startToEnd));
              squaresToReturn.add(SquareWidget(event: event));
            }
          }
        } else {
          print(
              'DEBUG: Error: Could not find matching ids in artists and performances');
          var maybeName = performance.data.relationships?.artists?.data?.id;
          if (maybeName != null) {
            var event = Event(maybeName, "", (startToEnd));
            squaresToReturn.add(SquareWidget(event: event));
            print('DEBUG: Name found as artist data id');
          } else {
            print('DEBUG: Name could not be found in artist data either');
          }
        }
      }
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
          ScheduleIncludedRelationships dayRelList = day.data.relationships!;
          List<ScheduleIncludedRelationshipsPerformances?>? dayPerfList =
              dayRelList.performances;
          if (dayPerfList != null) {
            for (var stagePerfElement in stagePerfList) {
              for (var dayPerfElement in dayPerfList) {
                if (dayPerfElement?.data?.id == stagePerfElement?.data?.id) {
                  eventIds.add(dayPerfElement!.data!.id!);
                }
              }
            }
          }
        }
      }
    } else {
      print("Error: getEventsByStageAndDay: Could not find stage");
    }

    for (var description in performanceDescriptions) {
      // Might be an array
      ScheduleIncludedRelationshipsPerformances? singleDescription =
          cast<ScheduleIncludedRelationshipsPerformances>(
              description.relationships?.performances);
      for (var eventId in eventIds) {
        if (singleDescription?.data?.id == eventId) {}
      }
    }

    for (var performance in allPerformances) {
      for (var eventId in eventIds) {
        if (performance.data.id == eventId) {
          eventsToReturn.add(performance);
        }
      }
    }
    List<ScheduleIncluded> includedsToAdd = [];
    if (included != null) {
      for (var include in included!) {
        ScheduleIncludedRelationshipsPerformances? singlePerformanceData =
            cast<ScheduleIncludedRelationshipsPerformances>(
                include?.relationships?.performances);

        for (var eventId in eventIds) {
          if (singlePerformanceData?.data?.id == eventId) {
            includedsToAdd.add(include!);
            String? dtsg = include.attributes?.longName;
            String? dtsggg = include.attributes?.shortName;
            String? dtsggga = include.attributes?.name;
            print("DEBUG: GOT SINGLE PERFORMANCE LONG NAME $dtsg");
            print("DEBUG: ORRRRR GOT SINGLE PERFORMANCE SHORT NAME $dtsggg");
            print("DEBUG: ORRRRR ORRRRRR GOT SINGLE PERFORMANCE NAME $dtsggga");
          }
        }
      }
    }

    eventsToReturn.forEach((eventTeReturnelement) {
      includedsToAdd.forEach((includedElement) {
        ScheduleIncludedRelationshipsPerformances? singlePerformanceData =
            cast<ScheduleIncludedRelationshipsPerformances>(
                includedElement.relationships?.performances);
        if (eventTeReturnelement.data.id == singlePerformanceData?.data?.id) {
          eventTeReturnelement.included = includedElement;
        }
      });
    });

    debugPrint("DEBUG: Events to return by stage Data IDs: ");
    for (var element in eventsToReturn) {
      debugPrint(element.data.relationships?.artists?.data?.id);
    }

    debugPrint("DEBUG: Events to return by INCLUDED: ");
    for (var element in eventsToReturn) {
      var attributesName = element.included?.attributes?.name;
      if ((attributesName != null) && (attributesName != "")) {
        debugPrint("DEBUG: attributesName: $attributesName");
      } else {
        var attributesShortName = element.included?.attributes?.shortName;
        if (attributesShortName != null) {
          debugPrint("DEBUG: attributesShortName: $attributesShortName");
        } else {
          var attributesLongName = element.included?.attributes?.longName;
          if (attributesLongName != null) {
            debugPrint("DEBUG: attributesLongName: $attributesLongName");
          } else {
            debugPrint(
                "DEBUG: GOT Neither name, or short or long name for: $element");
          }
        }
      }
    }
    return eventsToReturn;
  }

  getAllIncluded() {
    included = schedule?.included;
    included?.forEach((element) {});
  }

  getAllPerformanceDescriptions() {
    if (included != null) {
      for (var element in included!) {
        if (element?.type == "performanceDescriptions") {
          performanceDescriptions.add(element!);
        }
      }
    }
  }

  getAllStagesAndArtists() {
    stages = [];

    if (included != null) {
      for (var element in included!) {
        if (element?.type == "stages") {
          if (element?.attributes != null) {
            var stage = Stage(element!);
            stages.add(stage);
          }
        }
        if (element?.type == "artists") {
          artists.add(element!);
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
