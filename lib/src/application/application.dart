import 'package:flutter/material.dart';
import 'package:mumush/src/screens/map/map_view.dart';

import '../data/model/entity/schedule_model.dart';
import '../di/injection.dart';
import '../screens/base/base.dart';
import '../screens/home/home_view.dart';
import '../screens/timeline/timeline_view.dart';
import 'appViewModel.dart';

class Mumush extends StatefulWidget {
  const Mumush({Key? key}) : super(key: key);
  static const String _appRestorationScopeId = 'mumush_app';

  @override
  State<Mumush> createState() => _MumushState();
}

class _MumushState extends State<Mumush> {
  int _selectedIndex = 0;
  late Schedule? schedule;

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
        onInit: (viewModel) async {},
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
                      day1: 'THU',
                      day2: 'FRI',
                      day3: 'SAT',
                      day4: 'SUN',
                      day5: 'MON',
                    ),
                    MapView(),
                  ]),
            ),
          );
        });
  }
}
