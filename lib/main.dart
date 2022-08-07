import 'package:flutter/material.dart';
import 'package:mumush/src/application/application.dart';
import 'package:mumush/src/di/injection.dart';

void main() async {
  // Set up injectable
  configureDependencies();

  runApp(const Mumush());
}
