import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mumush/src/screens/timeline/event.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/entity/day.dart';
import '../../data/model/entity/performance.dart';
import '../../data/model/entity/schedule_model.dart';
import '../../data/model/entity/stage.dart';
import '../../data/model/repository/schedule/schedule_remote_data_repository.dart';
import '../../data/network/api_constants.dart';
import '../../data/network/base_response.dart';
import '../../data/network/network_request_exception.dart';
import '../base/base_view_model.dart';

T? cast<T>(x) => x is T ? x : null;

@injectable
class TimelineViewModel extends BaseViewModel {
  final ScheduleRepository _scheduleRepository;
  SharedPreferences? prefs;

  Schedule? schedule;
  List<ScheduleIncluded?>? included;
  List<ScheduleIncluded> performanceDescriptions = [];
  Stage placeholderStage = Stage(
      ScheduleIncluded(
          attributes: ScheduleIncludedAttributes(name: "GARGANTUA")),
      true);
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
      endDate = formatEndDate(endDate);

      var startToEnd = "$startDate-$endDate";
      var eventName = performance.included?.attributes?.name;
      var eventShortName = performance.included?.attributes?.shortName;
      var eventLongName = performance.included?.attributes?.longName;

      if (eventShortName != null) {
        var event = Event(eventShortName, "", (startToEnd));
        squaresToReturn.add(SquareWidget(event: event));
      } else if (eventName != null) {
        var event = Event(eventName, "", (startToEnd));
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
          var artistId = singlePerformanceDataForArtist?.data?.id;
          var perfDataId = performance.data.attributes?.id;
          if (artistId == perfDataId) {
            foundArtist = artist;
          }
        }
        if (foundArtist != null) {
          var name = foundArtist.attributes?.name;
          print("DEBUG: Could find artist from artists attributes: $name");
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
            print('DEBUG: Name found in activities');
            if (performance.data.attributes?.activity != null) {
              var activityName = performance.data.attributes?.activity;
              var event = Event(activityName ?? "", "", (startToEnd));
              squaresToReturn.add(SquareWidget(event: event));
            } else {
              print('DEBUG: Name could not be found');
            }
          }
        }
      }
    }
    return squaresToReturn;
  }

  String formatEndDate(String endDate) {
    switch (endDate) {
      case "24:00":
        return "00:00";
      case "25:00":
        return "01:00";
      case "26:00":
        return "02:00";
      case "27:00":
        return "03:00";
      case "28:00":
        return "04:00";
      case "29:00":
        return "05:00";
      default:
        return endDate;
    }
  }

  Stage? findStageByUpperCasedTitle(String title) {
    Stage? returnStage;
    for (var stage in stages) {
      stage.isActive = false;
      if (stage.data.attributes?.name == title) {
        returnStage = stage;
      } else if (stage.data.attributes?.name?.toUpperCase() == title) {
        returnStage = stage;
      }
    }
    return returnStage;
  }

  T? _getDecodedObj<T>(String responseBody, BaseResponseType baseResponseType) {
    T? decodedObj;
    try {
      var baseResponse = BaseResponseFactory.getBaseResponse(baseResponseType)!;
      decodedObj = baseResponse.decode(responseBody) as T;
    } catch (error) {
      debugPrint("Decoding exception:" + error.toString());
      throw DecodableException(error.toString());
    }
    return decodedObj;
  }

  getAllSchedule() async {
    prefs = await SharedPreferences.getInstance();
    final scheduleFromSharedPrefs = prefs?.getString('json');
    if (scheduleFromSharedPrefs != null) {
      schedule = _getDecodedObj<Schedule>(
          scheduleFromSharedPrefs, BaseResponseType.performancesResponse);
    }
    try {
      final result = await InternetAddress.lookup('api.mumush.world');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        try {
          await _scheduleRepository
              .getSchedule()
              .then((value) => schedule = value);
        } catch (e) {
          debugPrint(e.toString());
          if (schedule == null) {
            final String response =
                await rootBundle.loadString('assets/rawData.json');
            schedule = _getDecodedObj<Schedule>(
                response, BaseResponseType.performancesResponse);
          }
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      final String response =
          await rootBundle.loadString('assets/rawData.json');
      schedule = _getDecodedObj<Schedule>(
          response, BaseResponseType.performancesResponse);
    }
  }

  // MARK: - Events by stage and day ids
  List<Performance> getEventsByStageAndDay(int stageId, int dayId) {
    Stage? stage;
    Day? day;
    Day? nextDay;

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
        if (element.data.attributes?.id == dayId + 1) {
          nextDay = element;
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
          List<ScheduleIncludedRelationshipsPerformances?>? nextDayPerfList;
          if (nextDay != null) {
            ScheduleIncludedRelationships nextDayRelList =
                nextDay.data.relationships!;
            nextDayPerfList = nextDayRelList.performances;
          }

          if (dayPerfList != null) {
            for (var performance in allPerformances) {
              for (var stagePerfElement in stagePerfList) {
                if (stagePerfElement?.data?.id == performance.data.id) {
                  for (var dayPerfElement in dayPerfList) {
                    if (dayPerfElement?.data?.id ==
                        stagePerfElement?.data?.id) {
                      var dayStartDateFirstTwoCharacters =
                          performance.data.attributes?.start?.substring(0, 2);
                      if (dayStartDateFirstTwoCharacters != null) {
                        var perfStartDateInt =
                            int.parse(dayStartDateFirstTwoCharacters);
                        if (perfStartDateInt >= 8) {
                          eventIds.add(dayPerfElement!.data!.id!);
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          List<int> nextDayIds = [];
          if (nextDayPerfList != null) {
            for (var stagePerfElement in stagePerfList) {
              for (var nextDayPerf in nextDayPerfList) {
                if (nextDayPerf?.data?.id == stagePerfElement?.data?.id) {
                  nextDayIds.add(nextDayPerf!.data!.id!);
                }
              }
            }
            print('DEBUG: FOUND NEXT DAY IDs');
            print(nextDayIds);
          }

          for (var performance in allPerformances) {
            for (var id in nextDayIds) {
              if (performance.data.id == id) {
                var nextDayEndDateFirstTwoCharacters =
                    performance.data.attributes?.end?.substring(0, 2);
                if (nextDayEndDateFirstTwoCharacters != null) {
                  var nextDayEndDateInt =
                      int.parse(nextDayEndDateFirstTwoCharacters);
                  if (nextDayEndDateInt < 12) {
                    print('DEBUG: FOUND NEXT DAY End dates');
                    print(nextDayEndDateInt);
                    eventIds.add(id);
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

    // debugPrint("DEBUG: Events to return by stage Data IDs: ");
    // for (var element in eventsToReturn) {
    //   debugPrint(element.data.relationships?.artists?.data?.id);
    // }
    //
    // debugPrint("DEBUG: Events to return by INCLUDED: ");
    // for (var element in eventsToReturn) {
    //   var attributesName = element.included?.attributes?.name;
    //   if ((attributesName != null) && (attributesName != "")) {
    //     debugPrint("DEBUG: attributesName: $attributesName");
    //   } else {
    //     var attributesShortName = element.included?.attributes?.shortName;
    //     if (attributesShortName != null) {
    //       debugPrint("DEBUG: attributesShortName: $attributesShortName");
    //     } else {
    //       var attributesLongName = element.included?.attributes?.longName;
    //       if (attributesLongName != null) {
    //         debugPrint("DEBUG: attributesLongName: $attributesLongName");
    //       } else {
    //         debugPrint(
    //             "DEBUG: GOT Neither name, or short or long name for: $element");
    //       }
    //     }
    //   }
    // }
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
            var stage = Stage(element!, false);
            if (stage.data.attributes?.name == "Sound of Light Installation") {
              stage.data.attributes?.name = "Sound of light";
            }
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
    }
  }
}
