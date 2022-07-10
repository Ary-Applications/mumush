import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  var _disposed = false;

  @override
  void dispose() {
    super.dispose();

    _disposed = true;
  }

  void setState() {
    if (!_disposed) {
      notifyListeners();
    }
  }
}