import 'package:flutter/material.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import 'package:mumush/src/screens/timeline/timeline_view_model.dart';

import '../../application/resources/colors.dart';
import '../../data/model/entity/performance.dart';
import '../../data/model/entity/schedule_model.dart';
import '../../data/model/entity/stage.dart';

class TimelineView extends StatefulWidget {
  TimelineView(
      {Key? key,
      required this.day1,
      required this.day2,
      required this.day3,
      required this.day4})
      : super(key: key);

  String day1, day2, day3, day4;

  @override
  State<TimelineView> createState() => TimelineViewState();
}

class TimelineViewState extends State<TimelineView> {
  late List<SquareWidget> squareList = [];
  late List<Performance> activePerformances = [];
  late List<Stage> stages = [];
  Stage selectedStage = Stage(
      ScheduleIncluded(
          attributes: ScheduleIncludedAttributes(name: "GARGANTUA")),
      true);
  Stage placeholderStage = Stage(
      ScheduleIncluded(
          attributes: ScheduleIncludedAttributes(name: "GARGANTUA")),
      true);
  late TimelineViewModel _viewModel;
  var activeDay = 6;
  var isFirstDropdown = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final daysWidth = screenWidth * 0.25;
    return BaseStatefulView<TimelineViewModel>(
        viewModel: getIt<TimelineViewModel>(),
        onInit: (viewModel) async {
          _viewModel = viewModel;
          await _viewModel.getAllScheduleOnlyFromRawData();

          _viewModel.getAllIncluded();
          _viewModel.getAllStagesAndArtists();
          _viewModel.getAllStageNames();
          stages = _viewModel.stages;

          _viewModel.getAllPerformances();
          _viewModel.getAllDays();
          _viewModel.getAllPerformanceDescriptions();
          setState(() {});
          activePerformances = _viewModel.getEventsByStageAndDay(
              stages.first.data.id ?? 11, 6);
          squareList =
              _viewModel.makeSquareListsFromPerformances(activePerformances);
          setState(() {});
          await _viewModel.getAllScheduleByAllMeans();
        },
        builder: (context, viewModel, child) {
          return Container(
            color: primaryTimelineColor,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor: const Color(0xFF17194E)),
                              child: DropdownButton<String>(
                                style: const TextStyle(

                                    // fontSize: 20,
                                    fontFamily: 'SpaceMono',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF67F59)),
                                value: selectedStage.data.attributes?.name
                                    ?.toUpperCase(),
                                isExpanded: true,
                                iconSize: 35,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                items: stages
                                    .map((item) =>
                                        (item.isActive || isFirstDropdown)
                                            ? buildDropdownMenuActiveItem(item)
                                            : buildDropdownMenuItem(item))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    selectedStage =
                                        _viewModel.findStageByUpperCasedTitle(
                                                item!) ??
                                            placeholderStage;
                                    selectedStage.isActive = true;
                                    activePerformances =
                                        _viewModel.getEventsByStageAndDay(
                                            selectedStage.data.id ??
                                                11,
                                            activeDay);
                                    squareList = _viewModel
                                        .makeSquareListsFromPerformances(
                                            activePerformances);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: daysWidth,
                              child: activeDay == 6
                                  ? buildDayOneTextButton(true)
                                  : buildDayOneTextButton(false)),
                          Container(
                            width: daysWidth,
                            // height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                              left: BorderSide(width: 3.0, color: Colors.white),
                            )),
                            child: activeDay == 7
                                ? buildDayTwoTextButton(true)
                                : buildDayTwoTextButton(false),
                          ),
                          Container(
                            width: daysWidth,
                            // height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                              left: BorderSide(width: 3.0, color: Colors.white),
                            )),
                            child: activeDay == 8
                                ? buildDayThreeTextButton(true)
                                : buildDayThreeTextButton(false),
                          ),
                          Container(
                            width: daysWidth,
                            // height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                              left: BorderSide(width: 3.0, color: Colors.white),
                            )),
                            child: activeDay == 9
                                ? buildDayFourTextButton(true)
                                : buildDayFourTextButton(false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        shrinkWrap: true,
                        itemCount: squareList.length,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0),
                        itemBuilder: (BuildContext context, int index) {
                          return squareList.isNotEmpty
                              ? SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 2,
                                  height: 500,
                                  child: Stack(children: [squareList[index]]))
                              : const Text("Error: No Data");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  DropdownMenuItem<String> buildDropdownMenuItem(Stage item) {
    return DropdownMenuItem<String>(
      value: item.data.attributes?.name?.toUpperCase(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
            // height: 80,
            child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Text(
            item.data.attributes?.name?.toUpperCase() ?? "NAME",
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'SpaceMono',
                fontWeight: FontWeight.bold,
                color: Colors.white),
            overflow: TextOverflow.visible,
          ),
        )),
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownMenuActiveItem(Stage item) {
    isFirstDropdown = false;
    return DropdownMenuItem<String>(
      value: item.data.attributes?.name?.toUpperCase(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
            // height: 80,
            child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: FittedBox(
            child: Text(
              item.data.attributes?.name?.toUpperCase() ?? "NAME",
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'SpaceMono',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF67F59)),
              overflow: TextOverflow.visible,
            ),
          ),
        )),
      ),
    );
  }

  TextButton buildDayOneTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFF67F59),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 6;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day1,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 6;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day1,
        ),
      );
    }
  }

  TextButton buildDayTwoTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFF67F59),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 7;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day2,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 7;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day2,
        ),
      );
    }
  }

  TextButton buildDayThreeTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFF67F59),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 8;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day3,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 8;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day3,
        ),
      );
    }
  }

  TextButton buildDayFourTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFF67F59),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 9;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day4,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 9;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.id ?? 11, activeDay);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
            selectedStage.isActive = true;
          });
        },
        child: Text(
          widget.day4,
        ),
      );
    }
  }
}
