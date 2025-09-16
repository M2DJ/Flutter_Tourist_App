import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  String _currentState = '';

  AppStateProvider() {
    _currentState = '';
  }

  void selectState(String value) {
    _currentState = value;
    notifyListeners();
  }

  String get selectedState => _currentState;
}
