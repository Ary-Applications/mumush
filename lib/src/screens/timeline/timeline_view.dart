import 'package:first/square_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatefulWidget {
  TimelineView(
      {Key? key,
        required this.squareList,
        required this.items,
        required this.selectedItem,
        required this.day1,
        required this.day2,
        required this.day3,
        required this.day4,
        required this.day5})
      : super(key: key);

  final List<SquareWidget> squareList;
  final List<String> items;
  String? selectedItem;
  String day1, day2, day3, day4, day5;

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectedItem,
                    isExpanded: true,
                    iconSize: 40,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black26,
                    ),
                    items: widget.items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                          height: 80,
                          child: Center(
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.visible,
                              ))),
                    ))
                        .toList(),
                    onChanged: (item) {
                      setState(() {
                        this.widget.selectedItem = item;
                      });
                    },
                  ),
                ),
              )),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 20, 0, 0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: Colors.black),
                      )),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(10, 40),
                      textStyle: TextStyle(fontSize: 25),
                      primary: Colors.black,
                    ),
                    onPressed: () {},
                    child: Text(widget.day1),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: Colors.black),
                      )),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(10, 40),
                      textStyle: TextStyle(fontSize: 25),
                      primary: Colors.black,
                    ),
                    onPressed: () {},
                    child: Text(widget.day2),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: Colors.black),
                      )),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(10, 40),
                      textStyle: TextStyle(fontSize: 25),
                      primary: Colors.black,
                    ),
                    onPressed: () {},
                    child: Text(widget.day3),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: Colors.black),
                      )),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(10, 40),
                      textStyle: TextStyle(fontSize: 25),
                      primary: Colors.black,
                    ),
                    onPressed: () {},
                    child: Text(widget.day4),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 3.0, color: Colors.black),
                        right: BorderSide(width: 3.0, color: Colors.black),
                      )),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(10, 40),
                      textStyle: TextStyle(fontSize: 25),
                      primary: Colors.black,
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            shrinkWrap: true,
            itemCount: widget.squareList.length,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: (MediaQuery.of(context).size.width) / 2,
                  height: 500,
                  child: Stack(children: [
                    Container(
                      width: (MediaQuery.of(context).size.width) / 2,
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
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 5;
    canvas.drawLine(Offset(size.width * 0, size.height * 0.53),
        Offset(size.width * 1, size.height * 0.53), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
