import 'package:flutter/material.dart';
import 'package:mumush/src/screens/map/map_view.dart';

import '../screens/home/home_view.dart';
import '../screens/timeline/event.dart';
import '../screens/timeline/square_widget.dart';
import '../screens/timeline/timeline_view.dart';

class Mumush extends StatefulWidget {
  const Mumush({Key? key}) : super(key: key);
  static const String _appRestorationScopeId = 'mumush_app';

  @override
  State<Mumush> createState() => _MumushState();
}

class _MumushState extends State<Mumush> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: Mumush._appRestorationScopeId,
      theme: ThemeData(fontFamily: 'SpaceMono'),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(color: Colors.pinkAccent),
          selectedItemColor: Colors.pinkAccent,
          onTap: onTapped,
          backgroundColor: Colors.white38,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Schedule',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
              backgroundColor: Colors.white,
            )
          ],
        ),
        body: PageView(controller: pageController, children: [
          HomeView(),
          TimelineView(
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
            items: const [
              'Gargantua',
              'Arboretum',
              'Arts & Crafts',
              'Circus',
              'Kid s Area',
              'Healing'
            ],
            selectedItem: 'Gargantua',
            day1: 'Day1',
            day2: 'Day2',
            day3: 'Day3',
            day4: 'Day4',
            day5: 'Day5',
          ),
          MapView(),
        ]),
      ),
    );
  }
}
