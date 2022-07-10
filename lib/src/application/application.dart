import 'package:flutter/material.dart';

import '../screens/home/home_view.dart';

class Mumush extends StatelessWidget {
  const Mumush({Key? key}) : super(key: key);

  static const String _appRestorationScopeId = 'mumush_app';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: _appRestorationScopeId,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}