import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  late String _state;

  void choosingState(String value) {
    _state = value;
    notifyListeners();
  }

  String get getState => _state;
}
