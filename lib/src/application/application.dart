import 'package:flutter/material.dart';
import 'package:mumush/src/application/appViewModel.dart';
import 'package:mumush/src/screens/map/map_view.dart';

import '../di/injection.dart';
import '../screens/base/base.dart';
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
  late AppViewModel _viewModel;
  List<Performance> firstEventsToShowOnSchedule = [];

  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseStatefulView<AppViewModel>(
        viewModel: getIt<AppViewModel>(),
        onInit: (viewModel) async {
          _viewModel = viewModel;
          _viewModel.notifyListeners();
          // TODO: If there's connection, get schedule online, if not, schedule from local db/json.
          await _viewModel.getAllSchedule();

          _viewModel.getAllIncluded();
          _viewModel.getAllStages();

          _viewModel.getAllStageNames();
          _viewModel.getAllPerformances();
          _viewModel.notifyListeners();
          _viewModel.getAllDays();
          firstEventsToShowOnSchedule =
              _viewModel.getEventsByStageAndDay("Gargantua", 1);
          _viewModel.notifyListeners();
        },
        builder: (context, viewModel, child) {
          return MaterialApp(
            restorationScopeId: Mumush._appRestorationScopeId,
            theme: ThemeData(fontFamily: 'SpaceMono'),
            darkTheme: ThemeData.dark(),
            home: Scaffold(
              backgroundColor: Colors.grey,
              bottomNavigationBar: BottomNavigationBar(
                selectedLabelStyle: const TextStyle(color: Colors.pinkAccent),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white38,
                onTap: onTapped,
                backgroundColor: Colors.black,
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
              body: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    HomeView(),
                    TimelineView(
                      // squareList: [
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      //   SquareWidget(event: Event("Event", "Okay", "Time")),
                      // ],
                      stages: _viewModel.stages,
                      selectedItem:
                          _viewModel.stages.first.data.attributes?.name,
                      day1: 'THU',
                      day2: 'FRI',
                      day3: 'SAT',
                      day4: 'SUN',
                      day5: 'MON',
                      performances: firstEventsToShowOnSchedule,
                    ),
                    MapView(),
                  ]),
            ),
          );
        });
  }
}
