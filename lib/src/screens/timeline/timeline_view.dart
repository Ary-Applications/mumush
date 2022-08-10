import 'package:flutter/material.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import 'package:mumush/src/screens/timeline/timeline_view_model.dart';

import '../../application/appViewModel.dart';

class TimelineView extends StatefulWidget {

  TimelineView(
      {Key? key,
      required this.squareList,
      required this.stages,
      required this.selectedItem,
      required this.day1,
      required this.day2,
      required this.day3,
      required this.day4,
      required this.day5})
      : super(key: key);

  List<SquareWidget> squareList;
  List<Stage> stages;
  String? selectedItem;
  String day1, day2, day3, day4, day5;

  @override
  State<TimelineView> createState() => TimelineViewState();
}

class TimelineViewState extends State<TimelineView> {
  late TimelineViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseStatefulView<TimelineViewModel>(
        viewModel: getIt<TimelineViewModel>(),
        onInit: (viewModel) {
          _viewModel = viewModel;
          // TODO: If there's connection, get schedule online, if not, schedule from local db/json.
          // _viewModel.getSchedule();
        },
        builder: (context, viewModel, child) {
          return Container(
            color: const Color(0xFF17194E),
            child: Stack(
              children: [
                Container(
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
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(canvasColor: Color(0xFF17194E)),
                                child: DropdownButton<String>(
                                  value: widget.selectedItem,
                                  isExpanded: true,
                                  iconSize: 40,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items: widget.stages
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.attributes.name,
                                            child: SizedBox(
                                                height: 80,
                                                child: Center(
                                                    child: Text(
                                                  item.attributes.name ?? "NAME",
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ))),
                                          ))
                                      .toList(),
                                  onChanged: (item) {
                                    setState(() {
                                      widget.selectedItem = item;
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
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(10, 40),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Text(
                                  widget.day1,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(10, 40),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Text(widget.day2),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(10, 40),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Text(widget.day3),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(10, 40),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Text(widget.day4),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                left:
                                    BorderSide(width: 3.0, color: Colors.white),
                              )),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(10, 40),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Text(widget.day5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        shrinkWrap: true,
                        itemCount: widget.squareList.length,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0),
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              width: (MediaQuery.of(context).size.width) / 2,
                              height: 500,
                              child: Stack(children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 2,
                                  height: 500,
                                  child: CustomPaint(
                                    foregroundPainter: LinePainter(),
                                  ),
                                ),
                                widget.squareList[index]
                              ]));
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

  methodInChild(List<Stage> stages) {
    setState(() {
      // widget.stages = stages;
    });
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
