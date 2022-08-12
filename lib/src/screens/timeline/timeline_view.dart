import 'package:flutter/material.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import 'package:mumush/src/screens/timeline/timeline_view_model.dart';

import '../../data/model/entity/performance.dart';
import '../../data/model/entity/schedule_model.dart';
import '../../data/model/entity/stage.dart';

class TimelineView extends StatefulWidget {
  TimelineView(
      {Key? key,
      required this.day1,
      required this.day2,
      required this.day3,
      required this.day4,
      required this.day5})
      : super(key: key);

  String day1, day2, day3, day4, day5;

  @override
  State<TimelineView> createState() => TimelineViewState();
}

class TimelineViewState extends State<TimelineView> {
  late List<SquareWidget> squareList = [];
  late List<Performance> activePerformances = [];
  late List<Stage> stages = [];
  Stage selectedStage = Stage(ScheduleIncluded(
      attributes: ScheduleIncludedAttributes(name: "GARGANTUA")));
  Stage placeholderStage = Stage(ScheduleIncluded(
      attributes: ScheduleIncludedAttributes(name: "GARGANTUA")));
  late TimelineViewModel _viewModel;
  var activeDay = 1;

  @override
  Widget build(BuildContext context) {
    return BaseStatefulView<TimelineViewModel>(
        viewModel: getIt<TimelineViewModel>(),
        onInit: (viewModel) async {
          _viewModel = viewModel;
          // TODO: Add a loading
          // TODO: If there's connection, get schedule online, if not, schedule from local db/json.
          await _viewModel.getAllSchedule();

          _viewModel.getAllIncluded();
          _viewModel.getAllStages();

          _viewModel.getAllStageNames();

          stages = _viewModel.stages;
          _viewModel.getAllPerformances();
          _viewModel.getAllDays();
          activePerformances = _viewModel.getEventsByStageAndDay(
              stages.first.data.attributes?.id ?? 1, 1);
          squareList =
              _viewModel.makeSquareListsFromPerformances(activePerformances);
          setState(() {});
        },
        builder: (context, viewModel, child) {
          return Container(
            color: const Color(0xFF17194E),
            child: Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const FittedBox(
                      fit: BoxFit.cover,
                      child:
                          Image(image: AssetImage('assets/art/backgraund.png')),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(canvasColor: Color(0xFF17194E)),
                                child: DropdownButton<String>(
                                  value: selectedStage.data.attributes?.name
                                      ?.toUpperCase(),
                                  isExpanded: true,
                                  iconSize: 40,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items: stages
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.data.attributes?.name
                                                ?.toUpperCase(),
                                            child: SizedBox(
                                                height: 80,
                                                child: Center(
                                                    child: FittedBox(
                                                  child: Text(
                                                    item.data.attributes?.name
                                                            ?.toUpperCase() ??
                                                        "NAME",
                                                    style: const TextStyle(
                                                        fontSize: 30.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ))),
                                          ))
                                      .toList(),
                                  onChanged: (item) {
                                    setState(() {
                                      selectedStage =
                                          _viewModel.findStageByUppercasedTitle(
                                                  item!) ??
                                              placeholderStage;
                                      activePerformances =
                                          _viewModel.getEventsByStageAndDay(
                                              selectedStage
                                                      .data.attributes?.id ??
                                                  1,
                                              1);
                                      squareList = _viewModel
                                          .makeSquareListsFromPerformances(
                                              activePerformances);
                                    });
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 20, 0, 0),
                        child: Row(
                          children: [
                            Container(
                                child: activeDay == 1
                                    ? buldDayOneTextButton(true)
                                    : buldDayOneTextButton(false)),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: activeDay == 2
                                  ? buldDayTwoTextButton(true)
                                  : buldDayTwoTextButton(false),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: activeDay == 3
                                  ? buldDayThreeTextButton(true)
                                  : buldDayThreeTextButton(false),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: activeDay == 4
                                  ? buldDayFourTextButton(true)
                                  : buldDayFourTextButton(false),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: activeDay == 5
                                  ? buldDayFiveTextButton(true)
                                  : buldDayFiveTextButton(false),
                            ),
                          ],
                        ),
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
                          return !squareList.isEmpty
                              ? SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 2,
                                  height: 500,
                                  child: Stack(children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                              2,
                                      height: 500,
                                      child: CustomPaint(
                                        foregroundPainter: LinePainter(),
                                      ),
                                    ),
                                    squareList[index]
                                  ]))
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

  TextButton buldDayOneTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
          primary:Color(0xFFF67F59),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 1;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 1);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day1,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          primary: Colors.white,
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 1;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 1);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day1,
        ),
      );
    }
  }

  TextButton buldDayTwoTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color:Color(0xFFF67F59)),
          primary:Color(0xFFF67F59),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 2;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 2);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day2,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          primary: Colors.white,
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 2;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 2);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day2,
        ),
      );
    }
  }

  TextButton buldDayThreeTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
          primary: Color(0xFFF67F59),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 3;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 3);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day3,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          primary: Colors.white,
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 3;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 3);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day3,
        ),
      );
    }
  }

  TextButton buldDayFourTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Color(0xFFF67F59)),
          primary:Color(0xFFF67F59),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 4;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 4);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day4,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          primary: Colors.white,
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 4;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 4);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day4,
        ),
      );
    }
  }

  TextButton buldDayFiveTextButton(bool active) {
    if (active) {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color:Color(0xFFF67F59)),
          primary: Color(0xFFF67F59),
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 5;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 5);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day5,
        ),
      );
    } else {
      return TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(10, 40),
          textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: 'SpaceMono',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          primary: Colors.white,
        ),
        autofocus: true,
        onPressed: () {
          activeDay = 5;
          setState(() {
            activePerformances = _viewModel.getEventsByStageAndDay(
                selectedStage.data.attributes?.id ?? 1, 5);
            squareList =
                _viewModel.makeSquareListsFromPerformances(activePerformances);
          });
        },
        child: Text(
          widget.day5,
        ),
      );
    }
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..color = Color(0xFFF67F59);
    canvas.drawLine(Offset(size.width * 0, size.height * 0.53),
        Offset(size.width * 1, size.height * 0.53), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
