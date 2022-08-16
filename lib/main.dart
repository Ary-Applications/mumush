import 'package:flutter/material.dart';
import 'package:mumush/src/application/application.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Set up injectable
  configureDependencies();
  SharedPreferences.setMockInitialValues({});
  runApp(const Mumush());
}
