import 'package:mumush/src/screens/timeline/event.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:mumush/src/screens/timeline/timeline_view.dart';


void main() => runApp(Mumush());

class Mumush extends StatelessWidget {
  const Mumush({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(fontFamily: 'SpaceMono'),
      home: Scaffold(
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(color: Colors.pinkAccent),
          selectedItemColor: Colors.pinkAccent,
          backgroundColor: Colors.white38,
          currentIndex: 0,
          items: const [
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
          items: const ['Gargantua','Arboretum','Arts & Crafts','Circus','Kid s Area','Healing'],
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
