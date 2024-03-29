import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

  List<SquareWidget> makeSquareListsFromPerformances(List<int> scheduledIds,
      String stageName, List<Performance> performances) {
    List<SquareWidget> squaresToReturn = [];
    for (var performance in performances) {
      var startDate = performance.data.attributes?.start ?? "";
      var endDate = performance.data.attributes?.end ?? "";
      endDate = formatEndDate(endDate);
      var startToEnd = "$startDate-$endDate";
      var eventName = performance.data.attributes?.activity;
      var eventShortName = performance.included?.attributes?.shortName;
      var eventLongName = performance.included?.attributes?.longName;

      if (eventShortName != null && eventShortName != "") {
        var event = Event(
            performance.data.id,
            eventShortName,
            stageName,
            (startToEnd),
            getDateFromNumber(
                performance.data.relationships?.days?.data?.id ?? 0,
                performance.data?.attributes?.start ?? "0"));
        var widgetToAdd = SquareWidget(event: event);
        widgetToAdd.isActive = performance.isCurrent;
        widgetToAdd.isScheduled = scheduledIds.contains(event.id);
        squaresToReturn.add(widgetToAdd);
      } else if (eventName != null && eventName != "") {
        var event = Event(
            performance.data.id,
            eventName,
            stageName,
            (startToEnd),
            getDateFromNumber(
                performance.data.relationships?.days?.data?.id ?? 0,
                performance.data?.attributes?.start ?? "0"));
        var widgetToAdd = SquareWidget(event: event);
        widgetToAdd.isActive = performance.isCurrent;
        widgetToAdd.isScheduled = scheduledIds.contains(event.id);
        squaresToReturn.add(widgetToAdd);
      } else if (eventLongName != null) {
        var event = Event(
            performance.data.id,
            eventLongName,
            stageName,
            (startToEnd),
            getDateFromNumber(
                performance.data.relationships?.days?.data?.id ?? 0,
                performance.data?.attributes?.start ?? "0"));
        var widgetToAdd = SquareWidget(event: event);
        widgetToAdd.isActive = performance.isCurrent;
        widgetToAdd.isScheduled = scheduledIds.contains(event.id);
        squaresToReturn.add(widgetToAdd);
      } else {
        ScheduleIncluded? foundArtist;
        for (var artist in artists) {
          ScheduleIncludedRelationshipsPerformances?
              singlePerformanceDataForArtist =
              cast<ScheduleIncludedRelationshipsPerformances>(
                  artist.relationships?.performances[0]);
          var artistId = singlePerformanceDataForArtist?.data?.id;
          var perfDataId = performance.data.attributes?.id;
          if (artistId == perfDataId) {
            foundArtist = artist;
          }
        }
        if (foundArtist != null) {
          var name = foundArtist.attributes?.name;
          if (kDebugMode) {
            print("DEBUG: Could find artist from artists attributes: $name");
          }
          if (name != null) {
            var event = Event(
                performance.data.id,
                name,
                stageName,
                (startToEnd),
                getDateFromNumber(
                    performance.data.relationships?.days?.data?.id ?? 0,
                    performance.data?.attributes?.start ?? "0"));
            var widgetToAdd = SquareWidget(event: event);
            widgetToAdd.isActive = performance.isCurrent;
            widgetToAdd.isScheduled = scheduledIds.contains(event.id);
            squaresToReturn.add(widgetToAdd);
          } else {
            var maybeName = performance.data.relationships?.artists?.data?.id;
            if (kDebugMode) {
              print("DEBUG: Could not find NAME! Maybe this? : $maybeName");
            }
            if (maybeName != null) {
              var event = Event(
                  performance.data.id,
                  maybeName,
                  stageName,
                  (startToEnd),
                  getDateFromNumber(
                      performance.data.relationships?.days?.data?.id ?? 0,
                      performance.data?.attributes?.start ?? "0"));
              var widgetToAdd = SquareWidget(event: event);
              widgetToAdd.isActive = performance.isCurrent;
              widgetToAdd.isScheduled = scheduledIds.contains(event.id);
              squaresToReturn.add(widgetToAdd);
            }
          }
        } else {
          if (kDebugMode) {
            print(
                'DEBUG: Error: Could not find matching ids in artists and performances');
          }
          var maybeName = performance.data.relationships?.artists?.data?.id;
          if (maybeName != null) {
            var event = Event(
                performance.data.id,
                maybeName,
                stageName,
                (startToEnd),
                getDateFromNumber(
                    performance.data.relationships?.days?.data?.id ?? 0,
                    performance.data?.attributes?.start ?? "0"));
            var widgetToAdd = SquareWidget(event: event);
            widgetToAdd.isActive = performance.isCurrent;
            widgetToAdd.isScheduled = scheduledIds.contains(event.id);
            squaresToReturn.add(widgetToAdd);
            if (kDebugMode) {
              print('DEBUG: Name found as artist data id');
            }
          } else {
            if (kDebugMode) {
              print('DEBUG: Name found in activities');
            }
            if (performance.data.attributes?.activity != null) {
              var activityName = performance.data.attributes?.activity;
              var event = Event(
                  performance.data.id,
                  activityName ?? "",
                  stageName,
                  (startToEnd),
                  getDateFromNumber(
                      performance.data.relationships?.days?.data?.id ?? 0,
                      performance.data?.attributes?.start ?? "0"));
              var widgetToAdd = SquareWidget(event: event);
              widgetToAdd.isActive = performance.isCurrent;
              widgetToAdd.isScheduled = scheduledIds.contains(event.id);
              squaresToReturn.add(widgetToAdd);
            } else {
              if (kDebugMode) {
                print('DEBUG: Name could not be found');
              }
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
      debugPrint("Decoding exception:$error");
      throw DecodableException(error.toString());
    }
    return decodedObj;
  }

  getAllScheduleOnlyFromRawData() async {
    final String rawResponse =
        await rootBundle.loadString('assets/rawdata.json');
    schedule ??= _getDecodedObj<Schedule>(
        rawResponse, BaseResponseType.performancesResponse);
  }

  getAllScheduleByAllMeans() async {
    final String rawResponse =
        await rootBundle.loadString('assets/rawdata.json');

    prefs = await SharedPreferences.getInstance();
    final scheduleFromSharedPrefs = prefs?.getString('json');

    try {
      final result = await InternetAddress.lookup('api.mumush.world');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('connected');
        }

        try {
          final scheduleFromHttp = await _scheduleRepository.getSchedule();
          if (scheduleFromHttp != null) {
            schedule = scheduleFromHttp;
            // Save the schedule fetched from HTTP to SharedPreferences
            prefs?.setString('json', jsonEncode(schedule));
          }
        } catch (e) {
          debugPrint(e.toString());
          if (scheduleFromSharedPrefs != null) {
            schedule = _getDecodedObj<Schedule>(
                scheduleFromSharedPrefs, BaseResponseType.performancesResponse);
          } else {
            schedule = _getDecodedObj<Schedule>(
                rawResponse, BaseResponseType.performancesResponse);
          }
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }

      if (scheduleFromSharedPrefs != null) {
        schedule = _getDecodedObj<Schedule>(
            scheduleFromSharedPrefs, BaseResponseType.performancesResponse);
      } else {
        schedule = _getDecodedObj<Schedule>(
            rawResponse, BaseResponseType.performancesResponse);
      }
    }
  }

  Future<void> getScheduleByHttp(String rawResponse) async {
    try {
      final result = await InternetAddress.lookup('api.mumush.world');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('connected');
        }

        try {
          await _scheduleRepository
              .getSchedule()
              .then((value) => schedule = value);
        } catch (e) {
          debugPrint(e.toString());
          schedule ??= _getDecodedObj<Schedule>(
              rawResponse, BaseResponseType.performancesResponse);
        }
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('not connected');
      }

      schedule = _getDecodedObj<Schedule>(
          rawResponse, BaseResponseType.performancesResponse);
    }
  }

  int? getCurrentDayNumberFromDate(int dayNr) {
    switch (dayNr) {
      case 17:
        return 6;
      case 18:
        return 7;
      case 19:
        return 8;
      case 20:
        return 9;
      default:
        return null;
    }
  }

  // MARK: - Events by stage and day ids
  List<Performance> getEventsByStageAndDay(int stageId, int dayId) {
    Stage? stage;
    Day? day;
    Day? nextDay;

    debugPrint(
        "DEBUG: getEventsByStageAndDay request with: stageId: $stageId, and dayId $dayId");
    List<int> eventIds = [];
    List<Performance> eventsToReturn = [];
    if (kDebugMode) {
      print("DateTime");
      print(DateTime.now());
    }

    final currentDate = DateTime.now();
    final currentDateDay = currentDate.day;
    final currentDateHour = currentDate.hour;

    /// Get one stage by stageName
    for (var element in stages) {
      if (element.data.id == stageId) {
        stage = element;
      }
    }

    if (stage != null) {
      /// Get one day by dayID
      for (var element in days) {
        if (element.data.id == dayId) {
          debugPrint("DEBUG: Found day element with id: $dayId");
          day = element;
        }
        if (element.data.id == dayId + 1) {
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
                      var dayEndDateFirstTwoCharacters =
                          performance.data.attributes?.end?.substring(0, 2);
                      if ((dayStartDateFirstTwoCharacters != null &&
                          dayEndDateFirstTwoCharacters != null)) {
                        var perfStartDateInt =
                            int.parse(dayStartDateFirstTwoCharacters);
                        var perfEndDateInt =
                            int.parse(dayEndDateFirstTwoCharacters);
                        if (perfStartDateInt >= 8) {
                          if (getCurrentDayNumberFromDate(currentDateDay) ==
                              dayId) {
                            if ((currentDateHour >= perfStartDateInt) &&
                                (currentDateHour < perfEndDateInt)) {
                              performance.isCurrent = true;
                            }
                          }
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
            if (kDebugMode) {
              print('DEBUG: FOUND NEXT DAY IDs');
              print(nextDayIds);
            }
          }

          for (var performance in allPerformances) {
            for (var id in nextDayIds) {
              if (performance.data.id == id) {
                var nextDayStartDateFirstTwoCharacters =
                    performance.data.attributes?.start?.substring(0, 2);
                if (nextDayStartDateFirstTwoCharacters != null) {
                  var nextDayStartDateInt =
                      int.parse(nextDayStartDateFirstTwoCharacters);
                  if (nextDayStartDateInt <= 8) {
                    if (kDebugMode) {
                      print('DEBUG: FOUND NEXT DAY End dates');
                      print(nextDayStartDateInt);
                    }
                    eventIds.add(id);
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Error: getEventsByStageAndDay: Could not find stage");
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
            if (kDebugMode) {
              String? dtsggga = include.attributes?.name;
              print("DEBUG: OR GOT SINGLE PERFORMANCE NAME $dtsggga");
            }
          }
        }
      }
    }

    for (var eventTeReturnelement in eventsToReturn) {
      for (var includedElement in includedsToAdd) {
        ScheduleIncludedRelationshipsPerformances? singlePerformanceData =
            cast<ScheduleIncludedRelationshipsPerformances>(
                includedElement.relationships?.performances);
        if (eventTeReturnelement.data.id == singlePerformanceData?.data?.id) {
          eventTeReturnelement.included = includedElement;
        }
      }
    }

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
    for (var stage in stages) {
      debugPrint("DEBUG: Stage with ID: ${stage.data.id}");
      debugPrint(stage.data.attributes?.name?.toUpperCase());
    }
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

  getDateFromNumber(int number, String hourString) {
    if (number < 6 || number > 10) {
      throw ArgumentError('Number should be between 6 and 10');
    }

    final hourParts = hourString.split(':');
    if (hourParts.length != 2) {
      throw ArgumentError('Hour should be in the format "HH:mm"');
    }

    final hour = int.tryParse(hourParts[0]);
    final minute = int.tryParse(hourParts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour >= 24 ||
        minute < 0 ||
        minute >= 60) {
      throw ArgumentError('Invalid hour or minute');
    }

    final startingDate = DateTime(2023, 8, 17);
    final daysToAdd = number - 6;

    final dateWithoutTime = startingDate.add(Duration(days: daysToAdd));
    return dateWithoutTime.add(Duration(hours: hour, minutes: minute));
  }
}
