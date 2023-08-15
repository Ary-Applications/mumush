import 'dart:async';

import 'package:flutter/services.dart';

///
/// Class for getting the native timezone.
///
class FlutterTimezone {
  static const MethodChannel _channel = MethodChannel('flutter_timezone');

  ///
  /// Returns local timezone from the native layer.
  ///
  static Future<String> getLocalTimezone() async {
    final String? localTimezone =
    await _channel.invokeMethod("getLocalTimezone");
    if (localTimezone == null) {
      throw ArgumentError("Invalid return from platform getLocalTimezone()");
    }
    return localTimezone;
  }

  ///
  /// Gets the list of available timezones from the native layer.
  ///
  static Future<List<String>> getAvailableTimezones() async {
    final List<String>? availableTimezones =
    await _channel.invokeListMethod<String>("getAvailableTimezones");
    if (availableTimezones == null) {
      throw ArgumentError(
          "Invalid return from platform getAvailableTimezones()");
    }
    return availableTimezones;
  }
}
