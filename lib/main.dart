import 'package:first/square_widget.dart';
import 'package:first/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:first/event.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var event = "Event";
    var time = "Time";
    var location = "Location";

    return MaterialApp(
      theme: ThemeData(fontFamily: 'SpaceMono'),
      home: Scaffold(
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.pinkAccent),
          selectedItemColor: Colors.pinkAccent,
          backgroundColor: Colors.white38,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon:Icon(Icons.calendar_month),
              label: 'Schedule',
              backgroundColor: Colors.white,

            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.location_on),
              label: 'Map',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.phone),
              label: 'Contact',
              backgroundColor: Colors.white,
            )
          ],
        ),

        body: TimelineView(
          squareList: [
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
            SquareWidget(event: Event("Event", "Okay", "Time")),
          ],
          items: ['Gargantua','Arboretum','Arts & Crafts','Circus','Kid s Area','Healing'],
          selectedItem: 'Gargantua',
          day1: 'Day1',
          day2: 'Day2',
          day3: 'Day3',
          day4: 'Day4',
          day5: 'Day5',
        ),
      ),
    );
  }
}
