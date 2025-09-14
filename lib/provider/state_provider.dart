import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  late String _state;

  void theState(String value) {
    _state = value;
    notifyListeners();
  }

  String get state => _state;
}
